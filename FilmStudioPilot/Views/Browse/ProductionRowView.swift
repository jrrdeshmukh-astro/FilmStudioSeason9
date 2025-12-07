//
//  ProductionRowView.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import SwiftUI

struct ProductionRowView: View {
    let title: String
    let productions: [Production]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(productions) { production in
                        NavigationLink {
                            ProductionDetailView(production: production)
                        } label: {
                            ProductionPosterCard(production: production)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

struct ProductionPosterCard: View {
    let production: Production
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster placeholder
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 140, height: 210)
                .cornerRadius(8)
                .overlay(
                    VStack {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                    }
                )
            
            Text(production.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineLimit(2)
                .frame(width: 140, alignment: .leading)
        }
    }
}

#Preview {
    ProductionRowView(
        title: "For You",
        productions: [
            Production(
                title: "Time Paradox",
                synopsis: "A compelling story",
                genre: "Science Fiction",
                duration: 300
            )
        ]
    )
    .background(Color.black)
}

