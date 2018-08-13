//
//  3DCoord.swift
//  Hx3dE
//
//  Created by Hexagons on 2018-08-13.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import Foundation

public struct _3DCoord {
    public var x: Double
    public var y: Double
    public var z: Double
    public init(x: Double, y: Double, z: Double) {
        self.x = x; self.y = y; self.z = z
    }
    public init(xyz: Double) {
        x = xyz; y = xyz; z = xyz
    }
    public static let zero = _3DCoord(x: 0, y: 0, z: 0)
    public static let one = _3DCoord(x: 1, y: 1, z: 1)
    public static func == (lhs: _3DCoord, rhs: _3DCoord) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    public static func != (lhs: _3DCoord, rhs: _3DCoord) -> Bool {
        return !(lhs == rhs)
    }
    public static func + (lhs: _3DCoord, rhs: _3DCoord) -> _3DCoord {
        return _3DCoord(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    public static func - (lhs: _3DCoord, rhs: _3DCoord) -> _3DCoord {
        return _3DCoord(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    public static func * (lhs: _3DCoord, rhs: _3DCoord) -> _3DCoord {
        return _3DCoord(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }
    public static func * (lhs: _3DCoord, rhs: Double) -> _3DCoord {
        return _3DCoord(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    public static func * (lhs: Double, rhs: _3DCoord) -> _3DCoord { return rhs * lhs }
    public static func / (lhs: _3DCoord, rhs: _3DCoord) -> _3DCoord {
        return _3DCoord(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
    }
    public static func / (lhs: _3DCoord, rhs: Double) -> _3DCoord {
        return _3DCoord(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
    public static func += (lhs: inout _3DCoord, rhs: _3DCoord) { lhs = lhs + rhs }
    public static func -= (lhs: inout _3DCoord, rhs: _3DCoord) { lhs = lhs - rhs }
    public static func *= (lhs: inout _3DCoord, rhs: _3DCoord) { lhs = lhs * rhs }
    public static func *= (lhs: inout _3DCoord, rhs: Double) { lhs = lhs * rhs }
    public static func /= (lhs: inout _3DCoord, rhs: _3DCoord) { lhs = lhs / rhs }
}

infix operator +*=
public struct _3DTrans {
    public var pos: _3DCoord
    public var rot: _3DCoord
    public var scl: _3DCoord
    public static let identity = _3DTrans(pos: _3DCoord.zero, rot: _3DCoord.zero, scl: _3DCoord.one)
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
