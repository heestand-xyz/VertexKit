//
//  Pixel3DProtocol.swift
//  Pixels3D
//
//  Created by Hexagons on 2019-01-21.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Foundation
import simd

public protocol PixelsCustom3DRenderDelegate {
    func update(cameraTransform: simd_float4x4, projectionMatrix: simd_float4x4)
}
