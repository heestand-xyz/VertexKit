//
//  Created by Anton Heestand on 2022-01-15.
//

import Foundation
import CoreGraphics
import RenderKit
import PixelKit
import Resolution
import PixelColor

public struct ParticlesPixelModel: PixelGeneratorModel {
    
    // MARK: Global
    
    public var id: UUID = UUID()
    public var name: String = "Particles"
    public var typeName: String = "vtx-pix-content-generator-particles"
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
    public var lifeTime: CGFloat = 1.0
    public var emitCount: Int = 1
    public var emitPosition: CGPoint = .zero
    public var emitSize: CGSize = .zero
    public var direction: CGPoint = .zero
    public var randomDirection: CGFloat = 1.0
    public var velocity: CGFloat = 0.005
    public var randomVelocity: CGFloat = 0.0
    public var particleSize: CGFloat = 0.1
}

extension ParticlesPixelModel {
    
    enum LocalCodingKeys: String, CodingKey, CaseIterable {
        case clearBackgroundColor
        case lifeTime
        case emitCount
        case emitPosition
        case emitSize
        case direction
        case randomDirection
        case velocity
        case randomVelocity
        case particleSize
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
                case .lifeTime:
                    guard let live = liveWrap as? LiveFloat else { continue }
                    lifeTime = live.wrappedValue
                case .emitCount:
                    guard let live = liveWrap as? LiveInt else { continue }
                    emitCount = live.wrappedValue
                case .emitPosition:
                    guard let live = liveWrap as? LivePoint else { continue }
                    emitPosition = live.wrappedValue
                case .emitSize:
                    guard let live = liveWrap as? LiveSize else { continue }
                    emitSize = live.wrappedValue
                case .direction:
                    guard let live = liveWrap as? LivePoint else { continue }
                    direction = live.wrappedValue
                case .randomDirection:
                    guard let live = liveWrap as? LiveFloat else { continue }
                    randomDirection = live.wrappedValue
                case .velocity:
                    guard let live = liveWrap as? LiveFloat else { continue }
                    velocity = live.wrappedValue
                case .randomVelocity:
                    guard let live = liveWrap as? LiveFloat else { continue }
                    randomVelocity = live.wrappedValue
                case .particleSize:
                    guard let live = liveWrap as? LiveFloat else { continue }
                    particleSize = live.wrappedValue
                }
            }
            return
        }
        
        clearBackgroundColor = try container.decode(PixelColor.self, forKey: .clearBackgroundColor)
        lifeTime = try container.decode(CGFloat.self, forKey: .lifeTime)
        emitCount = try container.decode(Int.self, forKey: .emitCount)
        emitPosition = try container.decode(CGPoint.self, forKey: .emitPosition)
        emitSize = try container.decode(CGSize.self, forKey: .emitSize)
        direction = try container.decode(CGPoint.self, forKey: .direction)
        randomDirection = try container.decode(CGFloat.self, forKey: .randomDirection)
        velocity = try container.decode(CGFloat.self, forKey: .velocity)
        randomVelocity = try container.decode(CGFloat.self, forKey: .randomVelocity)
        particleSize = try container.decode(CGFloat.self, forKey: .particleSize)
    }
}

extension ParticlesPixelModel {
    
    public func isEqual(to nodeModel: NodeModel) -> Bool {
        guard let pixelModel = nodeModel as? Self else { return false }
        guard isPixelGeneratorEqual(to: pixelModel) else { return false }
        guard clearBackgroundColor == pixelModel.clearBackgroundColor else { return false }
        guard lifeTime == pixelModel.lifeTime else { return false }
        guard emitCount == pixelModel.emitCount else { return false }
        guard emitPosition == pixelModel.emitPosition else { return false }
        guard emitSize == pixelModel.emitSize else { return false }
        guard direction == pixelModel.direction else { return false }
        guard randomDirection == pixelModel.randomDirection else { return false }
        guard velocity == pixelModel.velocity else { return false }
        guard randomVelocity == pixelModel.randomVelocity else { return false }
        guard particleSize == pixelModel.particleSize else { return false }
        return true
    }
}
