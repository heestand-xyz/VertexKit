//
//  3DScnEngine.swift
//  Pixel Nodes
//
//  Created by Hexagons on 2018-06-30.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import SceneKit

// MARK: Obj

extension _3DCoord {
    var vec: SCNVector3 {
        get {
            return SCNVector3(x, y, z)
        }
    }
}

private extension SCNVector3 {
    var _3dCoord: _3DCoord {
        get {
            return _3DCoord(x: Double(x), y: Double(y), z: Double(z))
        }
    }
}

public class _3DScnObj: _3DObj {
    
    public let id = UUID()
    
    let node: SCNNode
    
    public var pos: _3DCoord { get { return node.position._3dCoord } set { node.position = newValue.vec } }
    public var rot: _3DCoord { get { return node.eulerAngles._3dCoord } set { node.eulerAngles = newValue.vec } }
    public var scl: _3DCoord { get { return node.scale._3dCoord } set { node.scale = newValue.vec } }
    public var trans: _3DTrans {
        get { return _3DTrans(pos: pos, rot: rot, scl: scl) }
        set { pos = newValue.pos; rot = newValue.rot; scl = newValue.scl }
    }
    
    init(geometry: SCNGeometry) {
        node = SCNNode(geometry: geometry)
    }
    init(node: SCNNode) {
        self.node = node
    }
    
    public func transform(to _3dTrans: _3DTrans) { trans = _3dTrans }
    public func transform(by _3dTrans: _3DTrans) { trans +*= _3dTrans }
    
    public func position(to _3dCoord: _3DCoord) { pos = _3dCoord }
    public func position(by _3dCoord: _3DCoord) { pos += _3dCoord }
    
    public func rotate(to _3dCoord: _3DCoord) { rot = _3dCoord }
    public func rotate(by _3dCoord: _3DCoord) { rot += _3dCoord }
    
    public func scale(to _3dCoord: _3DCoord) { scl = _3dCoord }
    public func scale(by _3dCoord: _3DCoord) { scl *= _3dCoord }
    public func scale(to val: Double) { scl = _3DCoord(x: val, y: val, z: val) }
    public func scale(by val: Double) { scl *= _3DCoord(x: val, y: val, z: val) }
    
}

// MARK: Root

public class _3DScnRoot: _3DScnObj, _3DRoot {
    
    public var worldScale: Double {
        get { return scn.rootNode.scale._3dCoord.x }
        set { scn.rootNode.scale = SCNVector3(x: Float(newValue), y: Float(newValue), z: Float(newValue)) }
    }
    
    public let view: UIView
    let scn = SCNScene()

    init() {
        
        let scnView = SCNView()
        scnView.backgroundColor = .clear
        scnView.autoenablesDefaultLighting = true
//        scnView.allowsCameraControl = true
        scnView.scene = scn
        view = scnView
        
        super.init(node: scn.rootNode)
        
    }
    
    public func add(_ obj: _3DObj, to objParent: _3DObj?) {
        let scnGeo3DObj = obj as! _3DScnObj
        if objParent != nil {
            let scnGeo3DObjParent = objParent as! _3DScnObj
            scnGeo3DObjParent.node.addChildNode(scnGeo3DObj.node)
        } else {
            scn.rootNode.addChildNode(scnGeo3DObj.node)
        }
    }
    
    public func remove(_ obj: _3DObj) {
        let scnGeo3DObj = obj as! _3DScnObj
        scnGeo3DObj.node.removeFromParentNode()
    }
    
}

// MARK: Engine

public class _3DScnEngine: _3DEngine {
        
    public var roots: [_3DRoot] = []
    
    public var globalWorldScale: Double = 1 {
        didSet {
            for root in roots as! [_3DScnRoot] {
                root.worldScale = globalWorldScale
            }
        }
    }
    
    public func create(_ _3dObjKind: _3DObjKind) -> _3DObj {
        
        let scnGeoPrim: _3DScnObj
        switch _3dObjKind {
        case .node:
            scnGeoPrim = _3DScnObj(node: SCNNode())
        case .sphere:
            scnGeoPrim = _3DScnObj(geometry: SCNSphere(radius: 0.5))
        case .box:
            scnGeoPrim = _3DScnObj(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
        }
        
        return scnGeoPrim
        
    }
    
    public func addRoot(_ root: _3DRoot) {
        var root = root
        root.worldScale = globalWorldScale
        roots.append(root)
    }
    
    public func removeRoot(_ root: _3DRoot) {
        for (i, i_root) in roots.enumerated() {
            if i_root.id == root.id {
                roots.remove(at: i)
                break
            }
        }
    }
    
}
