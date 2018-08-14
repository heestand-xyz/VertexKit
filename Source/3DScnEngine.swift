//
//  3DScnEngine.swift
//  Pixel Nodes
//
//  Created by Hexagons on 2018-06-30.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import SceneKit

// MARK: Obj

extension _3DVec {
    var scnVec: SCNVector3 { get { return SCNVector3(x, y, z) } }
}

private extension SCNVector3 {
    var vec: _3DVec { get { return _3DVec(x: Double(x), y: Double(y), z: Double(z)) } }
}

class _3DScnObj: _3DObj {
    
    let id = UUID()
    
    let node: SCNNode
    
    var pos: _3DVec { get { return node.position.vec } set { node.position = newValue.scnVec } }
    var rot: _3DVec { get { return node.eulerAngles.vec } set { node.eulerAngles = newValue.scnVec } }
    var scl: _3DVec { get { return node.scale.vec } set { node.scale = newValue.scnVec } }
    var trans: _3DTrans {
        get { return _3DTrans(pos: pos, rot: rot, scl: scl) }
        set { pos = newValue.pos; rot = newValue.rot; scl = newValue.scl }
    }
    
    var color: UIColor? {
        get { return node.geometry?.firstMaterial?.diffuse.contents as? UIColor }
        set { node.geometry?.firstMaterial?.diffuse.contents = newValue }
    }
    
    init(geometry: SCNGeometry) {
        node = SCNNode(geometry: geometry)
    }
    init(node: SCNNode) {
        self.node = node
    }
    
    func transform(to _3dTrans: _3DTrans) { trans = _3dTrans }
    func transform(by _3dTrans: _3DTrans) { trans +*= _3dTrans }
    
    func position(to _3dCoord: _3DVec) { pos = _3dCoord }
    func position(by _3dCoord: _3DVec) { pos += _3dCoord }
    
    func rotate(to _3dCoord: _3DVec) { rot = _3dCoord }
    func rotate(by _3dCoord: _3DVec) { rot += _3dCoord }
    
    func scale(to _3dCoord: _3DVec) { scl = _3dCoord }
    func scale(by _3dCoord: _3DVec) { scl *= _3dCoord }
    func scale(to val: Double) { scl = _3DVec(x: val, y: val, z: val) }
    func scale(by val: Double) { scl *= _3DVec(x: val, y: val, z: val) }
    
}

// MARK: Root

class _3DScnRoot: _3DScnObj, _3DRoot {
    
    var worldScale: Double {
        get { return scn.rootNode.scale.vec.x }
        set { scn.rootNode.scale = SCNVector3(x: Float(newValue), y: Float(newValue), z: Float(newValue)) }
    }
    
    let view: UIView
    let scn = SCNScene()
    
    var snapshot: UIImage {
        return (view as! SCNView).snapshot()
    }
    
//    let cam: SCNCamera
//    let camNode: SCNNode

    init(ortho: Bool = false, debug: Bool) {
        
        let scnView = SCNView()
        scnView.backgroundColor = .clear
        scnView.autoenablesDefaultLighting = true
//        scnView.allowsCameraControl = true
        scnView.scene = scn
        if debug {
//            scnView.debugOptions.insert(.showWireframe)
            if #available(iOS 11.0, *) { scnView.debugOptions.insert(.renderAsWireframe) }
//            scnView.debugOptions.insert(.showBoundingBoxes)
            scnView.showsStatistics = true
//            glLineWidth(20)
        }
        view = scnView

        
//        cam = SCNCamera()
//        cam.automaticallyAdjustsZRange = true
//        if #available(iOS 11.0, *) {
//            cam.fieldOfView = 53.1301023542
//        }
//        if ortho {
//            cam.usesOrthographicProjection = true
////            cam.orthographicScale = 1
//        }
//        camNode = SCNNode()
//        camNode.position = SCNVector3(x: 0, y: 0, z: 1)
//        camNode.camera = cam
//        scn.rootNode.addChildNode(camNode)
        
        super.init(node: scn.rootNode)
        
    }
    
    func add(_ obj: _3DObj) {
        let scnGeo3DObj = obj as! _3DScnObj
        scn.rootNode.addChildNode(scnGeo3DObj.node)
    }
    
    func add(_ obj: _3DObj, to objParent: _3DObj) {
        let scnGeo3DObj = obj as! _3DScnObj
        let scnGeo3DObjParent = objParent as! _3DScnObj
        scnGeo3DObjParent.node.addChildNode(scnGeo3DObj.node)
    }
    
    func remove(_ obj: _3DObj) {
        let scnGeo3DObj = obj as! _3DScnObj
        scnGeo3DObj.node.removeFromParentNode()
    }
    
}

// MARK: Engine

class _3DScnEngine: _3DEngine {
    
    var debugMode: Bool = false
    func debug() { debugMode = true }
        
    var roots: [_3DRoot] = []
    
    var globalWorldScale: Double = 1 {
        didSet {
            for root in roots as! [_3DScnRoot] {
                root.worldScale = globalWorldScale
            }
        }
    }
    
    func createRoot() -> _3DRoot {
        return _3DScnRoot(debug: debugMode)
    }
    
    func create(_ _3dObjKind: _3DObjKind) -> _3DObj {
        
        let scnGeoPrim: _3DScnObj
        switch _3dObjKind {
        case .node:
            scnGeoPrim = _3DScnObj(node: SCNNode())
        case .plane:
            scnGeoPrim = _3DScnObj(geometry: SCNPlane(width: 1, height: 1))
        case .box:
            scnGeoPrim = _3DScnObj(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
        case .sphere:
            scnGeoPrim = _3DScnObj(geometry: SCNSphere(radius: 0.5)) // .isGeodesic
        case .pyramid:
            scnGeoPrim = _3DScnObj(geometry: SCNPyramid(width: 1.5, height: 1, length: 1.5)) // 146.5 230.4
        case .cone:
            scnGeoPrim = _3DScnObj(geometry: SCNCone(topRadius: 0, bottomRadius: 1, height: 1))
        case .cylinder:
            scnGeoPrim = _3DScnObj(geometry: SCNCylinder(radius: 1, height: 1))
        case .capsule:
            scnGeoPrim = _3DScnObj(geometry: SCNCapsule(capRadius: 0.5, height: 1))
        case .tube:
            scnGeoPrim = _3DScnObj(geometry: SCNTube(innerRadius: 0.5, outerRadius: 1, height: 1))
        case .torus:
            scnGeoPrim = _3DScnObj(geometry: SCNTorus(ringRadius: 1, pipeRadius: 0.5))
        }
                
        return scnGeoPrim
        
    }
    
    func create(from polys: [_3DPoly]) -> _3DObj {
        
        var posArr: [_3DVec] = []
        var iArr: [Int] = []
        var i = 0
        for poly in polys {
            for vert in poly.verts {
                posArr.append(vert.pos)
                iArr.append(i)
                i += 1
            }
        }
        
        let vecArr = posArr.map { coord -> SCNVector3 in return coord.scnVec }
        
        let source = SCNGeometrySource(vertices: vecArr)
        let element = SCNGeometryElement(indices: iArr, primitiveType: .triangles) // .polygon
        
        let geo = SCNGeometry(sources: [source], elements: [element])
        let obj = _3DScnObj(geometry: geo)
        
        return obj
    }
    
    func addRoot(_ root: _3DRoot) {
        var root = root
        root.worldScale = globalWorldScale
        roots.append(root)
    }
    
    func removeRoot(_ root: _3DRoot) {
        for (i, i_root) in roots.enumerated() {
            if i_root.id == root.id {
                roots.remove(at: i)
                break
            }
        }
    }
    
}
