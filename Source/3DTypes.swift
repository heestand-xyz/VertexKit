//
//  3DCoord.swift
//  Pixels3D
//
//  Created by Hexagons on 2018-08-13.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import CoreGraphics

public struct _3DVec {
    public var x: CGFloat
    public var y: CGFloat
    public var z: CGFloat
    public init(x: CGFloat, y: CGFloat, z: CGFloat) {
        self.x = x; self.y = y; self.z = z
    }
    public init(xyz: CGFloat) {
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
    public static func * (lhs: _3DVec, rhs: CGFloat) -> _3DVec {
        return _3DVec(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    public static func * (lhs: CGFloat, rhs: _3DVec) -> _3DVec { return rhs * lhs }
    public static func / (lhs: _3DVec, rhs: _3DVec) -> _3DVec {
        return _3DVec(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
    }
    public static func / (lhs: _3DVec, rhs: CGFloat) -> _3DVec {
        return _3DVec(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
    public static func += (lhs: inout _3DVec, rhs: _3DVec) { lhs = lhs + rhs }
    public static func -= (lhs: inout _3DVec, rhs: _3DVec) { lhs = lhs - rhs }
    public static func *= (lhs: inout _3DVec, rhs: _3DVec) { lhs = lhs * rhs }
    public static func *= (lhs: inout _3DVec, rhs: CGFloat) { lhs = lhs * rhs }
    public static func /= (lhs: inout _3DVec, rhs: _3DVec) { lhs = lhs / rhs }
    public mutating func zRotate(by ang: CGFloat, at origin: _3DVec = .zero) {
        let tx = (x - origin.x)
        let ty = (y - origin.y)
        var rot = atan2(ty, tx)
        rot += ang
        let rad = sqrt(pow(tx, 2) + pow(ty, 2))
        x = origin.x + cos(rot) * rad
        y = origin.y + sin(rot) * rad
    }
    public mutating func scale(by s: CGFloat, at origin: _3DVec = .zero) {
        scale(by: _3DVec(xyz: s), at: origin)
    }
    public mutating func scale(by s: _3DVec, at origin: _3DVec = .zero) {
        let vec = self - origin
        self = origin + vec * s
    }
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

public struct UV {
    public var u: CGFloat
    public var v: CGFloat
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
