//
//  Object3DPIX.swift
//  VertexKit
//
//  Created by Hexagons on 2018-11-29.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import RenderKit
import PixelKit
import Metal
import simd

public class Object3DPIX: _3DPIX, VertexCustom3DRenderDelegate {
    
    open override var customVertexShaderName: String? { return "obj3DVTX" }
    
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
    
    public var cameraMatrix: matrix_float4x4 = matrix_identity_float4x4
    public var projectionMatrix: matrix_float4x4 = matrix_identity_float4x4
    
    public override var customMatrices: [matrix_float4x4] {
        return [cameraMatrix, projectionMatrix]
    }
    
    public override var vertices: [RenderKit.Vertex] {
        guard triangleUVs.count == triangleVertices.count else {
            VertexKit.log(.error, nil, "UVs count dose not match the vertice cout.")
            return []
        }
        var vertices: [RenderKit.Vertex] = []
        for index in triangleIndices {
            let vert = triangleVertices[index]
            let uv = triangleUVs[index]
            let vertex = RenderKit.Vertex(x: (vert.x / resolution.aspect) * 3, y: vert.y * 3, z: vert.z, s: uv.u, t: uv.v)
            vertices.append(vertex)
        }
        return vertices
    }
    public override var primativeType: MTLPrimitiveType {
        return .triangle
    }
    
    // MARK: Life Cycle
    
    public required init(at resolution: Resolution) {
        super.init(at: resolution)
    }
    
    // MARK: Matrix
    
    public func update(cameraMatrix: simd_float4x4, projectionMatrix: simd_float4x4) {
        self.cameraMatrix = cameraMatrix
        self.projectionMatrix = projectionMatrix
    }
    
}
