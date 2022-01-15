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
    
    public typealias Model = UVParticlesPixelModel
    
    private var model: Model {
        get { generatorModel as! Model }
        set { generatorModel = newValue }
    }
    
    open override var customMetalLibrary: MTLLibrary { VertexKit.metalLibrary }
    open override var customVertexShaderName: String? { "uvParticlesVTX" }
    open override var shaderName: String { "color3DPIX" }
    
    public override var customVertexTextureActive: Bool { true }
    public override var customVertexNodeIn: (NODE & NODEOut)? {
        particlesInput
    }
    
    public override var additiveVertexBlending: Bool { true }
    
    @LiveColor("clearBackgroundColor") public var clearBackgroundColor: PixelColor = .black
    
    @LiveFloat("particleSize", range: 0.0...2.0, increment: 1.0) public var particleSize: CGFloat = 1.0
    /// Map Size of each particle from the blue channel
    @LiveBool("hasSize") public var hasSize: Bool = false
    /// Map Alpha of each particle from the alpha channel
    @LiveBool("hasAlpha") public var hasAlpha: Bool = false
    /// `hasAlpha` needs to be `true`. The clips any alpha below 1.0.
    @LiveBool("hasAlphaClip") public var hasAlphaClip: Bool = false

    @available(*, deprecated, renamed: "particlesInput")
    public var vtxPixIn: (PIX & NODEOut)? {
        get { particlesInput }
        set { particlesInput = newValue }
    }
    public var particlesInput: (PIX & NODEOut)? { didSet { render() } }

    public override var liveList: [LiveWrap] {
        super.liveList.filter({ liveWrap in
            liveWrap.typeName != "backgroundColor"
        }) + [_particleSize, _hasSize, _hasAlpha, _hasAlphaClip]
    }
    
    public override var uniforms: [CGFloat] {
        color.components
    }
    open override var vertexUniforms: [CGFloat] {
        [particleSize, particlesInput?.finalResolution.width ?? 1, particlesInput?.finalResolution.height ?? 1, hasSize ? 1 : 0, hasAlpha ? 1 : 0, hasAlphaClip ? 1 : 0, resolution.aspect]
    }
    
    // MARK: - Life Cycle -
    
    public init(model: Model) {
        super.init(model: model)
        setup()
    }
    
    public required init(at resolution: Resolution = .auto) {
        let model = Model(resolution: resolution)
        super.init(model: model)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        customGeometryActive = true
        customGeometryDelegate = self
        clearColor = clearBackgroundColor
        _clearBackgroundColor.didSetValue = { [weak self] in
            self?.clearColor = self?.clearBackgroundColor ?? .clear
        }
    }
    
    // MARK: - Live Model
    
    public override func modelUpdateLive() {
        super.modelUpdateLive()
        
        clearBackgroundColor = model.clearBackgroundColor
        particleSize = model.particleSize
        hasSize = model.hasSize
        hasAlpha = model.hasAlpha
        hasAlphaClip = model.hasAlphaClip

        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.clearBackgroundColor = clearBackgroundColor
        model.particleSize = particleSize
        model.hasSize = hasSize
        model.hasAlpha = hasAlpha
        model.hasAlphaClip = hasAlphaClip

        super.liveUpdateModelDone()
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
