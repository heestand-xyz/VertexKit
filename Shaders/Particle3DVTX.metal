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
#import "noise_header.metal"

struct VertexIn{
    packed_float2 position;
    packed_float2 texCoord;
};

struct VertexOut{
    float4 position [[position]];
    float pointSize [[point_size]];
};

struct Uniforms {
    float time;
};

vertex VertexOut particle3DVTX(const device VertexIn* vertecies [[ buffer(0) ]],
                               unsigned int vid [[ vertex_id ]],
                               const device Uniforms& in [[ buffer(1) ]]) {
    
    VertexIn vtxIn = vertecies[vid];
    float x = vtxIn.position[0];
    float y = vtxIn.position[1];
    
    float t = in.time / 10;
                                   
    float nx, ny;
//    Loki rnd = Loki(0, x, y);
//    nx = rnd.rand();
//    ny = rnd.rand();
    nx = octave_noise_3d(7, 0.5, 1.0, x, y, t);
    ny = octave_noise_3d(7, 0.5, 1.0, x, y, t + 100);
    
    x += nx - 0.5;// * 0.01;
    y += ny - 0.5;// * 0.01;
    
    VertexOut vtxOut;
    vtxOut.position = float4(x, y, 0, 1);
    vtxOut.pointSize = 1.0;
    
    return vtxOut;
}
