//
//  Scene3DService.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import Foundation
import RealityKit
import simd

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
    
    /// Build RealityKit scene from Scene3D model
    func buildRealityKitScene(from scene3D: Scene3D) -> Entity {
        let rootEntity = Entity()
        
        // Add entities
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
        
        // Configure lighting
        if let directionalLight = scene3D.lighting.directionalLight {
            let lightEntity = DirectionalLight()
            lightEntity.light.color = .init(
                red: directionalLight.color.r,
                green: directionalLight.color.g,
                blue: directionalLight.color.b
            )
            lightEntity.light.intensity = directionalLight.intensity
            lightEntity.look(at: simd_float3(0, 0, 0), from: directionalLight.direction, relativeTo: nil)
            rootEntity.addChild(lightEntity)
        }
        
        return rootEntity
    }
    
    private func createRealityKitEntity(from entity3D: Entity3D) -> Entity {
        switch entity3D.type {
        case .character:
            // Create a simple character representation (box for now)
            let mesh = MeshResource.generateBox(size: 0.5)
            let material = createMaterial(from: entity3D.material)
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            modelEntity.name = entity3D.name
            return modelEntity
            
        case .prop:
            let mesh = MeshResource.generateBox(size: 1.0)
            let material = createMaterial(from: entity3D.material)
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            modelEntity.name = entity3D.name
            return modelEntity
            
        case .set:
            let mesh = MeshResource.generateBox(size: 2.0)
            let material = createMaterial(from: entity3D.material)
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            modelEntity.name = entity3D.name
            return modelEntity
            
        case .light:
            let light = DirectionalLight()
            light.name = entity3D.name
            return light
            
        case .camera:
            let camera = PerspectiveCamera()
            camera.name = entity3D.name
            return camera
        }
    }
    
    private func createMaterial(from config: MaterialConfig?) -> Material {
        let config = config ?? MaterialConfig()
        var material = SimpleMaterial()
        material.color = .init(
            tint: UIColor(
                red: CGFloat(config.color.r),
                green: CGFloat(config.color.g),
                blue: CGFloat(config.color.b),
                alpha: CGFloat(config.color.a)
            )
        )
        material.metallic = config.metallic
        material.roughness = config.roughness
        return material
    }
}

