//
//  VertexKit.swift
//  VertexKit
//
//  Created by Hexagons on 2018-08-02.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
import RenderKit
import PixelKit
import simd
import Resolution

public class VertexKit {
    
    public static let main = VertexKit()
    
    let pixelKit = PixelKit.main
    
    // MARK: - Life Cycle
    
    init() {
        print("VertexKit", "ready to render.")
    }
    
    // MARK: - Log
    
    public static func log(pix: PIX? = nil, _ level: Logger.LogLevel, _ category: Logger.LogCategory?, _ message: String, loop: Bool = false, clean: Bool = false, e error: Error? = nil, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        PixelKit.main.logger.log(prefix: "VertexKit", level, category, message, loop: loop, clean: clean, e: error, file, function, line)
    }
    
    // MARK: - Setup
    
    // MARK: Shaders
    
    enum MetalLibraryError: Error {
        case runtimeERROR(String)
    }
    
    static let metalLibrary: MTLLibrary = {
        do {
            return try PixelKit.main.render.metalDevice.makeDefaultLibrary(bundle: Bundle.module)
        } catch {
            fatalError("Loading Metal Library Failed: \(error.localizedDescription)")
        }
    }()
    
}
