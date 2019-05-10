//
//  Particles3DPIX.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-09-27.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
#if os(iOS)
import PixelKit
#elseif os(macOS)
import PixelKit_macOS
#endif

public class Particles3DPIX: _3DPIX {
    
//    public var gridRes: Res { didSet { setNeedsRender() } }
    
    open override var customVertexShaderName: String? { return "particle3DVTX" }

//    open override var customVertexTextureActive: Bool { return true }
//    open override var customVertexPixIn: (PIX & PIXOut)? { return sourcePixIn }
    
//    public var sourcePixIn: (PIX & PIXOut)? = nil {
//        didSet {
//            if let src = sourcePixIn {
//                prep()
//                src.customLink(to: self)
//            } else {
//                oldValue?.customDelink(from: self)
//            }
//        }
//    }
    
    public override var vertices: [PixelKit.Vertex] {
        return particles.map({ particle -> PixelKit.Vertex in
            return PixelKit.Vertex(x: particle.pos.x / res.aspect, y: particle.pos.y, z: particle.pos.z, s: 0.0, t: 0.0)
        })
    }
//    public override var instanceCount: Int {
//        return particles.count //sourcePixIn?.resolution?.count ?? 0
//    }
    public override var primativeType: MTLPrimitiveType { return .point }
    
    var cachedVertices: PixelKit.Vertices?
    
    struct Particle {
        var pos: _3DVec
        var dir: _3DVec
        var life: CGFloat
    }
    
//    public var count: Int = 1024// { didSet { setNeedsRender() } }
    var particles: [Particle] = []// { didSet { setNeedsRender() } }
    public var speed: CGFloat = 1.0
    public var lifeDecay: CGFloat = 0.01
    public var emittors:  [_3DVec] = []// { didSet { setNeedsRender() } }
    public var size: CGFloat = 1.0 { didSet { setNeedsRender() } }
    
//    var aspect: CGFloat {
//        return res.aspect
//    }
    
//    let startTime = Date()
//    var time: CGFloat {
//        return CGFloat(-startTime.timeIntervalSinceNow)
//    }
    open override var vertexUniforms: [CGFloat] {
        return [size]
    }

    public required init(res: Res) {
        super.init(res: res)
    }
    
//    func prep() {
//        guard let src = sourcePixIn else { return }
//        guard let res = src.resolution else { return }
//        guard particles.count != res.count else { return }
//        particles = Pixels3D.uvVecMap(res: res)
////        setNeedsRender()
//    }
    
    public func pop() {
        guard !emittors.isEmpty else {
//            if !particles.isEmpty {
//                particles = []
//                setNeedsRender()
//            }
            return
        }
        for emittor in emittors {
            let pi: CGFloat = .pi
            let ang = CGFloat.random(in: -pi...pi)
            let amp = CGFloat.random(in: 0.5...1.0)
            let dir = _3DVec(x: LiveFloat(cos(ang) * amp), y: LiveFloat(sin(ang) * amp), z: 0.0)
            particles.append(Particle(pos: emittor, dir: dir, life: 1.0))
        }
    }
    
    public func move() {
        print("particles:", particles)
        let count = particles.count
        for i in 0..<count {
            let ir = count - i - 1
            var particle = particles[ir]
            particle.life -= lifeDecay
            if particle.life <= 0 {
                particles.remove(at: ir)
                continue
            }
            particle.pos += particle.dir * LiveFloat(speed)
            particles[ir] = particle
        }
    }
    
//    public override func customVertices() -> PixelKit.Vertices? {
//        guard !particles.isEmpty else { return nil }
//        if cachedVertices == nil {
//            cachedVertices = super.customVertices()
//        }
//        return cachedVertices!
//    }
    
    required convenience init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}
