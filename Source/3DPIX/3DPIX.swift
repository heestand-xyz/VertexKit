//
//  3DPIX.swift
//  3DPIX
//
//  Created by Hexagons on 2018-09-13.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import UIKit
import Pixels

public class _3DPIX: PIXGenerator, PixelsCustomGeometryDelegate {
    
    open override var customMetalLibrary: MTLLibrary { return Pixels3D.main.metalLibrary }
    open override var customVertexShaderName: String? { return "nil3DVTX" }
    open override var shader: String { return "color3DPIX" }
    
//    var root: _3DRoot
    
    public var vertices: [Pixels.Vertex] { return [] }
    public var primativeType: MTLPrimitiveType { return .triangle }
    public var wireframe: Bool { return false }

    public var color: UIColor = .white { didSet { setNeedsRender() } }
    public override var uniforms: [CGFloat] {
        return LiveColor(color).list
    }

    override init(res: PIX.Res) {
//        root = Pixels3D.main.engine.createRoot(at: res.size)
        super.init(res: res)
        customGeometryActive = true
        customGeometryDelegate = self
    }
    
    // MAKR: Custom Geometry
    public func customVertecies() -> Pixels.Vertecies? {
        
        if vertices.isEmpty {
            Pixels3D.log(pix: self, .warning, nil, "No vertices found.")
        }
        
        var scaledVertices = vertices.map { vtx -> Pixels.Vertex in
            return Pixels.Vertex(x: vtx.x * 2, y: vtx.y * 2, z: vtx.z * 2, s: vtx.s, t: vtx.t)
        }
        if vertices.isEmpty {
            for _ in 0..<6 {
                scaledVertices.append(Pixels.Vertex(x: -2, y: -2, z: 0, s: 0, t: 0))
            }
        }
        
        var vertexBuffers: [Float] = []
        for vertex in scaledVertices {
            vertexBuffers += vertex.buffer3d
        }
        
        let vertexBuffersSize = vertexBuffers.count * MemoryLayout<Float>.size
        let verticesBuffer = Pixels.main.metalDevice.makeBuffer(bytes: vertexBuffers, length: vertexBuffersSize, options: [])!
        
//        let count = !vertices.isEmpty ? instanceCount : (primativeType == .triangle ? 2 : primativeType == .line ? 3 : 6)
        return Pixels.Vertices(buffer: verticesBuffer, vertexCount: vertices.count, type: primativeType, wireframe: wireframe)
    }
    
}
