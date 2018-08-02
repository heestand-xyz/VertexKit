//
//  3DEngine.swift
//  Pixel Nodes
//
//  Created by Hexagons on 2018-06-30.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import UIKit

struct _3DCoord {
    var x: Double
    var y: Double
    var z: Double
    static let zero = _3DCoord(x: 0, y: 0, z: 0)
    static let one = _3DCoord(x: 1, y: 1, z: 1)
    static func == (lhs: _3DCoord, rhs: _3DCoord) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    static func != (lhs: _3DCoord, rhs: _3DCoord) -> Bool {
        return !(lhs == rhs)
    }
    static func + (lhs: _3DCoord, rhs: _3DCoord) -> _3DCoord {
        return _3DCoord(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    static func - (lhs: _3DCoord, rhs: _3DCoord) -> _3DCoord {
        return _3DCoord(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    static func * (lhs: _3DCoord, rhs: _3DCoord) -> _3DCoord {
        return _3DCoord(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }
    static func * (lhs: _3DCoord, rhs: Double) -> _3DCoord {
        return _3DCoord(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    static func * (lhs: Double, rhs: _3DCoord) -> _3DCoord { return rhs * lhs }
    static func / (lhs: _3DCoord, rhs: _3DCoord) -> _3DCoord {
        return _3DCoord(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
    }
    static func / (lhs: _3DCoord, rhs: Double) -> _3DCoord {
        return _3DCoord(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
    static func += (lhs: inout _3DCoord, rhs: _3DCoord) { lhs = lhs + rhs }
    static func -= (lhs: inout _3DCoord, rhs: _3DCoord) { lhs = lhs - rhs }
    static func *= (lhs: inout _3DCoord, rhs: _3DCoord) { lhs = lhs * rhs }
    static func *= (lhs: inout _3DCoord, rhs: Double) { lhs = lhs * rhs }
    static func /= (lhs: inout _3DCoord, rhs: _3DCoord) { lhs = lhs / rhs }
}

infix operator +*=
struct _3DTrans {
    var pos: _3DCoord
    var rot: _3DCoord
    var scl: _3DCoord
    static let identity = _3DTrans(pos: _3DCoord.zero, rot: _3DCoord.zero, scl: _3DCoord.one)
    static func == (lhs: _3DTrans, rhs: _3DTrans) -> Bool {
        return lhs.pos == rhs.pos && lhs.rot == rhs.rot && lhs.scl == rhs.scl
    }
    static func != (lhs: _3DTrans, rhs: _3DTrans) -> Bool {
        return !(lhs == rhs)
    }
    static func +*= (lhs: inout _3DTrans, rhs: _3DTrans) {
        lhs.pos *= rhs.scl
        lhs.pos += rhs.pos
        lhs.rot += rhs.rot
        lhs.scl *= rhs.scl
    }
}

protocol _3DObj {
    
    var id: UUID { get }
    
    var trans: _3DTrans { get set }
    
    func transform(to _3dTrans: _3DTrans)
    func transform(by _3dTrans: _3DTrans)
    
    var pos: _3DCoord { get set }
    var rot: _3DCoord { get set }
    var scl: _3DCoord { get set }
    
    func position(to _3dCoord: _3DCoord)
    func position(by _3dCoord: _3DCoord)
    
    func rotate(to _3dCoord: _3DCoord)
    func rotate(by _3dCoord: _3DCoord)
    
    func scale(to _3dCoord: _3DCoord)
    func scale(by _3dCoord: _3DCoord)
    func scale(to val: Double)
    func scale(by val: Double)
    
}

protocol _3DRoot: _3DObj {
    
    var id: UUID { get }
    
    /// if no objParent, add to root
    func add(_ obj: _3DObj, to objParent: _3DObj?)
    
    func remove(_ obj: _3DObj)
    
    var worldScale: Double { get set }
    
    var view: UIView { get }
    
}

enum _3DObjKind {
    case node
    case sphere
    case box
}

protocol _3DEngine {
    
    var roots: [_3DRoot] { get set }
    
    func addRoot(_ objRoot: _3DRoot)
    
    func removeRoot(_ objRoot: _3DRoot)
    
    var globalWorldScale: Double { get set }
    
    func create(_ _3dObjKind: _3DObjKind) -> _3DObj
    
}
