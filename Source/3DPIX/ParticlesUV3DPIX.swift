//
//  ParticlesUV3DPIX.swift
//  Pixels3D
//
//  Created by Anton Heestand on 2019-05-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
import Pixels

public class ParticlesUV3DPIX: PIXGenerator, PixelsCustomGeometryDelegate {
        
    open override var customMetalLibrary: MTLLibrary { return Pixels3D.main.metalLibrary }
    open override var customVertexShaderName: String? { return "particleUV3DVTX" }
    open override var shader: String { return "color3DPIX" }
    
    public override var customVertexTextureActive: Bool { return true }
    public override var customVertexPixIn: (PIX & PIXOut)? {
        return vtxPixIn
    }
    
    public var size: LiveFloat = 1.0
    
    public var vtxPixIn: (PIX & PIXOut)? { didSet { setNeedsRender() } }
    
    public override var liveValues: [LiveValue] {
        return [size]
    }
    public override var uniforms: [CGFloat] {
        return color.list
    }
    open override var vertexUniforms: [CGFloat] {
        return [size.uniform, vtxPixIn?.resolution?.width ?? 1, vtxPixIn?.resolution?.height ?? 1, resolution?.aspect ?? 1]
    }
    
    public required init(res: PIX.Res) {
        super.init(res: res)
        customGeometryActive = true
        customGeometryDelegate = self
    }
    
    // MAKR: Custom Geometry
    public func customVertices() -> Pixels.Vertices? {
        
        let count = (vtxPixIn?.resolution?.w ?? 1) * (vtxPixIn?.resolution?.h ?? 1)
        let vertexBuffers: [Float] = [Float](repeating: 0.0, count: count)
        
        let vertexBuffersSize = vertexBuffers.count * MemoryLayout<Float>.size
        let verticesBuffer = Pixels.main.metalDevice.makeBuffer(bytes: vertexBuffers, length: vertexBuffersSize, options: [])!
        
        return Pixels.Vertices(buffer: verticesBuffer, vertexCount: count, type: .point, wireframe: false)
    }
    
}
