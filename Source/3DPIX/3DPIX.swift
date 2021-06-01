//
//  3DPIX.swift
//  3DPIX
//
//  Created by Hexagons on 2018-09-13.
//  Copyright © 2018 Hexagons. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import RenderKit
import PixelKit
import simd
import Resolution

public class _3DPIX: PIXGenerator, CustomGeometryDelegate {
    
    open override var customMetalLibrary: MTLLibrary { return VertexKit.metalLibrary }
    open override var customVertexShaderName: String? { return "nil3DVTX" }
    open override var shaderName: String { return "color3DPIX" }
    
//    var root: _3DRoot
    
    public var vertices: [RenderKit.Vertex] { return [] }
    public var primativeType: MTLPrimitiveType { return .triangle }
    public var wireframe: Bool { return false }

    public override var uniforms: [CGFloat] {
        color.components
    }

    required init(at resolution: Resolution) {
//        root = VertexKit.main.engine.createRoot(at: res.size)
        super.init(at: resolution)
        customGeometryActive = true
        customGeometryDelegate = self
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    // MAKR: Custom Geometry
    public func customVertices() -> RenderKit.Vertices? {
        
        if vertices.isEmpty {
            VertexKit.log(pix: self, .warning, nil, "No vertices found.")
        }
        
        var scaledVertices = vertices.map { vtx -> RenderKit.Vertex in
            return RenderKit.Vertex(x: vtx.x * 2, y: vtx.y * 2, z: vtx.z * 2, s: vtx.s, t: vtx.t)
        }
        if vertices.isEmpty {
            for _ in 0..<6 {
                scaledVertices.append(RenderKit.Vertex(x: -2, y: -2, z: 0, s: 0, t: 0))
            }
        }
        
        var vertexBuffers: [Float] = []
        for vertex in scaledVertices {
            vertexBuffers += vertex.buffer3d
        }
        
        let vertexBuffersSize = vertexBuffers.count * MemoryLayout<Float>.size
        let verticesBuffer = PixelKit.main.render.metalDevice.makeBuffer(bytes: vertexBuffers, length: vertexBuffersSize, options: [])!
        
//        let count = !vertices.isEmpty ? instanceCount : (primativeType == .triangle ? 2 : primativeType == .line ? 3 : 6)
        return RenderKit.Vertices(buffer: verticesBuffer, vertexCount: vertices.count, type: primativeType, wireframe: wireframe)
    }
    
}
