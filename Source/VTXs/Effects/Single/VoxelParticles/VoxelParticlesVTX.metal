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
    float resx;
    float resy;
    float resz;
};

vertex VertexOut voxelParticlesVTX(const device VertexIn* vertices [[ buffer(0) ]],
                                   unsigned int vid [[ vertex_id ]],
                                   const device Uniforms& in [[ buffer(1) ]],
                                   texture3d<float> inTex [[ texture(0) ]],
                                   sampler s [[ sampler(0) ]]) {
    
    int ux = vid % int(in.resx);
    int vjd = int(float(vid) / in.resx);
    int vy = vjd % int(in.resy);
    int wz = int(float(vjd) / in.resy);
    float u = float(ux) / in.resx;
    float v = float(vy) / in.resy;
    float w = float(wz) / in.resz;
    float x = u;
    float y = v;
    float z = w;
    float3 uvw = float3(u, v, w);
    float4 c = inTex.sample(s, uvw);

    VertexOut vtxOut;
    vtxOut.position = float4(x, y, z, 1);
    vtxOut.pointSize = 1.0;
    vtxOut.color = c;
    
    return vtxOut;
}
