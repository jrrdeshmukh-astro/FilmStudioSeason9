//
//  Storyboard3DListView.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import SwiftUI

struct Storyboard3DListView: View {
    let scenes: [Scene3D]
    @State private var selectedScene: Scene3D?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(scenes) { scene in
                    NavigationLink {
                        Storyboard3DDetailView(scene3D: scene)
                    } label: {
                        Storyboard3DCell(scene3D: scene)
                    }
                }
            }
            .navigationTitle("3D Storyboard")
        }
    }
}

struct Storyboard3DCell: View {
    let scene3D: Scene3D
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Scene \(scene3D.sceneNumber)")
                    .font(.headline)
                
                Text(scene3D.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(scene3D.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "cube.transparent")
                .font(.title2)
                .foregroundStyle(.blue)
        }
        .padding(.vertical, 4)
    }
}

struct Storyboard3DDetailView: View {
    let scene3D: Scene3D
    @State private var showAR = false
    
    var body: some View {
        VStack(spacing: 20) {
            Storyboard3DView(scene3D: scene3D)
                .frame(height: 400)
                .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Scene \(scene3D.sceneNumber): \(scene3D.title)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(scene3D.description)
                    .font(.body)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Camera Position")
                        .font(.headline)
                    Text("X: \(scene3D.cameraPosition.x, specifier: "%.1f"), Y: \(scene3D.cameraPosition.y, specifier: "%.1f"), Z: \(scene3D.cameraPosition.z, specifier: "%.1f")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Entities")
                        .font(.headline)
                    ForEach(scene3D.entities) { entity in
                        Text("• \(entity.name) (\(entity.type.rawValue))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            
            Button {
                showAR = true
            } label: {
                HStack {
                    Image(systemName: "arkit")
                    Text("View in AR")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showAR) {
            ARPreviewView(scene3D: scene3D)
        }
    }
}

#Preview {
    NavigationStack {
        Storyboard3DDetailView(
            scene3D: Scene3D(
                sceneNumber: 1,
                title: "Opening Scene",
                description: "The protagonist enters the room",
                cameraPosition: CameraPosition()
            )
        )
    }
}

