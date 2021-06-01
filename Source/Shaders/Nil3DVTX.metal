//
//  Nil3DVTX.metal
//  VertexKitShaders
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

struct VertexOut{
    float4 position [[position]];
    float2 texCoord;
    float4 color;
};

vertex VertexOut nil3DVTX(const device VertexIn* vertices [[ buffer(0) ]],
                          unsigned int vid [[ vertex_id ]]) {
    
    VertexIn vtxIn = vertices[vid];
    float x = vtxIn.position[0];
    float y = vtxIn.position[1];
    float z = vtxIn.position[2];
    
//    World-Space Transformation - Model-World Transformation
    
    


//    Camera-Space Transformation - Model-View Transformation

//    Projective-Perspective Space Transformation - Model-View-Projective transformation
    
    VertexOut vtxOut;
    vtxOut.position = float4(x, y, z, 1);
    vtxOut.texCoord = vtxIn.texCoord;
    vtxOut.color = 1;
    
    return vtxOut;
}
