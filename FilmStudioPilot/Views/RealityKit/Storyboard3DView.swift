//
//  Storyboard3DView.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import SwiftUI
import RealityKit

struct Storyboard3DView: View {
    let scene3D: Scene3D
    @State private var cameraEntity: PerspectiveCamera?
    
    var body: some View {
        RealityView { content in
            let service = Scene3DService()
            let scene = service.buildRealityKitScene(from: scene3D)
            content.add(scene)
            
            // Configure camera using PerspectiveCamera
            let cameraEntity = PerspectiveCamera()
            
            // Calculate camera position with field of view consideration
            // Wider FOV = camera can be closer, Narrower FOV = camera should be further
            let fovMultiplier = 60.0 / scene3D.cameraPosition.fieldOfView // Normalize to 60 degrees
            let adjustedZ = scene3D.cameraPosition.z * Float(fovMultiplier)
            
            cameraEntity.position = simd_float3(
                scene3D.cameraPosition.x,
                scene3D.cameraPosition.y,
                adjustedZ
            )
            
            // Apply rotation if specified
            if scene3D.cameraPosition.rotationX != 0 || 
               scene3D.cameraPosition.rotationY != 0 || 
               scene3D.cameraPosition.rotationZ != 0 {
                let rotationX = simd_quatf(angle: scene3D.cameraPosition.rotationX, axis: [1, 0, 0])
                let rotationY = simd_quatf(angle: scene3D.cameraPosition.rotationY, axis: [0, 1, 0])
                let rotationZ = simd_quatf(angle: scene3D.cameraPosition.rotationZ, axis: [0, 0, 1])
                cameraEntity.orientation = rotationZ * rotationY * rotationX
            }
            
            // Note: RealityKit PerspectiveCamera uses default field of view
            // The fieldOfView value in CameraPosition is used for scene planning
            // and camera distance adjustment to simulate different FOVs
            
            content.add(cameraEntity)
        } update: { content in
            // Update scene if needed
        }
        .environment(\.colorScheme, .dark) // Better for 3D viewing
    }
}

#Preview {
    Storyboard3DView(
        scene3D: Scene3D(
            sceneNumber: 1,
            title: "Test Scene",
            description: "A test scene",
            cameraPosition: CameraPosition()
        )
    )
}

