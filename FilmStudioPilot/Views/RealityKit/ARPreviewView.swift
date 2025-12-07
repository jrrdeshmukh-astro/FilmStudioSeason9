//
//  ARPreviewView.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import SwiftUI
import RealityKit
import ARKit

struct ARPreviewView: View {
    let scene3D: Scene3D
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            ARViewContainer(scene3D: scene3D)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    let scene3D: Scene3D
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configure AR session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config)
        
        // Load scene
        let service = Scene3DService()
        let scene = service.buildRealityKitScene(from: scene3D)
        
        // Add scene to AR view
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: [0.5, 0.5]))
        anchor.position = [0, 0, -1] // 1 meter in front
        anchor.addChild(scene)
        arView.scene.addAnchor(anchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update AR view if needed
    }
}

#Preview {
    ARPreviewView(
        scene3D: Scene3D(
            sceneNumber: 1,
            title: "Test",
            description: "Test scene",
            cameraPosition: CameraPosition()
        )
    )
}

