//
//  3DCoord.swift
//  Hx3dE
//
//  Created by Hexagons on 2018-08-13.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import Foundation

public struct _3DVec {
    public var x: Double
    public var y: Double
    public var z: Double
    public init(x: Double, y: Double, z: Double) {
        self.x = x; self.y = y; self.z = z
    }
    public init(xyz: Double) {
        x = xyz; y = xyz; z = xyz
    }
    public static let zero = _3DVec(x: 0, y: 0, z: 0)
    public static let one = _3DVec(x: 1, y: 1, z: 1)
    public static func == (lhs: _3DVec, rhs: _3DVec) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    public static func != (lhs: _3DVec, rhs: _3DVec) -> Bool {
        return !(lhs == rhs)
    }
    public static func + (lhs: _3DVec, rhs: _3DVec) -> _3DVec {
        return _3DVec(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    public static func - (lhs: _3DVec, rhs: _3DVec) -> _3DVec {
        return _3DVec(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    public static func * (lhs: _3DVec, rhs: _3DVec) -> _3DVec {
        return _3DVec(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }
    public static func * (lhs: _3DVec, rhs: Double) -> _3DVec {
        return _3DVec(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    public static func * (lhs: Double, rhs: _3DVec) -> _3DVec { return rhs * lhs }
    public static func / (lhs: _3DVec, rhs: _3DVec) -> _3DVec {
        return _3DVec(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
    }
    public static func / (lhs: _3DVec, rhs: Double) -> _3DVec {
        return _3DVec(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
    public static func += (lhs: inout _3DVec, rhs: _3DVec) { lhs = lhs + rhs }
    public static func -= (lhs: inout _3DVec, rhs: _3DVec) { lhs = lhs - rhs }
    public static func *= (lhs: inout _3DVec, rhs: _3DVec) { lhs = lhs * rhs }
    public static func *= (lhs: inout _3DVec, rhs: Double) { lhs = lhs * rhs }
    public static func /= (lhs: inout _3DVec, rhs: _3DVec) { lhs = lhs / rhs }
}

infix operator +*=
public struct _3DTrans {
    public var pos: _3DVec
    public var rot: _3DVec
    public var scl: _3DVec
    public static let identity = _3DTrans(pos: _3DVec.zero, rot: _3DVec.zero, scl: _3DVec.one)
    public static func == (lhs: _3DTrans, rhs: _3DTrans) -> Bool {
        return lhs.pos == rhs.pos && lhs.rot == rhs.rot && lhs.scl == rhs.scl
    }
    public static func != (lhs: _3DTrans, rhs: _3DTrans) -> Bool {
        return !(lhs == rhs)
    }
    public static func +*= (lhs: inout _3DTrans, rhs: _3DTrans) {
        lhs.pos *= rhs.scl
        lhs.pos += rhs.pos
        lhs.rot += rhs.rot
        lhs.scl *= rhs.scl
    }
}

public struct _3DVert {
    public let pos: _3DVec
    public init(_ pos: _3DVec) {
        self.pos = pos
    }
}

public struct _3DPoly {
    public let verts: [_3DVert]
    public init(verts: [_3DVert]) {
        self.verts = verts
    }
}

//public struct _3DQuad {
//    public var polyA: _3DPoly
//    public var polyB: _3DPoly
//}
