//
//  Object3DPIX.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-11-29.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import Pixels
import Metal
import simd

public class Object3DPIX: _3DPIX, PixelsCustom3DRenderDelegate {
    
//    public var circRes: Res = .custom(w: 64, h: 16) { didSet { setNeedsRender() } }
//    public var radius: CGFloat = 0.1 { didSet { setNeedsRender() } }
    
    public var triangleVertices: [_3DVec] = [] { didSet { setNeedsRender() } }
    public var triangleUVs: [_3DUV] = [] { didSet { setNeedsRender() } }
//    public var triangleCount: Int = 0 { didSet { setNeedsRender() } }
    public var triangleIndices: [Int] = [] { didSet { setNeedsRender() } }
    
    public override var wireframe: Bool { return true }
//    public override var instanceCount: Int {
//        return triangleCount
//    }
    public override var vertices: [Pixels.Vertex] {
        guard triangleUVs.count == triangleVertices.count else {
            Pixels3D.log(.error, nil, "UVs count dose not match the vertice cout.")
            return []
        }
        var vertices: [Pixels.Vertex] = []
        for index in triangleIndices {
            let vert = triangleVertices[index]
            let uv = triangleUVs[index]
            let vertex = Pixels.Vertex(x: (vert.x / res.aspect) * 3, y: vert.y * 3, z: vert.z, s: uv.u, t: uv.v)
            vertices.append(vertex)
        }
        return vertices
    }
    public override var primativeType: MTLPrimitiveType {
        return .triangle
    }
    
    // MARK: Life Cycle
    
    public override init(res: PIX.Res) {
        super.init(res: res)
    }
    
    // MARK: Matrix
    
    public func update(cameraTransform: simd_float4x4, projectionMatrix: simd_float4x4) {
        
        
        
    }
    
}
