//
//  Scene3DService.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import RealityKit
import simd
import Combine
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

@MainActor
class Scene3DService: ObservableObject {
    
    /// Generate 3D scenes from story beats
    func generateScenes(from storyIdea: StoryIdea) -> [Scene3D] {
        var scenes: [Scene3D] = []
        
        for (index, beat) in storyIdea.sceneBeats.enumerated() {
            let scene = createScene3D(
                sceneNumber: beat.sceneNumber,
                title: "Scene \(beat.sceneNumber)",
                description: beat.beatDescription,
                objective: beat.objective,
                obstacle: beat.obstacle,
                isEmotionalMoment: beat.emotionalMoment
            )
            scenes.append(scene)
        }
        
        return scenes
    }
    
    private func createScene3D(
        sceneNumber: Int,
        title: String,
        description: String,
        objective: String,
        obstacle: String,
        isEmotionalMoment: Bool
    ) -> Scene3D {
        // Generate camera position based on scene type
        let cameraPosition = generateCameraPosition(
            for: objective,
            isEmotionalMoment: isEmotionalMoment
        )
        
        // Generate entities based on scene description
        let entities = generateEntities(
            for: description,
            objective: objective,
            obstacle: obstacle
        )
        
        // Generate lighting based on emotional moment
        let lighting = generateLighting(isEmotionalMoment: isEmotionalMoment)
        
        // Generate environment
        let environment = generateEnvironment(for: objective)
        
        return Scene3D(
            sceneNumber: sceneNumber,
            title: title,
            description: description,
            cameraPosition: cameraPosition,
            entities: entities,
            lighting: lighting,
            environment: environment
        )
    }
    
    private func generateCameraPosition(
        for objective: String,
        isEmotionalMoment: Bool
    ) -> CameraPosition {
        if isEmotionalMoment {
            // Close-up for emotional moments
            return CameraPosition(
                x: 0,
                y: 1.6,
                z: -1.5, // Closer
                fieldOfView: 50 // Narrower FOV for intimacy
            )
        } else if objective.lowercased().contains("establish") {
            // Wide shot for establishing
            return CameraPosition(
                x: 0,
                y: 2.0, // Higher
                z: -5.0, // Further back
                fieldOfView: 75 // Wider FOV
            )
        } else {
            // Medium shot default
            return CameraPosition(
                x: 0,
                y: 1.6,
                z: -3.0,
                fieldOfView: 60
            )
        }
    }
    
    private func generateEntities(
        for description: String,
        objective: String,
        obstacle: String
    ) -> [Entity3D] {
        var entities: [Entity3D] = []
        
        // Add characters based on objective
        if objective.lowercased().contains("protect") || objective.lowercased().contains("save") {
            entities.append(Entity3D(
                name: "Protagonist",
                type: .character,
                position: [0, 0, 0],
                material: MaterialConfig(
                    color: ColorRGB(r: 0.9, g: 0.8, b: 0.7),
                    metallic: 0.0,
                    roughness: 0.6
                )
            ))
        }
        
        // Add props based on description keywords
        if description.lowercased().contains("table") {
            entities.append(Entity3D(
                name: "Table",
                type: .prop,
                position: [0, 0.5, 0],
                scale: [2, 0.1, 1],
                material: MaterialConfig(
                    color: ColorRGB(r: 0.6, g: 0.4, b: 0.2),
                    metallic: 0.0,
                    roughness: 0.8
                )
            ))
        }
        
        if description.lowercased().contains("door") {
            entities.append(Entity3D(
                name: "Door",
                type: .set,
                position: [0, 1, -2],
                scale: [1, 2, 0.1],
                material: MaterialConfig(
                    color: ColorRGB(r: 0.5, g: 0.3, b: 0.2),
                    metallic: 0.0,
                    roughness: 0.7
                )
            ))
        }
        
        // Add lighting entity
        entities.append(Entity3D(
            name: "Main Light",
            type: .light,
            position: [2, 3, 2],
            material: nil
        ))
        
        return entities
    }
    
    private func generateLighting(isEmotionalMoment: Bool) -> LightingConfig {
        if isEmotionalMoment {
            // Softer, warmer lighting for emotional moments
            return LightingConfig(
                ambientIntensity: 0.4,
                directionalLight: DirectionalLight(
                    direction: [0.3, -0.8, -0.5],
                    color: ColorRGB(r: 1.0, g: 0.95, b: 0.9), // Warm
                    intensity: 0.8
                )
            )
        } else {
            // Standard lighting
            return LightingConfig(
                ambientIntensity: 0.3,
                directionalLight: DirectionalLight(
                    direction: [0, -1, -1],
                    color: ColorRGB(r: 1, g: 1, b: 1),
                    intensity: 1.0
                )
            )
        }
    }
    
    private func generateEnvironment(for objective: String) -> EnvironmentConfig {
        if objective.lowercased().contains("outdoor") || objective.lowercased().contains("outside") {
            return EnvironmentConfig(
                skybox: "skybox_day",
                backgroundColor: ColorRGB(r: 0.5, g: 0.7, b: 1.0) // Sky blue
            )
        } else {
            return EnvironmentConfig(
                backgroundColor: ColorRGB(r: 0.1, g: 0.1, b: 0.15) // Dark interior
            )
        }
    }
    
    /// Build RealityKit scene from Scene3D model with stunning visuals
    func buildRealityKitScene(from scene3D: Scene3D) -> Entity {
        let rootEntity = Entity()
        rootEntity.name = "Scene_\(scene3D.sceneNumber)"
        
        // Add environment lighting first
        configureEnvironmentLighting(rootEntity: rootEntity, lighting: scene3D.lighting)
        
        // Add entities with enhanced visuals
        for entity3D in scene3D.entities {
            let entity = createRealityKitEntity(from: entity3D)
            entity.position = entity3D.position
            
            // Convert Euler angles to quaternion
            let rotationX = simd_quatf(angle: entity3D.rotation.x, axis: [1, 0, 0])
            let rotationY = simd_quatf(angle: entity3D.rotation.y, axis: [0, 1, 0])
            let rotationZ = simd_quatf(angle: entity3D.rotation.z, axis: [0, 0, 1])
            entity.orientation = rotationZ * rotationY * rotationX
            entity.scale = entity3D.scale
            
            rootEntity.addChild(entity)
        }
        
        // Add atmospheric effects
        addAtmosphericEffects(to: rootEntity, scene3D: scene3D)
        
        return rootEntity
    }
    
    /// Configure advanced environment lighting
    private func configureEnvironmentLighting(rootEntity: Entity, lighting: LightingConfig) {
        // Main directional light
        if let directionalLight = lighting.directionalLight {
            let lightEntity = Entity()
            #if canImport(UIKit)
            var lightComponent = DirectionalLightComponent(
                color: UIColor(
                    red: CGFloat(directionalLight.color.r),
                    green: CGFloat(directionalLight.color.g),
                    blue: CGFloat(directionalLight.color.b),
                    alpha: 1.0
                ),
                intensity: directionalLight.intensity
            )
            // Note: Shadow configuration may need to be set via environment or lighting setup
            lightEntity.components.set(lightComponent)
            #else
            var lightComponent = DirectionalLightComponent(
                color: NSColor(
                    red: CGFloat(directionalLight.color.r),
                    green: CGFloat(directionalLight.color.g),
                    blue: CGFloat(directionalLight.color.b),
                    alpha: 1.0
                ),
                intensity: directionalLight.intensity
            )
            // Note: Shadow configuration may need to be set via environment or lighting setup
            lightEntity.components.set(lightComponent)
            #endif
            lightEntity.position = simd_float3(
                directionalLight.direction.x * 5,
                directionalLight.direction.y * 5,
                directionalLight.direction.z * 5
            )
            lightEntity.look(at: simd_float3(0, 0, 0), from: lightEntity.position, relativeTo: nil)
            rootEntity.addChild(lightEntity)
        }
        
        // Add ambient light for fill
        let ambientLight = Entity()
        #if canImport(UIKit)
        ambientLight.components.set(DirectionalLightComponent(
            color: UIColor(white: 1.0, alpha: 1.0),
            intensity: lighting.ambientIntensity
        ))
        #else
        ambientLight.components.set(DirectionalLightComponent(
            color: NSColor(white: 1.0, alpha: 1.0),
            intensity: lighting.ambientIntensity
        ))
        #endif
        ambientLight.position = simd_float3(0, 5, 0)
        ambientLight.look(at: simd_float3(0, 0, 0), from: ambientLight.position, relativeTo: nil)
        rootEntity.addChild(ambientLight)
        
        // Add rim light for dramatic effect
        let rimLight = Entity()
        #if canImport(UIKit)
        rimLight.components.set(DirectionalLightComponent(
            color: UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0),
            intensity: 0.3
        ))
        #else
        rimLight.components.set(DirectionalLightComponent(
            color: NSColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0),
            intensity: 0.3
        ))
        #endif
        rimLight.position = simd_float3(-3, 2, 3)
        rimLight.look(at: simd_float3(0, 0, 0), from: rimLight.position, relativeTo: nil)
        rootEntity.addChild(rimLight)
    }
    
    /// Add atmospheric effects for stunning visuals
    private func addAtmosphericEffects(to rootEntity: Entity, scene3D: Scene3D) {
        // Add fog for depth
        if scene3D.environment.fogEnabled {
            // Fog is handled by RealityView environment
        }
        
        // Add post-processing effects via environment
        // These are configured in RealityView
    }
    
    private func createRealityKitEntity(from entity3D: Entity3D) -> Entity {
        switch entity3D.type {
        case .character:
            // Create stunning character with advanced materials
            let mesh = createCharacterMesh()
            let material = createAdvancedMaterial(
                color: entity3D.material?.color ?? ColorRGB(r: 0.9, g: 0.8, b: 0.7),
                materialType: .skin,
                isEmotional: entity3D.isEmotional ?? false
            )
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            modelEntity.name = entity3D.name
            
            // Add visual components for better rendering
            addVisualComponents(to: modelEntity, entityType: .character)
            
            return modelEntity
            
        case .prop:
            // Create props with appropriate materials
            let mesh = createPropMesh(for: entity3D.name)
            let materialType: MaterialType = determineMaterialType(for: entity3D.name)
            let material = createAdvancedMaterial(
                color: entity3D.material?.color ?? ColorRGB(r: 0.6, g: 0.4, b: 0.2),
                materialType: materialType
            )
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            modelEntity.name = entity3D.name
            
            addVisualComponents(to: modelEntity, entityType: .prop)
            
            return modelEntity
            
        case .set:
            // Create set pieces with environment materials
            let mesh = createSetMesh(for: entity3D.name)
            let materialType: MaterialType = determineMaterialType(for: entity3D.name)
            let material = createAdvancedMaterial(
                color: entity3D.material?.color ?? ColorRGB(r: 0.5, g: 0.3, b: 0.2),
                materialType: materialType
            )
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            modelEntity.name = entity3D.name
            
            addVisualComponents(to: modelEntity, entityType: .set)
            
            return modelEntity
            
        case .light:
            let lightEntity = Entity()
            lightEntity.name = entity3D.name
            #if canImport(UIKit)
            lightEntity.components.set(DirectionalLightComponent(
                color: UIColor(white: 1.0, alpha: 1.0),
                intensity: 1.0
            ))
            #else
            lightEntity.components.set(DirectionalLightComponent(
                color: NSColor(white: 1.0, alpha: 1.0),
                intensity: 1.0
            ))
            #endif
            lightEntity.position = entity3D.position
            return lightEntity
            
        case .camera:
            let camera = PerspectiveCamera()
            camera.name = entity3D.name
            return camera
        }
    }
    
    /// Create sophisticated character mesh
    private func createCharacterMesh() -> MeshResource {
        // Use sphere for more organic character shape
        return MeshResource.generateSphere(radius: 0.3)
    }
    
    /// Create prop mesh based on prop name
    private func createPropMesh(for name: String) -> MeshResource {
        let lowercased = name.lowercased()
        
        if lowercased.contains("table") {
            return MeshResource.generateBox(width: 1.5, height: 0.1, depth: 0.8)
        } else if lowercased.contains("chair") {
            return MeshResource.generateBox(width: 0.5, height: 1.0, depth: 0.5)
        } else if lowercased.contains("lamp") {
            return MeshResource.generateCylinder(height: 1.0, radius: 0.05)
        } else {
            return MeshResource.generateBox(size: 0.5)
        }
    }
    
    /// Create set mesh based on set name
    private func createSetMesh(for name: String) -> MeshResource {
        let lowercased = name.lowercased()
        
        if lowercased.contains("door") {
            return MeshResource.generateBox(width: 0.8, height: 2.0, depth: 0.1)
        } else if lowercased.contains("wall") {
            return MeshResource.generateBox(width: 5.0, height: 3.0, depth: 0.2)
        } else if lowercased.contains("floor") {
            return MeshResource.generateBox(width: 5.0, height: 0.1, depth: 5.0)
        } else {
            return MeshResource.generateBox(size: 2.0)
        }
    }
    
    /// Determine material type based on entity name
    private func determineMaterialType(for name: String) -> MaterialType {
        let lowercased = name.lowercased()
        
        if lowercased.contains("metal") || lowercased.contains("steel") {
            return .metallic
        } else if lowercased.contains("glass") || lowercased.contains("window") {
            return .glass
        } else if lowercased.contains("wood") || lowercased.contains("table") {
            return .wood
        } else if lowercased.contains("fabric") || lowercased.contains("cloth") {
            return .fabric
        } else if lowercased.contains("light") || lowercased.contains("lamp") {
            return .emissive
        } else {
            return .wood
        }
    }
    
    /// Add visual components for enhanced rendering
    private func addVisualComponents(to entity: ModelEntity, entityType: EntityType) {
        // Note: Shadows are handled by DirectionalLightComponent.shadow property
        // No separate ShadowComponent exists in RealityKit
        
        // Add collision component for interaction
        entity.components.set(CollisionComponent(shapes: [.generateBox(size: entity.scale)]))
        
        // Add physics for dynamic scenes
        if entityType == .prop {
            entity.components.set(PhysicsBodyComponent(
                massProperties: .default,
                material: .default,
                mode: .static
            ))
        }
        
        // Note: OcclusionComponent doesn't exist in RealityKit
        // Depth and occlusion are handled automatically by the rendering engine
    }
    
    /// Create stunning materials using MaterialBuilder API
    private func createMaterial(from config: MaterialConfig?) -> Material {
        let config = config ?? MaterialConfig()
        
        // Use MaterialBuilder for advanced materials
        var material = PhysicallyBasedMaterial()
        
        // Base color - baseColor is already MaterialColorParameter type
        #if canImport(UIKit)
        material.baseColor = .init(
            tint: UIColor(
                red: CGFloat(config.color.r),
                green: CGFloat(config.color.g),
                blue: CGFloat(config.color.b),
                alpha: CGFloat(config.color.a)
            ),
            texture: nil
        )
        #else
        material.baseColor = .init(
            tint: NSColor(
                red: CGFloat(config.color.r),
                green: CGFloat(config.color.g),
                blue: CGFloat(config.color.b),
                alpha: CGFloat(config.color.a)
            ),
            texture: nil
        )
        #endif
        
        // Metallic and roughness - parameter order: scale before texture
        material.metallic = PhysicallyBasedMaterial.Metallic(
            scale: Float(config.metallic),
            texture: nil
        )
        material.roughness = PhysicallyBasedMaterial.Roughness(
            scale: Float(config.roughness),
            texture: nil
        )
        
        // Add specular for more realistic reflections
        // Note: Specular may not be directly settable in this way, using baseColor properties instead
        
        // Add clearcoat for glossy surfaces
        if config.metallic > 0.5 {
            material.clearcoat = PhysicallyBasedMaterial.Clearcoat(0.3)
        }
        
        // Add emissive for glowing materials
        if config.emissive {
            #if canImport(UIKit)
            material.emissiveColor = MaterialColorParameter(
                color: UIColor(
                    red: CGFloat(config.color.r * 0.5),
                    green: CGFloat(config.color.g * 0.5),
                    blue: CGFloat(config.color.b * 0.5),
                    alpha: 1.0
                )
            )
            #else
            material.emissiveColor = MaterialColorParameter(
                color: NSColor(
                    red: CGFloat(config.color.r * 0.5),
                    green: CGFloat(config.color.g * 0.5),
                    blue: CGFloat(config.color.b * 0.5),
                    alpha: 1.0
                )
            )
            #endif
        }
        
        return material
    }
    
    /// Create advanced material with visual components
    private func createAdvancedMaterial(
        color: ColorRGB,
        materialType: MaterialType,
        isEmotional: Bool = false
    ) -> Material {
        var material = PhysicallyBasedMaterial()
        
        switch materialType {
        case .metallic:
            #if canImport(UIKit)
            material.baseColor = .init(
                tint: UIColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 1.0
                ),
                texture: nil
            )
            #else
            material.baseColor = .init(
                tint: NSColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 1.0
                ),
                texture: nil
            )
            #endif
            material.metallic = PhysicallyBasedMaterial.Metallic(
                scale: 0.9,
                texture: nil
            )
            material.roughness = PhysicallyBasedMaterial.Roughness(
                scale: 0.1,
                texture: nil
            )
            material.clearcoat = PhysicallyBasedMaterial.Clearcoat(0.5)
            
        case .fabric:
            #if canImport(UIKit)
            material.baseColor = .init(
                tint: UIColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 1.0
                ),
                texture: nil
            )
            #else
            material.baseColor = .init(
                tint: NSColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 1.0
                ),
                texture: nil
            )
            #endif
            material.metallic = PhysicallyBasedMaterial.Metallic(
                scale: 0.0,
                texture: nil
            )
            material.roughness = PhysicallyBasedMaterial.Roughness(
                scale: 0.8,
                texture: nil
            )
            // Note: Sheen is not available in PhysicallyBasedMaterial, using roughness instead
            
        case .glass:
            #if canImport(UIKit)
            material.baseColor = .init(
                tint: UIColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 0.3
                ),
                texture: nil
            )
            #else
            material.baseColor = .init(
                tint: NSColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 0.3
                ),
                texture: nil
            )
            #endif
            material.metallic = PhysicallyBasedMaterial.Metallic(
                scale: 0.0,
                texture: nil
            )
            material.roughness = PhysicallyBasedMaterial.Roughness(
                scale: 0.0,
                texture: nil
            )
            // Note: Transmission is not a direct property, using low roughness and alpha for transparency
            
        case .skin:
            #if canImport(UIKit)
            material.baseColor = .init(
                tint: UIColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 1.0
                ),
                texture: nil
            )
            #else
            material.baseColor = .init(
                tint: NSColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 1.0
                ),
                texture: nil
            )
            #endif
            material.metallic = PhysicallyBasedMaterial.Metallic(
                scale: 0.0,
                texture: nil
            )
            material.roughness = PhysicallyBasedMaterial.Roughness(
                scale: 0.6,
                texture: nil
            )
            // Note: Subsurface scattering is not directly available, using appropriate roughness
            
        case .wood:
            #if canImport(UIKit)
            material.baseColor = .init(
                tint: UIColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 1.0
                ),
                texture: nil
            )
            #else
            material.baseColor = .init(
                tint: NSColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 1.0
                ),
                texture: nil
            )
            #endif
            material.metallic = PhysicallyBasedMaterial.Metallic(
                scale: 0.0,
                texture: nil
            )
            material.roughness = PhysicallyBasedMaterial.Roughness(
                scale: 0.7,
                texture: nil
            )
            
        case .emissive:
            #if canImport(UIKit)
            material.baseColor = .init(
                tint: UIColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 1.0
                ),
                texture: nil
            )
            material.emissiveColor = MaterialColorParameter(
                color: UIColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 1.0
                )
            )
            #else
            material.baseColor = .init(
                tint: NSColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 1.0
                ),
                texture: nil
            )
            material.emissiveColor = MaterialColorParameter(
                color: NSColor(
                    red: CGFloat(color.r),
                    green: CGFloat(color.g),
                    blue: CGFloat(color.b),
                    alpha: 1.0
                )
            )
            #endif
            material.metallic = PhysicallyBasedMaterial.Metallic(
                scale: 0.0,
                texture: nil
            )
            material.roughness = PhysicallyBasedMaterial.Roughness(
                scale: 0.5,
                texture: nil
            )
        }
        
        // Add emotional glow effect
        if isEmotional {
            #if canImport(UIKit)
            material.emissiveColor = MaterialColorParameter(
                color: UIColor(
                    red: CGFloat(color.r * 0.3),
                    green: CGFloat(color.g * 0.3),
                    blue: CGFloat(color.b * 0.3),
                    alpha: 1.0
                )
            )
            #else
            material.emissiveColor = MaterialColorParameter(
                color: NSColor(
                    red: CGFloat(color.r * 0.3),
                    green: CGFloat(color.g * 0.3),
                    blue: CGFloat(color.b * 0.3),
                    alpha: 1.0
                )
            )
            #endif
        }
        
        return material
    }
    
    enum MaterialType {
        case metallic
        case fabric
        case glass
        case skin
        case wood
        case emissive
    }
}

