//
//  3DRawEngine.swift
//  VertexKit
//
//  Created by Hexagons on 2018-09-16.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import Foundation
import CoreGraphics
import PixelKit

// MARK: Obj

class _3DRawObj: _3DObj {
    
    let id: UUID
    
    var pos: _3DVec { get { return _3DVec(xyz: 0.0) } set {} }
    var rot: _3DVec { get { return _3DVec(xyz: 0.0) } set {} }
    var scl: _3DVec { get { return _3DVec(xyz: 0.0) } set {} }
    var trans: _3DTrans {
        get {
            return _3DTrans(
                pos:_3DVec(xyz: 0.0),
                rot: _3DVec(xyz: 0.0),
                scl: _3DVec(xyz: 0.0)
            )
        }
        set {}
    }
    
    var color: _Color? = .clear
    
    init() {
        id = UUID()
    }
    
    func position(to _3dCoord: _3DVec) {}
    func position(by _3dCoord: _3DVec) {}
    
    func rotate(to _3dCoord: _3DVec) {}
    func rotate(by _3dCoord: _3DVec) {}
    
    func scale(to _3dCoord: _3DVec) {}
    func scale(by _3dCoord: _3DVec) {}
    
    func scale(to val: CGFloat) {}
    func scale(by val: CGFloat) {}
    
    func transform(to _3dTrans: _3DTrans) {}
    func transform(by _3dTrans: _3DTrans) {}
    
}

// MARK: Root

class _3DRawRoot: _3DRawObj, _3DRoot {
    
    var view: _View
    
    var snapshot: _Image {
        return _Image(named: "")!
    }
    
    var worldScale: CGFloat = 1.0
    
    override init() {
        view = _View()
        super.init()
    }
    
    func add(_ obj: _3DObj) {}
    func add(_ obj: _3DObj, to objParent: _3DObj) {}
    
    func remove(_ obj: _3DObj) {}
    
}

// MARK: Engine

class _3DRawEngine: _3DEngine {  
    
    var debugMode: Bool = false

    var globalWorldScale: CGFloat = 1.0

    var roots: [_3DRoot] = []
    
    init() {
        
    }
    
    func debug() {}
    
    func createRoot(at size: CGSize?) -> _3DRoot {
        return _3DRawRoot()
    }
    
    func addRoot(_ objRoot: _3DRoot) {}
    
    func removeRoot(_ objRoot: _3DRoot) {}
    
    func create(_ _3dObjKind: _3DObjKind) -> _3DObj {
        return _3DRawObj()
    }
    func create(triangle: _3DTriangle) -> _3DObj {
        return _3DRawObj()
    }
    func create(line: _3DLine) -> _3DObj {
        return _3DRawObj()
    }
    
}
