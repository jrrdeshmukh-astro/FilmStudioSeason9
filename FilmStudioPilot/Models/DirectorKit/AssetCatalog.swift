//
//  AssetCatalog.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import SwiftData

@Model
final class AssetCatalog {
    var id: UUID
    var videoAssets: [VideoAsset]
    var audioAssets: [AudioAsset]
    var imageAssets: [ImageAsset]
    var modelAssets: [Model3DAsset] // RealityKit models
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        videoAssets: [VideoAsset] = [],
        audioAssets: [AudioAsset] = [],
        imageAssets: [ImageAsset] = [],
        modelAssets: [Model3DAsset] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.videoAssets = videoAssets
        self.audioAssets = audioAssets
        self.imageAssets = imageAssets
        self.modelAssets = modelAssets
        self.createdAt = createdAt
    }
}

struct VideoAsset: Codable, Identifiable {
    let id: UUID
    var url: String
    var duration: TimeInterval
    var resolution: CGSize
    var frameRate: Float
    var codec: String
    var metadata: [String: String]?
    
    init(
        id: UUID = UUID(),
        url: String,
        duration: TimeInterval,
        resolution: CGSize,
        frameRate: Float = 30.0,
        codec: String = "H.264",
        metadata: [String: String]? = nil
    ) {
        self.id = id
        self.url = url
        self.duration = duration
        self.resolution = resolution
        self.frameRate = frameRate
        self.codec = codec
        self.metadata = metadata
    }
}

struct AudioAsset: Codable, Identifiable {
    let id: UUID
    var url: String
    var duration: TimeInterval
    var sampleRate: Float
    var channels: Int
    var format: String
    
    init(
        id: UUID = UUID(),
        url: String,
        duration: TimeInterval,
        sampleRate: Float = 44100.0,
        channels: Int = 2,
        format: String = "AAC"
    ) {
        self.id = id
        self.url = url
        self.duration = duration
        self.sampleRate = sampleRate
        self.channels = channels
        self.format = format
    }
}

struct ImageAsset: Codable, Identifiable {
    let id: UUID
    var url: String
    var resolution: CGSize
    var format: String
    
    init(
        id: UUID = UUID(),
        url: String,
        resolution: CGSize,
        format: String = "PNG"
    ) {
        self.id = id
        self.url = url
        self.resolution = resolution
        self.format = format
    }
}

struct Model3DAsset: Codable, Identifiable {
    let id: UUID
    var url: String
    var name: String
    var format: String // "usdz", "reality", etc.
    var boundingBox: BoundingBox?
    
    init(
        id: UUID = UUID(),
        url: String,
        name: String,
        format: String = "usdz",
        boundingBox: BoundingBox? = nil
    ) {
        self.id = id
        self.url = url
        self.name = name
        self.format = format
        self.boundingBox = boundingBox
    }
}

struct BoundingBox: Codable {
    var min: SIMD3<Float>
    var max: SIMD3<Float>
    
    init(min: SIMD3<Float>, max: SIMD3<Float>) {
        self.min = min
        self.max = max
    }
}

