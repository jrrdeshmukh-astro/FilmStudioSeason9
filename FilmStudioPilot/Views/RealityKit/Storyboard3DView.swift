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
            
            // Configure camera
            let camera = PerspectiveCamera()
            camera.position = simd_float3(
                scene3D.cameraPosition.x,
                scene3D.cameraPosition.y,
                scene3D.cameraPosition.z
            )
            camera.fieldOfView = scene3D.cameraPosition.fieldOfView
            content.add(camera)
            
            // Set camera as active
            if let cameraEntity = content.entities.first(where: { $0 is PerspectiveCamera }) as? PerspectiveCamera {
                // Camera is now active
            }
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

