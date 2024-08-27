//
//  DessertListViewModel.swift
//  DessertsList
//
//  Created by Kristian Kiraly on 8/26/24.
//

import Foundation

//Wrapper for any network errors we encounter
enum NetworkRequestError: LocalizedError {
    case unknownError
    case error(String)
    
    var errorDescription: String? {
        switch self {
        case .unknownError:
            return "Unknown Error"
        case .error(let error):
            return error
        }
    }
}

//Wrapper for any issues related to unwrapping optionals
enum OptionalUnwrappingError: LocalizedError {
    case valueNotFound
    
    var errorDescription: String? {
        switch self {
        case .valueNotFound:
            return "Value not found when unwrapping optional"
        }
    }
}

//View model for DessertListView
class DessertListViewModel: ObservableObject {
    @Published var desserts: [Meal]             //List of desserts
    @Published var loadingDesserts = true       //Flag to tell the view if we're loading the data or not
    @Published var dessertToView: Meal?         //If populated, the view will show a sheet displaying the meal data
    @Published var dessertIDToLoad: String?     //If populated, the view will show a loading overlay over the relevant meal and prevent additional meal loads
    
    init() {
        self.desserts = []
        Task {
            do {
                try await self.fetchDesserts()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchDesserts() async throws {
        let apiPath = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        
        //Perform UI Actions on Main Thread
        await MainActor.run {
            loadingDesserts = true
        }
        
        defer {
            //Perform UI Actions on Main Thread
            DispatchQueue.main.async {
                self.loadingDesserts = false
            }
        }
        
        let data = try await performGET(path: apiPath)
        
        let meals = try deserializeMeals(data: data)
        
        //Ensure no null values are included in the list
        let filteredMeals = meals.filter { meal in
            meal.idMeal != nil && meal.strMeal != nil && meal.strMealThumb != nil
        }
        
        //Sort alphabetically
        let sortedMeals = try filteredMeals.sorted { lhsMeal, rhsMeal in
            guard let lhsMealString = lhsMeal.strMeal, let rhsMealString = rhsMeal.strMeal else { throw OptionalUnwrappingError.valueNotFound }
            return lhsMealString < rhsMealString
        }
        
        await MainActor.run {
            desserts = sortedMeals
        }
    }
    
    func loadDessertDetails(dessert: Meal) async throws {
        //Prevent additional loads and show a loading overlay by setting the current ID
        guard dessertIDToLoad == nil else { return }
        
        //Perform UI Actions on Main Thread
        await MainActor.run {
            dessertIDToLoad = dessert.idMeal
        }
        
        //Perform UI Actions on Main Thread
        defer {
            DispatchQueue.main.async {
                self.dessertIDToLoad = nil
            }
        }
        
        guard let mealID = dessert.idMeal else { return }
        let apiPath = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
        
        let data = try await performGET(path: apiPath)
        
        let meals = try deserializeMeals(data: data)
        
        guard let selectedDessert = meals.first
        else {
            throw NetworkRequestError.error("Failed to retrieve dessert details: Response had no dessert")
        }
        
        //Perform UI updates on the main thread
        await MainActor.run {
            self.dessertToView = selectedDessert
        }
    }
    
    //Load json data into a dictionary and then load the "meals" key as a list of dictionaries and convert to Meal instances
    private func deserializeMeals(data: Data) throws -> [Meal] {
        guard let responseDictionary = try JSONSerialization.jsonObject(with: data) as? [String : Any],
              let mealsDictionaries = responseDictionary["meals"] as? [[String : Any]]
        else {
            throw NetworkRequestError.error("Error deserializing response")
        }
        
        let mealsData = try JSONSerialization.data(withJSONObject: mealsDictionaries)
        
        let meals = try JSONDecoder().decode([Meal].self, from: mealsData)
        
        return meals
    }
    
    //Generalized GET that returns Data if no errors occur
    private func performGET(path: String) async throws -> Data {
        guard let apiURL = URL(string: path)
        else {
            throw NetworkRequestError.error("Error creating URL")
        }
        
        var urlRequest = URLRequest(url: apiURL)
        urlRequest.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        return data
    }
}
