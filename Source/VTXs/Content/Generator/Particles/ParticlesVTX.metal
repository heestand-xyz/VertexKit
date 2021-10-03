//
//  ParticleUV3DVTX.metal
//  VertexKitShaders
//
//  Created by Anton Heestand on 2019-05-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    packed_float3 position;
    packed_float2 texCoord;
};

struct VertexOut{
    float4 position [[position]];
    float pointSize [[point_size]];
    float4 color;
};

struct Uniforms {
    float size;
};

vertex VertexOut particlesVTX(const device VertexIn* vertices [[ buffer(0) ]],
                              unsigned int vid [[ vertex_id ]],
                              const device Uniforms& in [[ buffer(1) ]],
                              sampler s [[ sampler(0) ]]) {
    
    int index = vid;
    
    float x = vertices[index].position.x * 2;
    float y = vertices[index].position.y * 2;
    float z = 0.0;
    
    float4 color = float4(1, 1, 1, 1);

    VertexOut vtxOut;
    vtxOut.position = float4(x, y, z, 1);
    vtxOut.pointSize = in.size;
    vtxOut.color = color;
    
    return vtxOut;
}
