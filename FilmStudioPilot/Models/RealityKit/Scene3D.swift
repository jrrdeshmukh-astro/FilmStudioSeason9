//
//  Scene3D.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import RealityKit
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

struct Scene3D: Identifiable, Codable {
    let id: UUID
    let sceneNumber: Int
    let title: String
    let description: String
    let cameraPosition: CameraPosition
    let entities: [Entity3D]
    let lighting: LightingConfig
    let environment: EnvironmentConfig
    
    init(
        id: UUID = UUID(),
        sceneNumber: Int,
        title: String,
        description: String,
        cameraPosition: CameraPosition,
        entities: [Entity3D] = [],
        lighting: LightingConfig = LightingConfig(),
        environment: EnvironmentConfig = EnvironmentConfig()
    ) {
        self.id = id
        self.sceneNumber = sceneNumber
        self.title = title
        self.description = description
        self.cameraPosition = cameraPosition
        self.entities = entities
        self.lighting = lighting
        self.environment = environment
    }
}

struct CameraPosition: Codable {
    var x: Float
    var y: Float
    var z: Float
    var rotationX: Float
    var rotationY: Float
    var rotationZ: Float
    var fieldOfView: Float
    
    init(
        x: Float = 0,
        y: Float = 1.6, // Eye level
        z: Float = -3,
        rotationX: Float = 0,
        rotationY: Float = 0,
        rotationZ: Float = 0,
        fieldOfView: Float = 60
    ) {
        self.x = x
        self.y = y
        self.z = z
        self.rotationX = rotationX
        self.rotationY = rotationY
        self.rotationZ = rotationZ
        self.fieldOfView = fieldOfView
    }
}

struct Entity3D: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: EntityType
    let position: SIMD3<Float>
    let rotation: SIMD3<Float>
    let scale: SIMD3<Float>
    let material: MaterialConfig?
    let isEmotional: Bool?
    
    init(
        id: UUID = UUID(),
        name: String,
        type: EntityType,
        position: SIMD3<Float> = [0, 0, 0],
        rotation: SIMD3<Float> = [0, 0, 0],
        scale: SIMD3<Float> = [1, 1, 1],
        material: MaterialConfig? = nil,
        isEmotional: Bool? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.position = position
        self.rotation = rotation
        self.scale = scale
        self.material = material
        self.isEmotional = isEmotional
    }
}

enum EntityType: String, Codable {
    case character = "character"
    case prop = "prop"
    case set = "set"
    case light = "light"
    case camera = "camera"
}

struct MaterialConfig: Codable {
    let color: ColorRGB
    let metallic: Float
    let roughness: Float
    let emissive: Bool
    
    init(
        color: ColorRGB = ColorRGB(r: 0.8, g: 0.8, b: 0.8),
        metallic: Float = 0.0,
        roughness: Float = 0.5,
        emissive: Bool = false
    ) {
        self.color = color
        self.metallic = metallic
        self.roughness = roughness
        self.emissive = emissive
    }
}

struct ColorRGB: Codable {
    let r: Float
    let g: Float
    let b: Float
    let a: Float
    
    init(r: Float, g: Float, b: Float, a: Float = 1.0) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    
    #if canImport(UIKit)
    var uiColor: UIColor {
        UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    }
    #endif
    
    #if canImport(AppKit)
    var nsColor: NSColor {
        NSColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    }
    #endif
}

struct LightingConfig: Codable {
    let ambientIntensity: Float
    let directionalLight: DirectionalLight?
    
    init(
        ambientIntensity: Float = 0.3,
        directionalLight: DirectionalLight? = nil
    ) {
        self.ambientIntensity = ambientIntensity
        self.directionalLight = directionalLight
    }
}

struct DirectionalLight: Codable {
    let direction: SIMD3<Float>
    let color: ColorRGB
    let intensity: Float
    
    init(
        direction: SIMD3<Float> = [0, -1, -1],
        color: ColorRGB = ColorRGB(r: 1, g: 1, b: 1),
        intensity: Float = 1.0
    ) {
        self.direction = direction
        self.color = color
        self.intensity = intensity
    }
}

struct EnvironmentConfig: Codable {
    let skybox: String? // Skybox image name
    let backgroundColor: ColorRGB
    let fogEnabled: Bool
    let fogColor: ColorRGB
    let fogDistance: Float
    
    init(
        skybox: String? = nil,
        backgroundColor: ColorRGB = ColorRGB(r: 0.1, g: 0.1, b: 0.1),
        fogEnabled: Bool = false,
        fogColor: ColorRGB = ColorRGB(r: 0.8, g: 0.8, b: 0.9),
        fogDistance: Float = 10.0
    ) {
        self.skybox = skybox
        self.backgroundColor = backgroundColor
        self.fogEnabled = fogEnabled
        self.fogColor = fogColor
        self.fogDistance = fogDistance
    }
}

