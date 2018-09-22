//
//  Pixels3D.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-08-02.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import Foundation
import Metal
import Pixels

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
    
    // MARK: Metal
    
    var metalLibrary: MTLLibrary!
    
    // MARK: - Life Cycle
    
    init() {
        
        print("Pixels 3D", "-", signature.version)
//        pixels.log(.none, .pixels, signature.version, clean: true)
        
        do {
            metalLibrary = try loadMetalShaderLibrary()
        } catch {
            Pixels.main.log(prefix: "Pixels 3D", .fatal, .pixels, "Metal Library failed to load.", e: error)
        }
        
    }
    
    
    // MARK: - Setup
    
    // MARK: Shaders
    
    enum MetalLibraryError: Error {
        case runtimeERROR(String)
    }
    
    func loadMetalShaderLibrary() throws -> MTLLibrary {
        guard let libraryFile = Bundle(identifier: kBundleId)!.path(forResource: kMetalLibName, ofType: "metallib") else {
            throw MetalLibraryError.runtimeERROR("Pixels 3D Shaders: Metal Library not found.")
        }
        do {
            return try Pixels.main.metalDevice.makeLibrary(filepath: libraryFile)
        } catch { throw error }
    }
    
}
