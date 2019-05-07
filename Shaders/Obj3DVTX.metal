//
//  Nil3DVTX.metal
//  Pixels3DShaders
//
//  Created by Hexagons on 2018-09-22.
//  Copyright © 2018 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    packed_float3 position;
    packed_float2 texCoord;
};

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
    float4 color;
};

struct Matrices {
    float4x4 camera;
    float4x4 projection;
};

vertex VertexOut obj3DVTX(const device VertexIn* vertices [[ buffer(0) ]],
                          const device Matrices& matrices [[ buffer(1) ]],
                          unsigned int vid [[ vertex_id ]]) {
    
    VertexIn vtxIn = vertices[vid];
    float x = vtxIn.position[0];
    float y = vtxIn.position[1];
    float z = vtxIn.position[2];
    
    float4 relPos = float4(x, y, z, 1);// * matrices.camera * matrices.projection;

    VertexOut vtxOut;
    vtxOut.position = relPos;
    vtxOut.texCoord = vtxIn.texCoord;
    vtxOut.color = 1;
    
    return vtxOut;
}
