//
//  VertexKit.swift
//  VertexKit
//
//  Created by Hexagons on 2018-08-02.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
import PixelKit
import simd

public class VertexKit {
    
    public static let main = VertexKit()
    
    public let engine: _3DEngine = _3DScnEngine()
    
    let pixelKit = PixelKit.main
    
    // MARK: Signature
    
    #if os(iOS)
    let kBundleId = "se.hexagons.pixels.3d"
    let kMetalLibName = "VertexKitShaders"
    #elseif os(macOS)
    let kBundleId = "se.hexagons.pixels.3d.macos"
    let kMetalLibName = "VertexKitShaders-macOS"
    #endif
    
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
    
    // MARK: Metal
    
    var metalLibrary: MTLLibrary!
    
    // MARK: - Life Cycle
    
    init() {
//        pixels.log(.none, .pixels, signature.version, clean: true)
        
        do {
            metalLibrary = try loadMetalShaderLibrary()
        } catch {
            VertexKit.log(.fatal, .pixelKit, "Metal Library failed to load.", e: error)
        }
        
        print("VertexKit", "ready to render.")
        
    }
    
    // MARK: - Log
    
    public static func log(pix: PIX? = nil, _ level: PixelKit.LogLevel, _ category: PixelKit.LogCategory?, _ message: String, loop: Bool = false, clean: Bool = false, e error: Error? = nil, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        PixelKit.main.log(prefix: "VertexKit", level, category, message, loop: loop, clean: clean, e: error, file, function, line)
    }
    
    // MARK: - Setup
    
    // MARK: Shaders
    
    enum MetalLibraryError: Error {
        case runtimeERROR(String)
    }
    
    func loadMetalShaderLibrary() throws -> MTLLibrary {
        guard let libraryFile = Bundle(for: type(of: self)).path(forResource: kMetalLibName, ofType: "metallib") else {
            throw MetalLibraryError.runtimeERROR("VertexKit Shaders: Metal Library not found.")
        }
        return try pixelKit.metalDevice.makeLibrary(filepath: libraryFile)
    }
    
    // MARK: UV
    
    static func uvVecMap(res: PIX.Res) -> [_3DVec] {
        var map: [_3DVec] = []
        for y in 0..<res.h {
            let v = (CGFloat(y) + 0.5) / CGFloat(res.h)
            for x in 0..<res.w {
                let u = (CGFloat(x) + 0.5) / CGFloat(res.w)
                let vec = _3DVec(x: LiveFloat(u), y: LiveFloat(v), z: 0.0)
                map.append(vec)
            }
        }
        return map
    }
    
}
