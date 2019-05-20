//
//  3DCoord.swift
//  VertexKit
//
//  Created by Hexagons on 2018-08-13.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics
import PixelKit

public struct _3DVec {
    public var x: LiveFloat
    public var y: LiveFloat
    public var z: LiveFloat
    public init(x: LiveFloat, y: LiveFloat, z: LiveFloat) {
        self.x = x; self.y = y; self.z = z
    }
//    public init(x: CGFloat, y: CGFloat, z: CGFloat) {
//        self.x = LiveFloat(x); self.y = LiveFloat(y); self.z = LiveFloat(z)
//    }
    public init(xyz: LiveFloat) {
        x = xyz; y = xyz; z = xyz
    }
//    public init(xyz: CGFloat) {
//        x = LiveFloat(xyz); y = LiveFloat(xyz); z = LiveFloat(xyz)
//    }
    public static let zero = _3DVec(x: 0, y: 0, z: 0)
    public static let one = _3DVec(x: 1, y: 1, z: 1)
    public static func == (lhs: _3DVec, rhs: _3DVec) -> LiveBool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    public static func != (lhs: _3DVec, rhs: _3DVec) -> LiveBool {
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
    public static func * (lhs: _3DVec, rhs: LiveFloat) -> _3DVec {
        return _3DVec(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    public static func * (lhs: LiveFloat, rhs: _3DVec) -> _3DVec { return rhs * lhs }
    public static func / (lhs: _3DVec, rhs: _3DVec) -> _3DVec {
        return _3DVec(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
    }
    public static func / (lhs: _3DVec, rhs: LiveFloat) -> _3DVec {
        return _3DVec(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
    public static func += (lhs: inout _3DVec, rhs: _3DVec) { lhs = lhs + rhs }
    public static func -= (lhs: inout _3DVec, rhs: _3DVec) { lhs = lhs - rhs }
    public static func *= (lhs: inout _3DVec, rhs: _3DVec) { lhs = lhs * rhs }
    public static func *= (lhs: inout _3DVec, rhs: LiveFloat) { lhs = lhs * rhs }
    public static func /= (lhs: inout _3DVec, rhs: _3DVec) { lhs = lhs / rhs }
    public mutating func zRotate(by ang: LiveFloat, at origin: _3DVec = .zero) {
        let tx = (x - origin.x)
        let ty = (y - origin.y)
        var rot = atan2(ty, tx)
        rot += ang
        let rad = sqrt(pow(tx, 2) + pow(ty, 2))
        x = origin.x + cos(rot) * rad
        y = origin.y + sin(rot) * rad
    }
    public mutating func scale(by s: LiveFloat, at origin: _3DVec = .zero) {
        scale(by: _3DVec(xyz: s), at: origin)
    }
    public mutating func scale(by s: _3DVec, at origin: _3DVec = .zero) {
        let vec = self - origin
        self = origin + vec * s
    }
}

public struct _3DUV {
    public var u: LiveFloat
    public var v: LiveFloat
    public init(u: LiveFloat, v: LiveFloat) {
        self.u = u; self.v = v
    }
}

infix operator +*=
public struct _3DTrans {
    public var pos: _3DVec
    public var rot: _3DVec
    public var scl: _3DVec
    public static let identity = _3DTrans(pos: _3DVec.zero, rot: _3DVec.zero, scl: _3DVec.one)
    public static func == (lhs: _3DTrans, rhs: _3DTrans) -> LiveBool {
        return lhs.pos == rhs.pos && lhs.rot == rhs.rot && lhs.scl == rhs.scl
    }
    public static func != (lhs: _3DTrans, rhs: _3DTrans) -> LiveBool {
        return !(lhs == rhs)
    }
    public static func +*= (lhs: inout _3DTrans, rhs: _3DTrans) {
        lhs.pos *= rhs.scl
        lhs.pos += rhs.pos
        lhs.rot += rhs.rot
        lhs.scl *= rhs.scl
    }
}

public struct UV {
    public var u: LiveFloat
    public var v: LiveFloat
}

public struct _3DVert {
    public let pos: _3DVec
    public let norm: _3DVec
    public let uv: UV
    public init(_ pos: _3DVec) {
        self.pos = pos
        norm = _3DVec(x: 0, y: 0, z: 1)
        uv = UV(u: 0.5, v: 0.5)
    }
}

public struct _3DLine {
    public let vertA: _3DVert
    public let vertB: _3DVert
    public var verts: [_3DVert] {
        return [vertA, vertB]
    }
    public init(_ vertA: _3DVert, _ vertB: _3DVert) {
        self.vertA = vertA
        self.vertB = vertB
    }
}

public struct _3DTriangle {
    public let vertA: _3DVert
    public let vertB: _3DVert
    public let vertC: _3DVert
    public var verts: [_3DVert] {
        return [vertA, vertB, vertC]
    }
    public init(_ vertA: _3DVert, _ vertB: _3DVert, _ vertC: _3DVert) {
        self.vertA = vertA
        self.vertB = vertB
        self.vertC = vertC
    }
}

//public struct _3DPoly {
//    public let verts: [_3DVert]
//    public init(verts: [_3DVert]) {
//        self.verts = verts
//    }
//}

//public struct _3DQuad {
//}
