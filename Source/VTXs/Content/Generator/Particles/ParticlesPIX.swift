//
//  UVParticlesPIX.swift
//  VertexKit
//
//  Created by Anton Heestand on 2019-05-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import CoreGraphics
import CoreGraphicsExtensions
import Metal
import RenderKit
import PixelKit
import Resolution
import PixelColor

public class ParticlesPIX: PIXGenerator, CustomGeometryDelegate {
    
    public typealias Model = ParticlesPixelModel
    
    private var model: Model {
        get { generatorModel as! Model }
        set { generatorModel = newValue }
    }
    
    open override var customMetalLibrary: MTLLibrary { VertexKit.metalLibrary }
    open override var customVertexShaderName: String? { "particlesVTX" }
    open override var shaderName: String { "color3DPIX" }
    
    public override var additiveVertexBlending: Bool { true }
    
    struct Particle {
        var position: CGPoint
        var velocity: CGPoint
        var lifeTime: Double = 0.0
    }
    private var particles: [Particle] = []
    
    // MARK: Properties
    
    @LiveColor("clearBackgroundColor") public var clearBackgroundColor: PixelColor = .black
    @LiveFloat("lifeTime") public var lifeTime: CGFloat = 1.0
    @LiveInt("emitCount", range: 0...10) public var emitCount: Int = 1
    @LivePoint("emitPosition") public var emitPosition: CGPoint = .zero
    @LiveSize("emitSize") public var emitSize: CGSize = .zero
    @LivePoint("direction") public var direction: CGPoint = CGPoint(x: 0.0, y: 0.0)
    @LiveFloat("randomDirection") public var randomDirection: CGFloat = 1.0
    @LiveFloat("velocity", range: 0.0...0.01, increment: 0.001) public var velocity: CGFloat = 0.005
    @LiveFloat("randomVelocity", range: 0.0...0.01, increment: 0.001) public var randomVelocity: CGFloat = 0.0
    @LiveFloat("particleSize", range: 0.0...2.0, increment: 1.0) public var particleSize: CGFloat = 1.0

    // MARK: Property Helpers
    
    public override var liveList: [LiveWrap] {
        super.liveList.filter({ liveWrap in
            liveWrap.typeName != "backgroundColor"
        }) + [_clearBackgroundColor, _lifeTime, _emitCount, _emitPosition, _emitSize, _direction, _randomDirection, _velocity, _randomVelocity, _particleSize]
    }
    
    public override var uniforms: [CGFloat] {
        color.components
    }
    
    open override var vertexUniforms: [CGFloat] {
        [particleSize]
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
        
        PixelKit.main.render.listenToFrames(id: id) { [weak self] in
            self?.particleLoop()
        }
        
    }
    
    public override func destroy() {
        super.destroy()
        
        PixelKit.main.render.unlistenToFrames(for: id)
    }
    
    // MARK: - Live Model
    
    public override func modelUpdateLive() {
        super.modelUpdateLive()
        
        clearBackgroundColor = model.clearBackgroundColor
        lifeTime = model.lifeTime
        emitCount = model.emitCount
        emitPosition = model.emitPosition
        emitSize = model.emitSize
        direction = model.direction
        randomDirection = model.randomDirection
        velocity = model.velocity
        randomVelocity = model.randomVelocity
        particleSize = model.particleSize

        super.modelUpdateLiveDone()
    }
    
    public override func liveUpdateModel() {
        super.liveUpdateModel()
        
        model.clearBackgroundColor = clearBackgroundColor
        model.lifeTime = lifeTime
        model.emitCount = emitCount
        model.emitPosition = emitPosition
        model.emitSize = emitSize
        model.direction = direction
        model.randomDirection = randomDirection
        model.velocity = velocity
        model.randomVelocity = randomVelocity
        model.particleSize = particleSize

        super.liveUpdateModelDone()
    }
    
    // MARK: - Particle Loop
    
    private func particleLoop() {
        addParticles()
        moveParticles()
        removeParticles()
        render()
    }
    
    private func addParticles() {
        guard emitCount > 0 else { return }
        for _ in 0..<emitCount {
            var position: CGPoint = emitPosition
            position -= emitSize / 2
            position += CGPoint(x: emitSize.width * .random(in: 0.0...1.0),
                                y: emitSize.height * .random(in: 0.0...1.0))
            var velocity: CGPoint = direction * velocity
            if randomDirection > 0.0 {
                velocity += CGPoint(x: .random(in: -1.0...1.0) * randomDirection * self.velocity,
                                    y: .random(in: -1.0...1.0) * randomDirection * self.velocity)
            }
            let particle = Particle(position: position, velocity: velocity)
            particles.append(particle)
        }
    }
    
    private func moveParticles() {
        for (index, particle) in particles.enumerated() {
            var velocity = particle.velocity
            if randomVelocity > 0.0 {
                velocity += CGPoint(x: .random(in: -1.0...1.0) * randomVelocity,
                                    y: .random(in: -1.0...1.0) * randomVelocity)
            }
            particles[index].position += velocity
            particles[index].lifeTime += PixelKit.main.render.secondsPerFrame
        }
    }
    
    private func removeParticles() {
        for (index, particle) in particles.enumerated().reversed() {
            if particle.lifeTime >= lifeTime {
                particles.remove(at: index)
            }
        }
    }
    
    public func removeAllParticles() {
        particles = []
        render()
    }
    
    // MARK: - Custom Vertices
    
    public func customVertices() -> RenderKit.Vertices? {
        
        let count = particles.count
        var vertices: [RenderKit.Vertex] = []
        for particle in particles {
            vertices.append(Vertex(x: particle.position.x,
                                   y: particle.position.y))
        }
        
        let vertexBuffer = vertices.flatMap(\.buffer3d)
        let vertexBufferSize = max(vertexBuffer.count, 1) * MemoryLayout<Float>.size
        let vertexBufferBuffer = PixelKit.main.render.metalDevice.makeBuffer(bytes: !vertexBuffer.isEmpty ? vertexBuffer : [0.0], length: vertexBufferSize, options: [])!
        
        return RenderKit.Vertices(buffer: vertexBufferBuffer, vertexCount: count, type: .point, wireframe: false)
    }
    
}
