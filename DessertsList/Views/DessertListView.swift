//
//  ContentView.swift
//  DessertsList
//
//  Created by Kristian Kiraly on 8/26/24.
//

import SwiftUI

struct DessertListView: View {
    @StateObject private var model = DessertListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                //If we're still loading, show a progress view and load
                if model.loadingDesserts {
                    VStack {
                        Text("Loading Desserts...")
                        ProgressView()
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                } else {
                    //If we have already loaded the API and there are still no desserts, show a message
                    if model.desserts.isEmpty {
                        Text("No Desserts Available")
                    } else {
                        dessertsList
                    }
                }
            }
            .navigationTitle("Desserts")
        }
        .sheet(item: $model.dessertToView) { dessert in
            DessertDetailView(dessert: dessert)
        }
    }
    
    private var dessertsList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(model.desserts) { dessert in
                    let isLastDessert = model.desserts.firstIndex(where: {$0.id == dessert.id}) == model.desserts.count - 1
                    if !isLastDessert {
                        Divider()
                    }
                    Button {
                        Task {
                            do {
                                try await model.loadDessertDetails(dessert: dessert)
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        }
                    } label: {
                        dessertButtonLabel(dessert: dessert)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(model.dessertIDToLoad == dessert.idMeal)
                }
            }
        }
    }
    
    private func dessertButtonLabel(dessert: Meal) -> some View {
        HStack(alignment: .top) {
            Text(dessert.strMeal ?? "Meal Name")
                .font(.headline)
            Spacer()
            DessertThumbnailView(dessert: dessert)
        }
        .padding()
        .overlay {
            if model.dessertIDToLoad == dessert.idMeal {
                ZStack {
                    Color.white.opacity(0.5)
                    ProgressView()
                }
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    DessertListView()
}
