//
//  Distort3DVTX.metal
//  Pixels3DShaders
//
//  Created by Hexagons on 2018-09-22.
//  Copyright © 2018 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    packed_float2 position;
    packed_float2 texCoord;
};

struct VertexOut{
    float4 position [[position]];
    float2 texCoord;
};

//constexpr sampler s(coord::pixel,
//                    address::clamp_to_zero,
//                    filter::linear);

vertex VertexOut distort3DVTX(const device VertexIn* vertecies [[ buffer(0) ]],
                              unsigned int vid [[ vertex_id ]],
                              texture2d<float> inTex [[ texture(0) ]],
                              sampler s [[ sampler(0) ]]) {
    
    VertexIn vtxIn = vertecies[vid];
    float x = vtxIn.position[0];
    float y = vtxIn.position[1];

    float u = 0.5;//x / 2 + 0.5;
    float v = 0.5;//y / 2 + 0.5;
    float2 uv = float2(u, v);
    float4 c = inTex.sample(s, uv);
    
    VertexOut vtxOut;
    vtxOut.position = float4(x + (c.r - 0.5), y + (c.g - 0.5), 0, 1);
    vtxOut.texCoord = vtxIn.texCoord;
    
    return vtxOut;
}
