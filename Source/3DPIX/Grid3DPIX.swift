//
//  Grid3DPIX.swift
//  VertexKit
//
//  Created by Anton Heestand on 2018-09-22.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import LiveValues
import RenderKit
import PixelKit

public class Grid3DPIX: _3DPIX {
    
    public var gridRes: Resolution { didSet { setNeedsRender() } }
    public var gridSize: CGSize { didSet { setNeedsRender() } }
    
//    public override var instanceCount: Int {
//        return ((gridRes.w + 1) * (gridRes.h + 1)) / 3
//    }
    public override var vertices: [RenderKit.Vertex] {
        return mapGrid(vtxGrid(vecGrid(plusOne: true)))
    }
    public override var wireframe: Bool { return true }
    
    public init(at resolution: Resolution, gridRes: Resolution) {
        self.gridRes = gridRes
        gridSize = CGSize(width: resolution.aspect.cg, height: 1.0)
        super.init(at: resolution)
    }
    
    required init(at resolution: Resolution) {
        gridRes = .custom(w: 10, h: 10)
        gridSize = CGSize(width: 1.0, height: 1.0)
        super.init(at: resolution)
    }
    
    func vecGrid(plusOne: Bool = false) -> [[_3DVec]] {
        
        let plus = plusOne ? 1 : 0
        
        var vecs: [[_3DVec]] = []
        for y in 0..<gridRes.h + plus {
            let v = CGFloat(y) / gridRes.height.cg
            var vecRow: [_3DVec] = []
            for x in 0..<gridRes.w + plus {
                let u = CGFloat(x) / gridRes.width.cg
                let vec = _3DVec(
                    x: LiveFloat((u - 0.5) * gridSize.width),
                    y: LiveFloat((v - 0.5) * gridSize.height),
                    z: 0.0
                )
                vecRow.append(vec)
            }
            vecs.append(vecRow)
        }
        
        return vecs
        
    }
    
    func vtxGrid(_ vecGrid: [[_3DVec]]) -> [[RenderKit.Vertex]] {
        return vecGrid.map({ vecRow -> [RenderKit.Vertex] in
            return vecRow.map({ vec -> RenderKit.Vertex in
                return RenderKit.Vertex(x: vec.x / resolution.aspect, y: vec.y, s: 0.0, t: 0.0)
            })
        })
    }
    
    func mapGrid(_ vertices: [[RenderKit.Vertex]]) -> [RenderKit.Vertex] {
        var verticesMap: [RenderKit.Vertex] = []
        for y in 0..<gridRes.h {
            for x in 0..<gridRes.w {
                let vertexBottomLeft = vertices[y][x]
                let vertexTopLeft = vertices[y][x + 1]
                let vertexBottomRight = vertices[y + 1][x]
                let vertexTopRight = vertices[y + 1][x + 1]
                verticesMap.append(vertexTopLeft)
                verticesMap.append(vertexTopRight)
                verticesMap.append(vertexBottomLeft)
                verticesMap.append(vertexBottomRight)
                verticesMap.append(vertexBottomLeft)
                verticesMap.append(vertexTopRight)
            }
        }
        return verticesMap
    }
    
//    func offset(grid: [[_3DVec]], by offest: _3DVec) -> [[_3DVec]] {
//        return grid.map({ row -> [_3DVec] in
//            return row.map({ vtx -> _3DVec in
//                var vtx = vtx
//                vtx.x += offest.x
//                vtx.y += offest.y
//                vtx.z += offest.z
//                return vtx
//            })
//        })
//    }
    
    required convenience init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}
