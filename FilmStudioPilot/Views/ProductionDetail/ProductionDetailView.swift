//
//  ProductionDetailView.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import SwiftUI

struct ProductionDetailView: View {
    let production: Production
    @State private var showPlayer = false
    @State private var show3DStoryboard = false
    @State private var scenes3D: [Scene3D] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Hero image
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 400)
                    .overlay(
                        VStack {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                        }
                    )
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(production.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 16) {
                        Label(production.genre, systemImage: "film")
                        Label(formatDuration(production.duration), systemImage: "clock")
                        Label(production.releaseDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    Text(production.synopsis)
                        .font(.body)
                        .lineSpacing(4)
                    
                    // Action buttons
                    VStack(spacing: 12) {
                        Button {
                            showPlayer = true
                        } label: {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Play")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                        }
                        
                        if let storyIdea = production.storyIdea, !storyIdea.sceneBeats.isEmpty {
                            Button {
                                generate3DScenes()
                                show3DStoryboard = true
                            } label: {
                                HStack {
                                    Image(systemName: "cube.transparent")
                                    Text("View 3D Storyboard")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showPlayer) {
            VideoPlayerView(production: production)
        }
        #else
        .sheet(isPresented: $showPlayer) {
            VideoPlayerView(production: production)
        }
        #endif
        .sheet(isPresented: $show3DStoryboard) {
            if !scenes3D.isEmpty {
                Storyboard3DListView(scenes: scenes3D)
            }
        }
    }
    
    private func generate3DScenes() {
        guard let storyIdea = production.storyIdea else { return }
        let service = Scene3DService()
        scenes3D = service.generateScenes(from: storyIdea)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        return "\(minutes) min"
    }
}

#Preview {
    NavigationStack {
        ProductionDetailView(
            production: Production(
                title: "Time Paradox",
                synopsis: "A scientist discovers a way to manipulate time, but each change creates unexpected consequences. As the timeline fractures, she must race against time itself to restore order before reality collapses.",
                genre: "Science Fiction",
                duration: 300
            )
        )
    }
}

