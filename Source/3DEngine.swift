//
//  3DEngine.swift
//  VertexKit
//
//  Created by Hexagons on 2018-06-30.
//  Copyright © 2018 Hexagons. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import PixelKit

#if os(iOS)
public typealias _Color = UIColor
public typealias _View = UIView
public typealias _Image = UIImage
#elseif os(macOS)
public typealias _Color = NSColor
public typealias _View = NSView
public typealias _Image = NSImage
#endif


public protocol _3DObj {
    
    var id: UUID { get }
    
    var pos: _3DVec { get set }
    var rot: _3DVec { get set }
    var scl: _3DVec { get set }
    var trans: _3DTrans { get set }
    
    var color: _Color? { get set }
    
    func position(to _3dCoord: _3DVec)
    func position(by _3dCoord: _3DVec)
    
    func rotate(to _3dCoord: _3DVec)
    func rotate(by _3dCoord: _3DVec)
    
    func scale(to _3dCoord: _3DVec)
    func scale(by _3dCoord: _3DVec)
    func scale(to val: CGFloat)
    func scale(by val: CGFloat)
    
    func transform(to _3dTrans: _3DTrans)
    func transform(by _3dTrans: _3DTrans)
    
}

public protocol _3DRoot: _3DObj {
    
    var id: UUID { get }
    
    var view: _View { get }
    var snapshot: _Image { get }
    
    var worldScale: CGFloat { get set }

    func add(_ obj: _3DObj)
    func add(_ obj: _3DObj, to objParent: _3DObj)
    
    func remove(_ obj: _3DObj)
    
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
    
    var debugMode: Bool { get set }
    var globalWorldScale: CGFloat { get set }
    
    var roots: [_3DRoot] { get set }

    
    func createRoot(at size: CGSize?) -> _3DRoot
    func addRoot(_ objRoot: _3DRoot)
    func removeRoot(_ objRoot: _3DRoot)
    
    func create(_ _3dObjKind: _3DObjKind) -> _3DObj
    func create(triangle: _3DTriangle) -> _3DObj
    func create(line: _3DLine) -> _3DObj

    func debug()
    
}
