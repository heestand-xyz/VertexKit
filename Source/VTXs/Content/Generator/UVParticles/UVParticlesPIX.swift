//
//  UVParticlesPIX.swift
//  VertexKit
//
//  Created by Anton Heestand on 2019-05-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
import RenderKit
import PixelKit
import Resolution
import PixelColor

public class UVParticlesPIX: PIXGenerator, CustomGeometryDelegate {
        
    open override var customMetalLibrary: MTLLibrary { return VertexKit.metalLibrary }
    open override var customVertexShaderName: String? { return "uvParticlesVTX" }
    open override var shaderName: String { return "color3DPIX" }
    
    public override var customVertexTextureActive: Bool { return true }
    public override var customVertexNodeIn: (NODE & NODEOut)? {
        particlesInput
    }
    
    public override var additiveVertexBlending: Bool { return true }
    
    @LiveColor("clearBackgroundColor") public var clearBackgroundColor: PixelColor = .black
    
    @LiveFloat("particleSize") public var particleSize: CGFloat = 1.0
    /// Map Size of each particle from the blue channel
    @LiveBool("hasSize") public var hasSize: Bool = false
    /// Map Alpha of each particle from the alpha channel
    @LiveBool("hasAlpha") public var hasAlpha: Bool = false

    @available(*, deprecated, renamed: "particlesInput")
    public var vtxPixIn: (PIX & NODEOut)? {
        get { particlesInput }
        set { particlesInput = newValue }
    }
    public var particlesInput: (PIX & NODEOut)? { didSet { render() } }

    public override var liveList: [LiveWrap] {
        super.liveList.filter({ liveWrap in
            liveWrap.typeName != "backgroundColor"
        }) + [_particleSize, _hasSize, _hasAlpha]
    }
    
    public override var uniforms: [CGFloat] {
        color.components
    }
    open override var vertexUniforms: [CGFloat] {
        [particleSize, particlesInput?.finalResolution.width ?? 1, particlesInput?.finalResolution.height ?? 1, hasSize ? 1 : 0, hasAlpha ? 1 : 0, resolution.aspect]
    }
    
    public required init(at resolution: Resolution = .auto(render: PixelKit.main.render)) {
        super.init(at: resolution, name: "UV Particles", typeName: "vtx-pix-content-generator-uv-particles")
        setup()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        setup()
    }
    
    func setup() {
        customGeometryActive = true
        customGeometryDelegate = self
        clearColor = clearBackgroundColor
        _clearBackgroundColor.didSetValue = { [weak self] in
            self?.clearColor = self?.clearBackgroundColor ?? .clear
        }
    }
    
    // MARK: Custom Geometry
    
    public func customVertices() -> RenderKit.Vertices? {
        
        let count = (particlesInput?.finalResolution.w ?? 1) * (particlesInput?.finalResolution.h ?? 1)
        let vertexBuffers: [Float] = [Float](repeating: 0.0, count: 1)//count)
        
        let vertexBuffersSize = vertexBuffers.count * MemoryLayout<Float>.size
        let verticesBuffer = PixelKit.main.render.metalDevice.makeBuffer(bytes: vertexBuffers, length: vertexBuffersSize, options: [])!
        
        return RenderKit.Vertices(buffer: verticesBuffer, vertexCount: count, type: .point, wireframe: false)
    }
    
}
