//
//  3DScnEngine.swift
//  VertexKit
//
//  Created by Hexagons on 2018-06-30.
//  Copyright © 2018 Hexagons. All rights reserved.
//

import SceneKit
import CoreGraphics
import PixelKit

// MARK: Obj

extension _3DVec {
    var scnVec: SCNVector3 {
        get {
            #if os(iOS)
            return SCNVector3(Float(x), Float(y), Float(z))
            #elseif os(macOS)
            return SCNVector3(x: x, y: y, z: z)
            #endif
        }
    }
}

private extension SCNVector3 {
    var vec: _3DVec { get { return _3DVec(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z)) } }
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
    
    var color: _Color? {
        get { return node.geometry?.firstMaterial?.diffuse.contents as? _Color }
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
    func scale(to val: CGFloat) { scl = _3DVec(x: val, y: val, z: val) }
    func scale(by val: CGFloat) { scl *= _3DVec(x: val, y: val, z: val) }
    
}

// MARK: Root

class _3DScnRoot: _3DScnObj, _3DRoot {
    
    var worldScale: CGFloat {
        get { return scn.rootNode.scale.vec.x }
        set {
            #if os(iOS)
            scn.rootNode.scale = SCNVector3(x: Float(newValue), y: Float(newValue), z: Float(newValue))
            #elseif os(macOS)
            scn.rootNode.scale = SCNVector3(x: newValue, y: newValue, z: newValue)
            #endif
        }
    }
    
    let view: _View
    let scn = SCNScene()
    
    var snapshot: _Image {
        return (view as! SCNView).snapshot()
    }
    
//    let cam: SCNCamera
//    let camNode: SCNNode

    init(ortho: Bool = false, debug: Bool, size: CGSize? = nil) {
        
        let scnView: SCNView
        if let size = size {
            let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scnView = SCNView(frame: bounds)
        } else {
            scnView = SCNView()
        }
        scnView.backgroundColor = .clear
        scnView.autoenablesDefaultLighting = true
//        scnView.allowsCameraControl = true
        scnView.scene = scn
        if debug {
            scnView.showsStatistics = true
            if #available(iOS 11.0, *) { if #available(OSX 10.13, *) {
                scnView.debugOptions.insert(.renderAsWireframe)
            } }
//            scnView.debugOptions.insert(.showWireframe)
//            scnView.debugOptions.insert(.showBoundingBoxes)
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
    
    var globalWorldScale: CGFloat = 1 {
        didSet {
            for root in roots as! [_3DScnRoot] {
                root.worldScale = globalWorldScale
            }
        }
    }
    
    func createRoot(at size: CGSize? = nil) -> _3DRoot {
        return _3DScnRoot(debug: debugMode, size: size)
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
    
    func create(triangle: _3DTriangle) -> _3DObj {
        
//        var posArr: [_3DVec] = []
//        var iArr: [Int] = []
//        var i = 0
//        for poly in polys {
//            for vert in poly.verts {
//                posArr.append(vert.pos)
//                iArr.append(i)
//                i += 1
//            }
//        }
        
        print(">>>")
        
        let iArr = triangle.verts.enumerated().map { i, _ -> Int in return i }
//        let element = SCNGeometryElement(indices: iArr, primitiveType: .triangles)
        let dat = Data(bytes: iArr, count: MemoryLayout<Int>.size * iArr.count)
        let element = SCNGeometryElement(data: dat, primitiveType: .triangles, primitiveCount: 1, bytesPerIndex: MemoryLayout<Int>.size)
        
//        let posArr = triangle.verts.map { vert -> SCNVector3 in return vert.pos.scnVec }
//        let normArr = triangle.verts.map { vert -> SCNVector3 in return vert.norm.scnVec }
//        let sourceVerts = SCNGeometrySource(vertices: posArr)
//        let sourceNorms = SCNGeometrySource(normals: normArr)
//        let sources = [sourceVerts, sourceNorms]
        let sources = createSources(from: triangle.verts)

        let geo = SCNGeometry(sources: sources, elements: [element])
        
        let obj = _3DScnObj(geometry: geo)
        
        return obj
    }
    
    func create(line: _3DLine) -> _3DObj {

//        var posArr: [_3DVec] = []
//        var iArr: [Int] = []
//        var i = 0
//        for poly in polys {
//            for vert in poly.verts {
//                posArr.append(vert.pos)
//                iArr.append(i)
//                i += 1
//            }
//        }

//        let vertArr = line.verts.map { vert -> SCNVector3 in return vert.pos.scnVec }
//        let normArr = line.verts.map { vert -> SCNVector3 in return vert.norm.scnVec }
//        let iArr = [0, 1]
//
//        let sourceVerts = SCNGeometrySource(vertices: vertArr)
//        let sourceNorms = SCNGeometrySource(normals: normArr)
//        let element = SCNGeometryElement(indices: iArr, primitiveType: .line)
//
//        let geo = SCNGeometry(sources: [sourceVerts, sourceNorms], elements: [element])

        let pln = SCNPlane(width: 0.5, height: 2)
        pln.heightSegmentCount = 4
        let cpy = pln.copy() as! SCNGeometry
        print("A", cpy.sources[0])
        print("B", cpy.sources[1])
        print("C", cpy.elements[0])
        let geo = SCNGeometry(sources: [cpy.sources.first!, cpy.sources[1]], elements: [cpy.elements.first!])

        let obj = _3DScnObj(geometry: geo)
        
        return obj
    }
    
    func createSources(from verts: [_3DVert]) -> [SCNGeometrySource] {
        
        struct FloatVert {
            let px, py, pz: Float
            let nx, ny, nz: Float
            let u, v: Float
        }
        let floatVerts = verts.map { vert -> FloatVert in
            return FloatVert(
                px: Float(vert.pos.x),
                py: Float(vert.pos.y),
                pz: Float(vert.pos.z),
                nx: Float(vert.norm.x),
                ny: Float(vert.norm.y),
                nz: Float(vert.norm.z),
                u: Float(vert.uv.u),
                v: Float(vert.uv.v)
            )
        }

        let vertSize = MemoryLayout<FloatVert>.size
        let valSize = MemoryLayout<Float>.size

        let data = Data(bytes: floatVerts, count: floatVerts.count)
        let vertexSource = SCNGeometrySource(data: data, semantic: .vertex, vectorCount: floatVerts.count, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: valSize, dataOffset: 0, dataStride: vertSize)
        let normalSource = SCNGeometrySource(data: data, semantic: .normal, vectorCount: floatVerts.count, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: valSize, dataOffset: valSize * 3, dataStride: vertSize)
        let tcoordSource = SCNGeometrySource(data: data, semantic: .texcoord, vectorCount: floatVerts.count, usesFloatComponents: true, componentsPerVector: 2, bytesPerComponent: valSize, dataOffset: valSize * 6, dataStride: vertSize)
        
        return [vertexSource, normalSource, tcoordSource]

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
