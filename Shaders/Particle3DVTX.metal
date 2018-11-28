//
//  Particle3DVTX.metal
//  Pixels3DShaders
//
//  Created by Hexagons on 2018-09-22.
//  Copyright © 2018 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//#import "random_header.metal"
//#import "noise_header.metal"

struct VertexIn{
    packed_float2 position;
    packed_float2 texCoord;
};

struct VertexOut{
    float4 position [[position]];
    float pointSize [[point_size]];
};

struct Uniforms {
//    float time;
    float size;
//    float aspect;
};

vertex VertexOut particle3DVTX(const device VertexIn* vertices [[ buffer(0) ]],
                               unsigned int vid [[ vertex_id ]],
                               const device Uniforms& in [[ buffer(1) ]]) {
//                               texture2d<float> inTex [[ texture(0) ]],
//                               sampler s [[ sampler(0) ]]) {
    
    // vertices unused
    
    VertexIn vtxIn = vertices[vid];
    float x = vtxIn.position[0];
    float y = vtxIn.position[1];
//    float2 uv = float2(u, v);
//    float4 c = inTex.sample(s, uv);
//
//    float x = (c.r / in.aspect) * 0.001;
//    float y = c.g * 0.001;
    float z = 0.0;//c.b * 0.001;
    
    float p = in.size;//c.a;
    
//    float t = in.time * 4;
//
//    uint w = uint(in.grid_res_w);
//    uint h = uint(in.grid_res_h);
    
    
//    uint x = vid % w;
//    uint y = uint(float(vid) / float(w));
//
//    float u = (float(x) + 0.5) / float(w);
//    float v = (float(y) + 0.5) / float(h);

    

    
//    x += c.r * 0.25;
//    y += c.g * 0.25;
    
    
//    float nx, ny;
//    Loki rnd = Loki(0, x, y);
//    nx = rnd.rand();
//    ny = rnd.rand();
//    nx = octave_noise_3d(7, 0.5, 1.0, x, y, t);
//    ny = octave_noise_3d(7, 0.5, 1.0, x, y, t + 100);
//
//    x += nx - 0.5;// * 0.01;
//    y += ny - 0.5;// * 0.01;
    
//    x += cos(t) * f0.25;
    
    VertexOut vtxOut;
    vtxOut.position = float4(x, y, z, 1);
    vtxOut.pointSize = p;
    
    return vtxOut;
}
