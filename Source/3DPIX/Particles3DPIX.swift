//
//  Particles3DPIX.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-09-27.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
import Pixels

public class Particles3DPIX: _3DPIX {
    
    open override var customVertexTextureActive: Bool { return true }
    open override var customVertexShaderName: String? { return "particle3DVTX" }
    
    public override var vertecies: [Pixels.Vertex] {
        return particles.map({ vec -> Pixels.Vertex in
            return Pixels.Vertex(x: vec.x / res.aspect, y: vec.y, z: vec.z, s: 0.0, t: 0.0)
        })
    }
    public override var instanceCount: Int { return particles.count }
    public override var primativeType: MTLPrimitiveType { return .point }
    
    var cachedVertecies: Pixels.Vertecies?
    
    public var particles: [_3DVec] = []// { didSet { setNeedsRender() } }
    
    let startTime = Date()
    var time: CGFloat {
        return CGFloat(-startTime.timeIntervalSinceNow)
    }
    open override var vertexUniforms: [CGFloat] {
        return [time]
    }
    
    public override init(res: PIX.Res) {
        for _ in 0..<1000 {
            let particle = _3DVec(
                x: CGFloat.random(in: -0.125...0.125),
                y: CGFloat.random(in: -0.125...0.125),
                z: 0.0
            )
            particles.append(particle)
        }
        super.init(res: res)
//        setNeedsRender()
    }
    
    public override func customVertecies() -> Pixels.Vertecies? {
        if cachedVertecies == nil {
            cachedVertecies = super.customVertecies()
        }
        return cachedVertecies
    }
    
    override public func didRender(texture: MTLTexture, force: Bool) {
        super.didRender(texture: texture)
        setNeedsRender()
//        particles = particles.map { vec -> _3DVec in
//            return vec + _3DVec(
//                x: CGFloat.random(in: -0.01...0.01),
//                y: CGFloat.random(in: -0.01...0.01),
//                z: 0.0
//            )
//        }
    }
    
}
