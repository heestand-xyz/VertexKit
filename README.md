<img src="https://github.com/heestand-xyz/VertexKit/blob/main/Assets/Pixels-3D_logo_1k_bg.png" width="128"/>

# VertexKit

a Framework for iOS & macOS<br>
written in Swift & Metal<br>
an extension of [PixelKit](https://github.com/heestand-xyz/pixelkit)<br>

## Particles Example

<img src="https://github.com/heestand-xyz/VertexKit/blob/main/Assets/Images/vertexkit-particle-noise.png?raw=true" width="256"/>

```swift
view.wantsLayer = true
view.layer!.backgroundColor = .black

PixelKit.main.render.bits = ._16

let pres: Resolution = .square(Int(sqrt(1_000_000)))

let noise = NoisePIX(at: pres)
noise.colored = true
noise.octaves = 5
noise.zPosition = .live * 0.1

let particles = UVParticlesPIX(at: .size(view.bounds.size) * 2)
particles.vtxPixIn = noise - 0.5
particles.color = LiveColor(lum: 1.0, a: 0.1)

let finalPix: PIX = particles
finalPix.view.frame = view.bounds
finalPix.view.checker = false
view.addSubview(finalPix.view)
```
