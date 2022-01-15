//
//  Created by Anton Heestand on 2022-01-15.
//

import Foundation
import CoreGraphics
import RenderKit
import PixelKit
import Resolution
import PixelColor

public struct UVParticlesPixelModel: PixelGeneratorModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "UV Particles"
    public var typeName: String = "vtx-pix-content-generator-uv-particles"
    public var bypass: Bool = false
    
    public var outputNodeReferences: [NodeReference] = []

    public var viewInterpolation: ViewInterpolation = .linear
    public var interpolation: PixelInterpolation = .linear
    public var extend: ExtendMode = .zero
    
    public var premultiply: Bool = true
    public var resolution: Resolution = .auto

    public var backgroundColor: PixelColor = .black
    public var color: PixelColor = .white
    
    // MARK: Local
    
    public var clearBackgroundColor: PixelColor = .black
    public var particleSize: CGFloat = 0.1
    public var hasSize: Bool = false
    public var hasAlpha: Bool = false
    public var hasAlphaClip: Bool = false
}

extension UVParticlesPixelModel {
    
    enum LocalCodingKeys: String, CodingKey, CaseIterable {
        case clearBackgroundColor
        case particleSize
        case hasSize
        case hasAlpha
        case hasAlphaClip
    }
    
    public init(from decoder: Decoder) throws {
        
        self = try PixelGeneratorModelDecoder.decode(from: decoder, model: self) as! Self
        
        let container = try decoder.container(keyedBy: LocalCodingKeys.self)
        
        if try PixelModelDecoder.isLiveListCodable(decoder: decoder) {
            let liveList: [LiveWrap] = try PixelModelDecoder.liveListDecode(from: decoder)
            for codingKey in LocalCodingKeys.allCases {
                guard let liveWrap: LiveWrap = liveList.first(where: { $0.typeName == codingKey.rawValue }) else { continue }
                
                switch codingKey {
                case .clearBackgroundColor:
                    guard let live = liveWrap as? LiveColor else { continue }
                    clearBackgroundColor = live.wrappedValue
                case .particleSize:
                    guard let live = liveWrap as? LiveFloat else { continue }
                    particleSize = live.wrappedValue
                case .hasSize:
                    guard let live = liveWrap as? LiveBool else { continue }
                    hasSize = live.wrappedValue
                case .hasAlpha:
                    guard let live = liveWrap as? LiveBool else { continue }
                    hasAlpha = live.wrappedValue
                case .hasAlphaClip:
                    guard let live = liveWrap as? LiveBool else { continue }
                    hasAlphaClip = live.wrappedValue
                }
            }
            return
        }
        
        clearBackgroundColor = try container.decode(PixelColor.self, forKey: .clearBackgroundColor)
        particleSize = try container.decode(CGFloat.self, forKey: .particleSize)
        hasSize = try container.decode(Bool.self, forKey: .hasSize)
        hasAlpha = try container.decode(Bool.self, forKey: .hasAlpha)
        hasAlphaClip = try container.decode(Bool.self, forKey: .hasAlphaClip)
    }
}
