//
//  Grid3DPIX.swift
//  VertexKit
//
//  Created by Anton Heestand on 2018-09-22.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import RenderKit
import PixelKit
import Resolution

public class Grid3DPIX: _3DPIX {
    
    public var gridResolution: Resolution { didSet { render() } }
    public var gridSize: CGSize { didSet { render() } }
    
//    public override var instanceCount: Int {
//        return ((gridResolution.w + 1) * (gridResolution.h + 1)) / 3
//    }
    public override var vertices: [RenderKit.Vertex] {
        return mapGrid(vtxGrid(vecGrid(plusOne: true)))
    }
    public override var wireframe: Bool { return true }
    
    // MARK: - Life Cycle -
    
    public init(at resolution: Resolution, gridResolution: Resolution) {
        self.gridResolution = gridResolution
        gridSize = CGSize(width: resolution.aspect, height: 1.0)
        super.init(at: resolution)
    }
    
    required init(at resolution: Resolution) {
        gridResolution = .custom(w: 10, h: 10)
        gridSize = CGSize(width: 1.0, height: 1.0)
        super.init(at: resolution)
    }
    
    // MARK: - Codable
    
    enum CodingKeys: CodingKey {
        case gridResolution
        case gridSize
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gridResolution = try container.decode(Resolution.self, forKey: .gridResolution)
        gridSize = try container.decode(CGSize.self, forKey: .gridSize)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gridResolution, forKey: .gridResolution)
        try container.encode(gridSize, forKey: .gridSize)
        try super.encode(to: encoder)
    }
    
    // MARK: - Grid
    
    func vecGrid(plusOne: Bool = false) -> [[_3DVec]] {
        
        let plus = plusOne ? 1 : 0
        
        var vecs: [[_3DVec]] = []
        for y in 0..<gridResolution.h + plus {
            let v = CGFloat(y) / gridResolution.height
            var vecRow: [_3DVec] = []
            for x in 0..<gridResolution.w + plus {
                let u = CGFloat(x) / gridResolution.width
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
    
    func vtxGrid(_ vecGrid: [[_3DVec]]) -> [[RenderKit.Vertex]] {
        return vecGrid.map({ vecRow -> [RenderKit.Vertex] in
            return vecRow.map({ vec -> RenderKit.Vertex in
                return RenderKit.Vertex(x: vec.x / resolution.aspect, y: vec.y, s: 0.0, t: 0.0)
            })
        })
    }
    
    func mapGrid(_ vertices: [[RenderKit.Vertex]]) -> [RenderKit.Vertex] {
        var verticesMap: [RenderKit.Vertex] = []
        for y in 0..<gridResolution.h {
            for x in 0..<gridResolution.w {
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
    
}
