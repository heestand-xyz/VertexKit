//
//  VoxelParticlesPIX.swift
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

public class VoxelParticlesPIX: PIXSingleEffect, NODEResolution, CustomGeometryDelegate {
        
    open override var customMetalLibrary: MTLLibrary { return VertexKit.metalLibrary }
    open override var customVertexShaderName: String? { return "voxelParticlesVTX" }
    open override var shaderName: String { return "color3DPIX" }
    
    public override var customVertexTextureActive: Bool { return true }
    public override var customVertexNodeIn: (NODE & NODEOut)? {
        voxelInput
    }
    public override var additiveVertexBlending: Bool { return true }
    
    public var voxelInput: (NODE3D & NODEOut)? { didSet { render() } }
    
    @LiveResolution("resolution") public var resolution: Resolution = ._128

    public override var liveList: [LiveWrap] {
        [_resolution]
    }
    
    public override var uniforms: [CGFloat] {
        []
    }
    open override var vertexUniforms: [CGFloat] {
        [
            CGFloat(voxelInput?.finalResolution3d.x ?? 0),
            CGFloat(voxelInput?.finalResolution3d.y ?? 0),
            CGFloat(voxelInput?.finalResolution3d.z ?? 0),
        ]
    }
    
    public init(at resolution: Resolution = .auto(render: PixelKit.main.render)) {
        self.resolution = resolution
        super.init(name: "UV Particles", typeName: "vtx-pix-content-generator-uv-particles")
        customGeometryActive = true
        customGeometryDelegate = self
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    required convenience init() {
        self.init(at: .auto(render: PixelKit.main.render))
    }
    
    // MARK: Custom Geometry
    
    public func customVertices() -> RenderKit.Vertices? {
        
        guard let node3d = voxelInput else { return nil }
        
        let count = node3d.finalResolution3d.count
        let vertexBuffers: [Float] = [Float](repeating: 0.0, count: count)
        
        let vertexBuffersSize = vertexBuffers.count * MemoryLayout<Float>.size
        let verticesBuffer = PixelKit.main.render.metalDevice.makeBuffer(bytes: vertexBuffers, length: vertexBuffersSize, options: [])!
        
        return RenderKit.Vertices(buffer: verticesBuffer, vertexCount: count, type: .point, wireframe: false)
    }
    
}
