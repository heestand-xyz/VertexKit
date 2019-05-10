//
//  RawParticles3DPIX.swift
//  Pixels3D
//
//  Created by Anton Heestand on 2019-05-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
#if os(iOS)
import PixelKit
#elseif os(macOS)
import PixelKit_macOS
#endif

public class RawParticles3DPIX: _3DPIX {
    
    open override var customVertexShaderName: String? { return "particle3DVTX" }
    
    public override var vertices: [PixelKit.Vertex] {
        return rawParticles.map({ rawParticle -> PixelKit.Vertex in
            return PixelKit.Vertex(x: rawParticle.x / res.aspect, y: rawParticle.y, z: rawParticle.z, s: 0.0, t: 0.0)
        })
    }
    
    public override var primativeType: MTLPrimitiveType { return .point }
    
    public var rawParticles: [_3DVec] = []
    
    public var size: CGFloat = 1.0 { didSet { setNeedsRender() } }
    
//    public override var liveValues: [LiveValue] {
//        return rawParticles.flatMap({ vec -> [LiveValue] in
//            return [vec.x, vec.y, vec.z]
//        })
//    }
    
    open override var vertexUniforms: [CGFloat] {
        return [size]
    }
    
    public required init(res: Res) {
        super.init(res: res)
    }
    
    required convenience init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}
