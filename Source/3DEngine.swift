//
//  3DEngine.swift
//  Pixel Nodes
//
//  Created by Hexagons on 2018-06-30.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import UIKit

public protocol _3DObj {
    
    var id: UUID { get }
    
    var trans: _3DTrans { get set }
    
    func transform(to _3dTrans: _3DTrans)
    func transform(by _3dTrans: _3DTrans)
    
    var pos: _3DCoord { get set }
    var rot: _3DCoord { get set }
    var scl: _3DCoord { get set }
    
    var color: UIColor? { get set }
    
    func position(to _3dCoord: _3DCoord)
    func position(by _3dCoord: _3DCoord)
    
    func rotate(to _3dCoord: _3DCoord)
    func rotate(by _3dCoord: _3DCoord)
    
    func scale(to _3dCoord: _3DCoord)
    func scale(by _3dCoord: _3DCoord)
    func scale(to val: Double)
    func scale(by val: Double)
    
}

public protocol _3DRoot: _3DObj {
    
    var id: UUID { get }
    
    func add(_ obj: _3DObj)
    func add(_ obj: _3DObj, to objParent: _3DObj)
    
    func remove(_ obj: _3DObj)
    
    var worldScale: Double { get set }
    
    var view: UIView { get }
    var snapshot: UIImage { get }
    
}

public enum _3DObjKind {
    case node
    case plane
    case box
    case sphere
    case pyramid
    case cone
    case cylinder
    case capsule
    case tube
    case torus
}

public protocol _3DEngine {
    
    var roots: [_3DRoot] { get set }
    
    func addRoot(_ objRoot: _3DRoot)
    
    func removeRoot(_ objRoot: _3DRoot)
    
    var globalWorldScale: Double { get set }
    
    func createRoot() -> _3DRoot
    
    func create(obj _3dObjKind: _3DObjKind) -> _3DObj
    
}
