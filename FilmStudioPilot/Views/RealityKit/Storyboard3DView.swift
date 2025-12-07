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
    
    var body: some View {
        RealityView { content in
            let service = Scene3DService()
            let scene = service.buildRealityKitScene(from: scene3D)
            content.add(scene)
        }
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

