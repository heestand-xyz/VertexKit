//
//  Hx3dE.swift
//  Hx3dE
//
//  Created by Hexagons on 2018-08-02.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import Foundation

public class Hx3dE {
    
    public static let main = Hx3dE()
    
    public let engine: _3DEngine = _3DScnEngine()
    
    let kSlug = "Hx3dE"
    let kName = "Hexagon 3D Engine"
    let kBundleId = "house.hexagon.hx3de"
    
    struct HxHSignature: Encodable {
        let slug: String
        let name: String
        let id: String
        let version: Float
        let build: Int
        var formatted: String {
            return "\(slug) - \(name) - \(id) - v\(version) - b\(build)"
        }
    }
    
    var hxhSignature: HxHSignature {
        return HxHSignature(slug: kSlug, name: kName, id: kBundleId, version: Float(Bundle(identifier: kBundleId)!.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-1")!, build: Int(Bundle(identifier: kBundleId)!.infoDictionary?["CFBundleVersion"] as? String ?? "-1")!)
    }
    
    init() {
        print(hxhSignature.formatted)
    }
    
}
