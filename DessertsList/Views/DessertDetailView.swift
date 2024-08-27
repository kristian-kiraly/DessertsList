//
//  DessertDetailView.swift
//  DessertsList
//
//  Created by Kristian Kiraly on 8/26/24.
//

import SwiftUI

struct DessertDetailView: View {
    let dessert: Meal
    
    var body: some View {
        ScrollView {
            VStack {
                header
                ingredients
                instructions
            }
            .padding()
        }
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(dessert.strMeal ?? "Meal Name")
                    .font(.title2)
                if let strArea = dessert.strArea {
                    Text(strArea)
                        .font(.callout)
                }
                //Horizontally scrolling list of tags with a Rounded Rectangle container
                if let tags = dessert.strTags {
                    ScrollView(.horizontal) {
                        HStack(spacing: 5) {
                            ForEach(tags, id: \.self) { tag in
                                Text(tag)
                                    .padding(5)
                                    .background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.cyan)
                                    }
                            }
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        }
                    }
                }
                if let source = dessert.strSource,
                   let sourceURL = URL(string: source)
                {
                    HStack(spacing: 0) {
                        Link("Source", destination: sourceURL)
                    }
                }
            }
            Spacer()
            DessertThumbnailView(dessert: dessert)
        }
    }
    
    //Creates a vertical list of ingredients that fan out the name on the left side,
    //the amount on the right, and a divider between
    @ViewBuilder
    private var ingredients: some View {
        if let ingredients = dessert.ingredients {
            VStack {
                Text("Ingredients")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(ingredients) { ingredient in
                    if let name = ingredient.name,
                       let measure = ingredient.measure,
                       !name.isEmpty, !measure.isEmpty {
                        HStack {
                            Text(name)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .multilineTextAlignment(.trailing)
                            Divider()
                            Text(measure)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    private var instructions: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Instructions")
                .font(.headline)
            Text(dessert.strInstructions ?? "This dessert has no instructions")
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    DessertDetailView(dessert: .testDessert)
}
