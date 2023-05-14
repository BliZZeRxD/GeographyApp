//
//  NetworkManager.swift
//  StrongTest
//
//  Created by Ayan on 12.05.2023.
//

import Foundation

struct NetworkManager {
    func downloadJSON(completed: @escaping ([CountryResponse]) -> Void) {
            guard let url = URL(string: "https://restcountries.com/v3.1/all") else {
                print("Invalid URL")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching data from API: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let countries = try decoder.decode([CountryResponse].self, from: data)
                        DispatchQueue.main.async {
                            completed(countries)
                        }
                    }
                    catch let error {
                        print("Error decoding data: \(error.localizedDescription)")
                    }
                } else {
                    print("No data received from server")
                }
            }.resume()
        }
    
}
//func downloadJSON(completed: @escaping () -> ()) {
//    let url = URL(string: "https://restcountries.com/v3.1/all")
//
//    URLSession.shared.dataTask(with: url!) { data, response, error in
//        if let error = error {
//            print("Error fetching data from API: \(error.localizedDescription)")
//            return
//        }
//
//        if let data = data {
//            do {
//                let decoder = JSONDecoder()
//                let countries = try decoder.decode([CountryResponse].self, from: data)
//
//                // Выведем список стран в консоль
//                for country in countries {
//                    if let capital = country.capital?.first {
//                        print("\(country.name.common) - \(capital)")
//                    } else {
//                        print("\(country.name.common) - No capital")
//                    }
//                }
//
//                DispatchQueue.main.async {
//                    completed()
//                }
//            } catch {
//                print("Error decoding data: \(error.localizedDescription)")
//            }
//        } else {
//            print("No data received from server")
//        }
//    }.resume()
//}
