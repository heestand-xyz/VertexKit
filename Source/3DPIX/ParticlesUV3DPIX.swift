//
//  ParticlesUV3DPIX.swift
//  VertexKit
//
//  Created by Anton Heestand on 2019-05-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
import PixelKit

public class ParticlesUV3DPIX: PIXGenerator, PixelCustomGeometryDelegate {
        
    open override var customMetalLibrary: MTLLibrary { return VertexKit.main.metalLibrary }
    open override var customVertexShaderName: String? { return "particleUV3DVTX" }
    open override var shader: String { return "color3DPIX" }
    
    public override var customVertexTextureActive: Bool { return true }
    public override var customVertexPixIn: (PIX & PIXOut)? {
        return vtxPixIn
    }
    public override var additiveVertexBlending: Bool { return true }
    
    public var size: LiveFloat = 1.0
    
    public var vtxPixIn: (PIX & PIXOut)? { didSet { setNeedsRender() } }
    
    public override var liveValues: [LiveValue] {
        return [size]
    }
    public override var uniforms: [CGFloat] {
        return color.list
    }
    open override var vertexUniforms: [CGFloat] {
        return [size.uniform, vtxPixIn?.resolution?.width.cg ?? 1, vtxPixIn?.resolution?.height.cg ?? 1, resolution?.aspect.cg ?? 1]
    }
    
    public required init(res: PIX.Res) {
        super.init(res: res)
        customGeometryActive = true
        customGeometryDelegate = self
    }
    
    // MAKR: Custom Geometry
    public func customVertices() -> PixelKit.Vertices? {
        
        let count = (vtxPixIn?.resolution?.w ?? 1) * (vtxPixIn?.resolution?.h ?? 1)
        let vertexBuffers: [Float] = [Float](repeating: 0.0, count: count)
        
        let vertexBuffersSize = vertexBuffers.count * MemoryLayout<Float>.size
        let verticesBuffer = PixelKit.main.metalDevice.makeBuffer(bytes: vertexBuffers, length: vertexBuffersSize, options: [])!
        
        return PixelKit.Vertices(buffer: verticesBuffer, vertexCount: count, type: .point, wireframe: false)
    }
    
}
