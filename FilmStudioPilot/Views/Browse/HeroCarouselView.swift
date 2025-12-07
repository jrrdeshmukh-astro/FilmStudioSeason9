//
//  HeroCarouselView.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import SwiftUI

struct HeroCarouselView: View {
    let productions: [Production]
    @State private var currentIndex: Int = 0
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(productions.enumerated()), id: \.element.id) { index, production in
                NavigationLink {
                    ProductionDetailView(production: production)
                } label: {
                    HeroCard(production: production)
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page)
        .frame(height: 500)
        .onAppear {
            setupPageControl()
        }
    }
    
    private func setupPageControl() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .white
        UIPageControl.appearance().pageIndicatorTintColor = .gray
    }
}

struct HeroCard: View {
    let production: Production
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background image placeholder
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    Text(production.title)
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                )
            
            // Overlay gradient
            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.7)],
                startPoint: .center,
                endPoint: .bottom
            )
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                Text(production.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(production.synopsis)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(3)
                
                HStack(spacing: 12) {
                    Button {
                        // Play action
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Play")
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                    
                    Button {
                        // Info action
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(24)
        }
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

#Preview {
    HeroCarouselView(productions: [
        Production(
            title: "Time Paradox",
            synopsis: "A scientist discovers a way to manipulate time, but each change creates unexpected consequences.",
            genre: "Science Fiction",
            duration: 300
        )
    ])
}

