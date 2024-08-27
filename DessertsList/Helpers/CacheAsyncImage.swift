//
//  CacheAsyncImage.swift
//  DessertsList
//
//  Created by Kristian Kiraly on 8/26/24.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL
    
    @State private var image: UIImage? = nil

    private let cache = URLCache.shared

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            ProgressView()
                .task {
                    await loadImage()
                }
        }
    }

    private func loadImage() async {
        let request = URLRequest(url: url)
        if let cachedResponse = cache.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            self.image = cachedImage
        } else {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200,
                   let fetchedImage = UIImage(data: data) {
                    self.image = fetchedImage
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                }
            } catch {
                // Handle error
                print("Error loading image: \(error)")
            }
        }
    }
}
