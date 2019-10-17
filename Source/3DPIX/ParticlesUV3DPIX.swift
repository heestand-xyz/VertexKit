//
//  ParticlesUV3DPIX.swift
//  VertexKit
//
//  Created by Anton Heestand on 2019-05-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
import LiveValues
import RenderKit
import PixelKit

public class ParticlesUV3DPIX: PIXGenerator, CustomGeometryDelegate {
        
    open override var customMetalLibrary: MTLLibrary { return VertexKit.main.metalLibrary }
    open override var customVertexShaderName: String? { return "particleUV3DVTX" }
    open override var shaderName: String { return "color3DPIX" }
    
    public override var customVertexTextureActive: Bool { return true }
    public override var customVertexNodeIn: (NODE & NODEOut)? {
        return vtxPixIn
    }
    public override var additiveVertexBlending: Bool { return true }
    
    public var size: LiveFloat = 1.0
    /// Map Size of each particle from the blue channel
    public var mapSize: LiveBool = false
    /// Map Alpha of each particle from the alpha channel
    public var mapAlpha: LiveBool = false

    public var vtxPixIn: (PIX & NODEOut)? { didSet { setNeedsRender() } }
    
    public override var liveValues: [LiveValue] {
        return [size, mapSize, mapAlpha]
    }
    public override var uniforms: [CGFloat] {
        return color.list
    }
    open override var vertexUniforms: [CGFloat] {
        return [size.uniform, vtxPixIn?.realResolution?.width.cg ?? 1, vtxPixIn?.realResolution?.height.cg ?? 1, mapSize.uniform ? 1 : 0, mapAlpha.uniform ? 1 : 0, resolution.aspect.cg]
    }
    
    public required init(at resolution: Resolution) {
        super.init(at: resolution)
        customGeometryActive = true
        customGeometryDelegate = self
    }
    
    // MAKR: Custom Geometry
    public func customVertices() -> RenderKit.Vertices? {
        
        let count = (vtxPixIn?.realResolution?.w ?? 1) * (vtxPixIn?.realResolution?.h ?? 1)
        let vertexBuffers: [Float] = [Float](repeating: 0.0, count: count)
        
        let vertexBuffersSize = vertexBuffers.count * MemoryLayout<Float>.size
        let verticesBuffer = PixelKit.main.render.metalDevice.makeBuffer(bytes: vertexBuffers, length: vertexBuffersSize, options: [])!
        
        return RenderKit.Vertices(buffer: verticesBuffer, vertexCount: count, type: .point, wireframe: false)
    }
    
}
