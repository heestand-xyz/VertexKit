//
//  LineGrid3DPIX.swift
//  VertexKit
//
//  Created by Anton Heestand on 2018-09-22.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import Metal
import LiveValues
import RenderKit
import PixelKit

public protocol LineGrid3DPIXDelegate {
    
    func lineGrid3dPixLine(_ vec: _3DVec, _ pixel: RenderKit.Pixel) -> (a: _3DVec, b: _3DVec)
    
}

public class LineGrid3DPIX: Grid3DPIX {
    
    public var customDelegate: LineGrid3DPIXDelegate?
    
//    open override var customVertexTextureActive: Bool { return true }
//    open override var customVertexShaderName: String? { return "distort3DVTX" }
//    open override var customVertexPixIn: (PIX & PIXOut)? { return gridPixIn }
    
    public var gridPixIn: (PIX & NODEOut)? = nil { didSet { setNeedsRender() } }
//    /*public*/ var offset: _3DVec = _3DVec(x: 0.125, y: 0.125, z: 0.0)// { didSet { setNeedsRender() } }

    public override var vertices: [RenderKit.Vertex] { return gridLines }
//    public override var instanceCount: Int { return gridRes.count }
    public override var primativeType: MTLPrimitiveType { return .line }
    
    var gridLines: [RenderKit.Vertex] = []
    
//    var gridLines: [PixelKit.Vertex]!
    
    public override init(at resolution: Resolution, gridRes: Resolution) {
        super.init(at: resolution, gridRes: gridRes)
//        self.gridLines = makeGridLines()
    }
    
    required init(at resolution: Resolution) {
        super.init(at: resolution, gridRes: .custom(w: 10, h: 10))
    }
    
    public func makeGridLines() {
        self.gridLines = []
//        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>", PixelKit.main.frame)
//        return [PixelKit.Vertex(x: 0, y: -0.125, s: 0.0, t: 0.0), PixelKit.Vertex(x: 0, y: 0.125, s: 0.0, t: 0.0)]
        guard customDelegate != nil else {
            VertexKit.log(.warning, nil, "`customDelegate` not implemented.")
            return
        }
        guard let pixelPack = gridPixIn?.renderedPixels else {
            VertexKit.log(.warning, nil, "`gridPixIn`'s `renderedPixels` not found.")
            return
        }
        let grid = vecGrid()
        var gridLines: [RenderKit.Vertex] = []
        for y in 0..<gridRes.h {
            let v = (CGFloat(y) + 0.5) / CGFloat(gridRes.h)
            for x in 0..<gridRes.w {
                let u = (CGFloat(x) + 0.5) / CGFloat(gridRes.w)
                let vec = grid[y][x]
                let pixel = pixelPack.pixel(uv: CGVector(dx: u, dy: v))
                let (vecA, vecB) = customDelegate!.lineGrid3dPixLine(vec, pixel)
                let vtxA = RenderKit.Vertex(x: vecA.x / resolution.aspect, y: vecA.y, s: 0.0, t: 0.0)
                let vtxB = RenderKit.Vertex(x: vecB.x / resolution.aspect, y: vecB.y, s: 0.0, t: 0.0)
                gridLines.append(vtxA)
                gridLines.append(vtxB)
            }
        }
        self.gridLines = gridLines
    }
    
    required convenience init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}
