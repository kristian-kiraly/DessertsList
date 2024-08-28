//
//  Meal.swift
//  DessertsList
//
//  Created by Kristian Kiraly on 8/26/24.
//

import Foundation

struct Meal: Codable {
    let idMeal: String?
    let strMeal: String?
    let strDrinkAlternate: String?
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?
    let strTags: [String]?
    let strYoutube: String?
    let ingredients: [Ingredient]?
    let strSource: String?
    let strImageSource: String?
    let strCreativeCommonsConfirmed: String?
    let dateModified: String?
    
    private static let dessertJSON = """
    {
        "idMeal": "53062",
        "strMeal": "Walnut Roll Gužvara",
        "strDrinkAlternate": null,
        "strCategory": "Dessert",
        "strArea": "Croatian",
        "strInstructions": "Mix all the ingredients for the dough together and knead well. Cover the dough and put to rise until doubled in size which should take about 2 hours. Knock back the dough and knead lightly.\\r\\n\\r\\nDivide the dough into two equal pieces; roll each piece into an oblong about 12 inches by 8 inches. Mix the filling ingredients together and divide between the dough, spreading over each piece. Roll up the oblongs as tightly as possible to give two 12 inch sausages. Place these side by side, touching each other, on a greased baking sheet. Cover and leave to rise for about 40 minutes. Heat oven to 200ºC (425ºF). Bake for 30-35 minutes until well risen and golden brown. Bread should sound hollow when the base is tapped.\\r\\n\\r\\nRemove from oven and brush the hot bread top with milk. Sift with a generous covering of icing sugar.",
        "strMealThumb": "https://www.themealdb.com/images/media/meals/u9l7k81628771647.jpg",
        "strTags": "Nutty",
        "strYoutube": "https://www.youtube.com/watch?v=Q_akngSJVrQ",
        "strIngredient1": "Flour",
        "strIngredient2": "Caster Sugar",
        "strIngredient3": "Yeast",
        "strIngredient4": "Salt",
        "strIngredient5": "Milk",
        "strIngredient6": "Eggs",
        "strIngredient7": "Butter",
        "strIngredient8": "Walnuts",
        "strIngredient9": "Butter",
        "strIngredient10": "Brown Sugar",
        "strIngredient11": "Cinnamon",
        "strIngredient12": "Milk",
        "strIngredient13": "Icing Sugar",
        "strIngredient14": "",
        "strIngredient15": "",
        "strIngredient16": "",
        "strIngredient17": "",
        "strIngredient18": "",
        "strIngredient19": "",
        "strIngredient20": "",
        "strMeasure1": "450g",
        "strMeasure2": "55g",
        "strMeasure3": "2 parts ",
        "strMeasure4": "1/2 tsp",
        "strMeasure5": "6 oz ",
        "strMeasure6": "2 Beaten ",
        "strMeasure7": "30g",
        "strMeasure8": "140g",
        "strMeasure9": "85g",
        "strMeasure10": "85g",
        "strMeasure11": "1 tsp ",
        "strMeasure12": "To Glaze",
        "strMeasure13": "To Glaze",
        "strMeasure14": " ",
        "strMeasure15": " ",
        "strMeasure16": " ",
        "strMeasure17": " ",
        "strMeasure18": " ",
        "strMeasure19": " ",
        "strMeasure20": " ",
        "strSource": "https://www.visit-croatia.co.uk/croatian-cuisine/croatian-recipes/",
        "strImageSource": null,
        "strCreativeCommonsConfirmed": null,
        "dateModified": null
    }
    """
    
    static var testDessert: Meal {
        if let data = dessertJSON.data(using: .utf8) {
            do {
                let dessert = try JSONDecoder().decode(Meal.self, from: data)
                print(dessert)
                return dessert
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        fatalError()
    }
}

struct Ingredient: Codable {
    let name: String?
    let measure: String?
}

extension Ingredient: Identifiable {
    var id: String {
        UUID().uuidString
    }
}

//MARK: - Codable
extension Meal {
    private enum CodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strDrinkAlternate
        case strCategory
        case strArea
        case strInstructions
        case strMealThumb
        case strTags
        case strYoutube
        case strSource
        case strImageSource
        case strCreativeCommonsConfirmed
        case dateModified
        
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10
        case strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5
        case strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10
        case strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        case strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }

    private enum IngredientKeys: String, CodingKey {
        case name
        case measure
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        idMeal = try container.decodeIfPresent(String.self, forKey: .idMeal)
        strMeal = try container.decodeIfPresent(String.self, forKey: .strMeal)
        strDrinkAlternate = try container.decodeIfPresent(String.self, forKey: .strDrinkAlternate)
        strCategory = try container.decodeIfPresent(String.self, forKey: .strCategory)
        strArea = try container.decodeIfPresent(String.self, forKey: .strArea)
        strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        
        if let tags = try container.decodeIfPresent(String.self, forKey: .strTags) {
            strTags = tags.components(separatedBy: .init(charactersIn: ","))
        } else {
            strTags = nil
        }
        
        strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube)
        strSource = try container.decodeIfPresent(String.self, forKey: .strSource)
        strImageSource = try container.decodeIfPresent(String.self, forKey: .strImageSource)
        strCreativeCommonsConfirmed = try container.decodeIfPresent(String.self, forKey: .strCreativeCommonsConfirmed)
        dateModified = try container.decodeIfPresent(String.self, forKey: .dateModified)
        
        var ingredientsArray = [Ingredient]()
        
        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            let measureKey = "strMeasure\(i)"
            
            if let ingredientName = try container.decodeIfPresent(String.self, forKey: CodingKeys(rawValue: ingredientKey)!) {
                let ingredientMeasure = try container.decodeIfPresent(String.self, forKey: CodingKeys(rawValue: measureKey)!)
                let ingredient = Ingredient(name: ingredientName, measure: ingredientMeasure)
                ingredientsArray.append(ingredient)
            }
        }
        
        ingredients = ingredientsArray.isEmpty ? nil : ingredientsArray
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(idMeal, forKey: .idMeal)
        try container.encodeIfPresent(strMeal, forKey: .strMeal)
        try container.encodeIfPresent(strDrinkAlternate, forKey: .strDrinkAlternate)
        try container.encodeIfPresent(strCategory, forKey: .strCategory)
        try container.encodeIfPresent(strArea, forKey: .strArea)
        try container.encodeIfPresent(strInstructions, forKey: .strInstructions)
        try container.encodeIfPresent(strMealThumb, forKey: .strMealThumb)
        try container.encodeIfPresent(strTags, forKey: .strTags)
        try container.encodeIfPresent(strYoutube, forKey: .strYoutube)
        try container.encodeIfPresent(strSource, forKey: .strSource)
        try container.encodeIfPresent(strImageSource, forKey: .strImageSource)
        try container.encodeIfPresent(strCreativeCommonsConfirmed, forKey: .strCreativeCommonsConfirmed)
        try container.encodeIfPresent(dateModified, forKey: .dateModified)
        
        for (index, ingredient) in (ingredients ?? []).enumerated() {
            let ingredientKey = "strIngredient\(index + 1)"
            let measureKey = "strMeasure\(index + 1)"
            
            try container.encodeIfPresent(ingredient.name, forKey: CodingKeys(rawValue: ingredientKey)!)
            try container.encodeIfPresent(ingredient.measure, forKey: CodingKeys(rawValue: measureKey)!)
        }
    }
}

//MARK: - Identifiable
//Identifiable conformance with optional unwrapping
extension Meal: Identifiable {
    var id: String {
        idMeal ?? UUID().uuidString
    }
}

//MARK: - Thumbnail Building
extension Meal {
    var mealThumbURL: URL? {
        guard let strMealThumb else { return nil }
        return URL(string: strMealThumb)
    }
}
