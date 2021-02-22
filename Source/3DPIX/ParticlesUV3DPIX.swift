//
//  ParticlesUV3DPIX.swift
//  VertexKit
//
//  Created by Anton Heestand on 2019-05-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
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
    
    @Live public var size: CGFloat = 1.0
    /// Map Size of each particle from the blue channel
    @Live public var mapSize: Bool = false
    /// Map Alpha of each particle from the alpha channel
    @Live public var mapAlpha: Bool = false

    public var vtxPixIn: (PIX & NODEOut)? { didSet { setNeedsRender() } }
    
    public override var liveList: [LiveWrap] {
        super.liveList + [_size, _mapSize, _mapAlpha]
    }
    
    public override var uniforms: [CGFloat] {
        color.components
    }
    open override var vertexUniforms: [CGFloat] {
        [size, vtxPixIn?.finalResolution.width ?? 1, vtxPixIn?.finalResolution.height ?? 1, mapSize ? 1 : 0, mapAlpha ? 1 : 0, resolution.aspect]
    }
    
    public required init(at resolution: Resolution = .auto(render: PixelKit.main.render)) {
        super.init(at: resolution, name: "Particles UV 3D", typeName: "vtx-pix-content-generator-particles-uv-3d")
        customGeometryActive = true
        customGeometryDelegate = self
    }
    
    // MAKR: Custom Geometry
    public func customVertices() -> RenderKit.Vertices? {
        
        let count = (vtxPixIn?.finalResolution.w ?? 1) * (vtxPixIn?.finalResolution.h ?? 1)
        let vertexBuffers: [Float] = [Float](repeating: 0.0, count: count)
        
        let vertexBuffersSize = vertexBuffers.count * MemoryLayout<Float>.size
        let verticesBuffer = PixelKit.main.render.metalDevice.makeBuffer(bytes: vertexBuffers, length: vertexBuffersSize, options: [])!
        
        return RenderKit.Vertices(buffer: verticesBuffer, vertexCount: count, type: .point, wireframe: false)
    }
    
}
