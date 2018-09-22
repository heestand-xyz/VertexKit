//
//  Grid3DPIX.swift
//  Pixels3D
//
//  Created by Anton Heestand on 2018-09-22.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import Pixels

public class Grid3DPIX: _3DPIX {
    
    public var gridRes: Res = .custom(w: 4, h: 4) { didSet { setNeedsRender() } }
    public var gridSize: CGSize = CGSize(width: 1.0, height: 1.0) { didSet { setNeedsRender() } }
    
    public override var instanceCount: Int {
        return ((gridRes.w + 1) * (gridRes.h + 1)) / 3
    }
    public override var vertecies: [Pixels.Vertex] {
        return mapGrid(vtxGrid(vecGrid()))
    }
    public override var wireframe: Bool { return true }
    
    public override init(res: PIX.Res) {
        super.init(res: res)
    }
    
    func vecGrid() -> [[_3DVec]] {
        
        var vecs: [[_3DVec]] = []
        for y in 0...gridRes.h {
            let v = CGFloat(y) / gridRes.height
            var vecRow: [_3DVec] = []
            for x in 0...gridRes.w {
                let u = CGFloat(x) / gridRes.width
                let vec = _3DVec(
                    x: (u - 0.5) * gridSize.width,
                    y: (v - 0.5) * gridSize.height,
                    z: 0.0
                )
                vecRow.append(vec)
            }
            vecs.append(vecRow)
        }
        
        return vecs
        
    }
    
    func vtxGrid(_ vecGrid: [[_3DVec]]) -> [[Pixels.Vertex]] {
        return vecGrid.map({ vecRow -> [Pixels.Vertex] in
            return vecRow.map({ vec -> Pixels.Vertex in
                return Pixels.Vertex(x: vec.x / res.aspect, y: vec.y, s: 0.0, t: 0.0)
            })
        })
    }
    
    func mapGrid(_ vertecies: [[Pixels.Vertex]]) -> [Pixels.Vertex] {
        var verteciesMap: [Pixels.Vertex] = []
        for y in 0..<gridRes.h {
            for x in 0..<gridRes.w {
                let vertexBottomLeft = vertecies[y][x]
                let vertexTopLeft = vertecies[y][x + 1]
                let vertexBottomRight = vertecies[y + 1][x]
                let vertexTopRight = vertecies[y + 1][x + 1]
                verteciesMap.append(vertexTopLeft)
                verteciesMap.append(vertexTopRight)
                verteciesMap.append(vertexBottomLeft)
                verteciesMap.append(vertexBottomRight)
                verteciesMap.append(vertexBottomLeft)
                verteciesMap.append(vertexTopRight)
            }
        }
        return verteciesMap
    }
    
    func offset(grid: [[_3DVec]], by offest: _3DVec) -> [[_3DVec]] {
        return grid.map({ row -> [_3DVec] in
            return row.map({ vtx -> _3DVec in
                var vtx = vtx
                vtx.x += offest.x
                vtx.y += offest.y
                vtx.z += offest.z
                return vtx
            })
        })
    }
    
}
