//
//  HomeView.swift
//  FilmStudioPilot
//
//  Created by Jai Deshmukh on 12/7/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var productions: [Production]
    @State private var productionState = ProductionState()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Hero Carousel
                    if !productions.isEmpty {
                        HeroCarouselView(productions: Array(productions.prefix(5)))
                    }
                    
                    // Content Rows
                    VStack(alignment: .leading, spacing: 20) {
                        if !productions.isEmpty {
                            ProductionRowView(
                                title: "For You",
                                productions: productions.filter { $0.status == .released }
                            )
                            
                            ProductionRowView(
                                title: "New Releases",
                                productions: Array(productions.filter { $0.status == .released }.suffix(10))
                            )
                        } else {
                            emptyStateView
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("FilmStudio")
            .background(Color.black.ignoresSafeArea())
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No productions yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Start watching to generate personalized content")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Production.self, inMemory: true)
}

