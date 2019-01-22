//
//  Pixels3D.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-08-02.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
import Pixels
import simd

public class Pixels3D {
    
    public static let main = Pixels3D()
    
    public let engine: _3DEngine = _3DScnEngine()
    
    let pixels = Pixels.main
    
    // MARK: Signature
    
    let kBundleId = "se.hexagons.pixels.3d"
    let kMetalLibName = "Pixels3DShaders"
    
    struct Signature: Encodable {
        let id: String
        let version: String
        let build: Int
        var formatted: String {
            return "\(id) - v\(version) - b\(build)"
        }
    }
    
    var signature: Signature {
        return Signature(id: kBundleId, version: Bundle(identifier: kBundleId)!.infoDictionary!["CFBundleShortVersionString"] as! String, build: Int(Bundle(identifier: kBundleId)!.infoDictionary!["CFBundleVersion"] as! String) ?? -1)
    }
    
    public var overrideWithMetalLibFromApp: Bool = true
    
    // MARK: Metal
    
    var metalLibrary: MTLLibrary!
    
    // MARK: - Life Cycle
    
    init() {
        
        print("Pixels 3D", "-", signature.version)
//        pixels.log(.none, .pixels, signature.version, clean: true)
        
        do {
            metalLibrary = try loadMetalShaderLibrary()
        } catch {
            Pixels3D.log(.fatal, .pixels, "Metal Library failed to load.", e: error)
        }
        
    }
    
    // MARK: - Log
    
    public static func log(pix: PIX? = nil, _ level: Pixels.LogLevel, _ category: Pixels.LogCategory?, _ message: String, loop: Bool = false, clean: Bool = false, e error: Error? = nil, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        Pixels.main.log(prefix: "Pixels 3D", level, category, message, loop: loop, clean: clean, e: error, file, function, line)
    }
    
    // MARK: - Setup
    
    // MARK: Shaders
    
    enum MetalLibraryError: Error {
        case runtimeERROR(String)
    }
    
    func loadMetalShaderLibrary() throws -> MTLLibrary {
        let bundle = overrideWithMetalLibFromApp ? Bundle.main : Bundle(identifier: kBundleId)!
        let bundleId = bundle.bundleIdentifier ?? "unknown-bundle-id"
        if overrideWithMetalLibFromApp {
            Pixels.main.log(prefix: "Pixels 3D", .info, .metal, "Metal Lib from Bundle: \(bundleId) [OVERRIDE]")
        }
        guard let libraryFile = bundle.path(forResource: kMetalLibName, ofType: "metallib") else {
            throw MetalLibraryError.runtimeERROR("Pixels 3D Shaders: Metal Library not found.")
        }
        return try Pixels.main.metalDevice.makeLibrary(filepath: libraryFile)
    }
    
    // MARK: UV
    
    static func uvVecMap(res: PIX.Res) -> [_3DVec] {
        var map: [_3DVec] = []
        for y in 0..<res.h {
            let v = (CGFloat(y) + 0.5) / CGFloat(res.h)
            for x in 0..<res.w {
                let u = (CGFloat(x) + 0.5) / CGFloat(res.w)
                let vec = _3DVec(x: u, y: v, z: 0.0)
                map.append(vec)
            }
        }
        return map
    }
    
}
