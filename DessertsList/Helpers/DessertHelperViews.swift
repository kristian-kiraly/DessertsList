//
//  DessertHelperViews.swift
//  DessertsList
//
//  Created by Kristian Kiraly on 8/26/24.
//

import SwiftUI

//MARK: - Async Thumbnail View
struct DessertThumbnailView: View {
    let dessert: Meal
    
    var thumbnailSize: CGFloat = 100
    
    //Load the image asynchronously while showing a progress indicator and an optional source link below
    var body: some View {
        VStack {
            Group {
                if let mealThumbURL = dessert.mealThumbURL {
                    CachedAsyncImage(url: mealThumbURL)
                } else {
                    Image(systemName: "photo")
                }
            }
            .frame(width: thumbnailSize, height: thumbnailSize)
            if let source = dessert.strImageSource,
               let sourceURL = URL(string: source)
            {
                Link("Source", destination: sourceURL)
            }
        }
    }
}
