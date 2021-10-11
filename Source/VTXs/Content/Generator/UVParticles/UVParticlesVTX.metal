//
//  ParticleUV3DVTX.metal
//  VertexKitShaders
//
//  Created by Anton Heestand on 2019-05-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    packed_float3 position;
    packed_float2 texCoord;
};

struct VertexOut {
    float4 position [[position]];
    float pointSize [[point_size]];
    float4 color;
};

struct Uniforms {
    float size;
    float resx;
    float resy;
    float mapSize;
    float mapAlpha;
    float mapAlphaClip;
    float aspect;
};

vertex VertexOut uvParticlesVTX(unsigned int vid [[ vertex_id ]],
                                const device Uniforms& in [[ buffer(1) ]],
                                texture2d<float> inTex [[ texture(0) ]],
                                sampler s [[ sampler(0) ]]) {
    
    int ux = vid % int(in.resx);
    int vy = int(float(vid) / in.resx);
    float u = float(ux) / in.resx;
    float v = float(vy) / in.resy;
    float2 uv = float2(u, v);
    float4 c = inTex.sample(s, uv);
    float x = (c.r / in.aspect) * 2;
    float y = c.g * 2;
    float z = 0.0;

    VertexOut vtxOut;
    vtxOut.position = float4(x, y, z, 1);
    vtxOut.pointSize = in.mapSize > 0 ? in.size * c.b : in.size;
    vtxOut.color = in.mapAlpha > 0 ? float4(1, 1, 1, in.mapAlphaClip ? c.a == 1.0 : c.a) : float4(1, 1, 1, 1);
    
    return vtxOut;
}
