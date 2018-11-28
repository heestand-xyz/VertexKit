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

public class Object3DPIX: _3DPIX {
    
//    public var circRes: Res = .custom(w: 64, h: 16) { didSet { setNeedsRender() } }
//    public var radius: CGFloat = 0.1 { didSet { setNeedsRender() } }
    
    public var verts: [_3DVec] = [] { didSet { setNeedsRender() } }
    public var uvs: [_3DUV] = [] { didSet { setNeedsRender() } }
    public var triCount: Int = 0 { didSet { setNeedsRender() } }
    public var triMap: [Int] = [] { didSet { setNeedsRender() } }
    
    public override var instanceCount: Int {
        return triCount
    }
    public override var triangleIndices: [Int] {
        return triMap
    }
    public override var vertices: [Pixels.Vertex] {
        guard uvs.count == verts.count else {
            Pixels3D.log(.error, nil, "UVs count dose not match Verts count.")
            return []
        }
        var vertices: [Pixels.Vertex] = []
        for i in 0..<verts.count {
            let vert = verts[i]
            let uv = uvs[i]
            let vertex = Pixels.Vertex(x: vert.x, y: vert.y, z: vert.z, s: uv.u, t: uv.v)
            vertices.append(vertex)
        }
        return vertices
    }
    public override var primativeType: MTLPrimitiveType {
        return .line
    }
    
    public override init(res: PIX.Res) {
        super.init(res: res)
    }
    
}
