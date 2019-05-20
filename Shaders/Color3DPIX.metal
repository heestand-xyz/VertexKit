//
//  Color3DPIX.metal
//  VertexKit
//
//  Created by Hexagons on 2018-09-22.
//  Copyright © 2018 Hexagons. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexOut{
    float4 position [[position]];
    float2 texCoord;
    float4 color;
};

struct Uniforms{
    float r;
    float g;
    float b;
    float a;
};

fragment float4 color3DPIX(VertexOut out [[stage_in]],
                           const device Uniforms& in [[ buffer(0) ]],
                           sampler s [[ sampler(0) ]]) {
    return float4(in.r * out.color.r,
                  in.g * out.color.g,
                  in.b * out.color.b,
                  in.a * out.color.a);
}

