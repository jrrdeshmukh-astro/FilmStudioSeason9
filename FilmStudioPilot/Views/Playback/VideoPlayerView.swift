//
//  VideoPlayerView.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import SwiftUI
import AVKit
import SwiftData

struct VideoPlayerView: View {
    let production: Production
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var watchState = MediaWatchState()
    @StateObject private var interactionState = MediaInteractionState()
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .onAppear {
                        player.play()
                        isPlaying = true
                        watchState.isPlaying = true
                        watchState.currentProduction = production
                        watchState.incrementViewCount(for: production.id)
                    }
                    .onDisappear {
                        player.pause()
                        handlePlaybackEnd()
                    }
            } else {
                ProgressView()
                    .tint(.white)
            }
            
            // Custom controls overlay
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
                
                // Bottom controls
                HStack(spacing: 24) {
                    Button {
                        watchState.markSkipped(production.id)
                        interactionState.recordInteraction(
                            MediaInteraction(
                                productionId: production.id,
                                type: .skip
                            )
                        )
                        dismiss()
                    } label: {
                        VStack {
                            Image(systemName: "forward.end")
                            Text("Skip")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                    }
                    
                    Button {
                        watchState.markLiked(production.id)
                        interactionState.recordInteraction(
                            MediaInteraction(
                                productionId: production.id,
                                type: .like
                            )
                        )
                    } label: {
                        VStack {
                            Image(systemName: "heart.fill")
                            Text("Like")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))
            }
        }
        .task {
            setupPlayer()
        }
    }
    
    private func setupPlayer() {
        // For v1, use a placeholder video URL
        // In production, this would be the actual production video URL
        if let videoURL = production.videoURL, let url = URL(string: videoURL) {
            player = AVPlayer(url: url)
        } else {
            // Use a sample video for demo
            // In production, handle missing video gracefully
            player = nil
        }
    }
    
    private func handlePlaybackEnd() {
        watchState.isPlaying = false
        
        // Check if production was completed (watched > 80%)
        if watchState.watchProgress > 0.8 {
            watchState.markCompleted(production.id)
            interactionState.recordInteraction(
                MediaInteraction(
                    productionId: production.id,
                    type: .complete,
                    context: InteractionContext(
                        pauseTime: nil,
                        watchProgress: watchState.watchProgress,
                        duration: production.duration
                    )
                )
            )
        }
    }
}

#Preview {
    VideoPlayerView(
        production: Production(
            title: "Time Paradox",
            synopsis: "A compelling story",
            genre: "Science Fiction",
            duration: 300
        )
    )
}

