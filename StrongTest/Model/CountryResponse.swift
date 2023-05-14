//
//  NetworkManager.swift
//  StrongTest
//
//  Created by Ayan on 12.05.2023.
//

import UIKit

struct CountryResponse: Codable{
    let name: Name
    let capital: [String]?
    let region: String
    let population: Int
    let area: Double
    let latlng: [Double]
    let flags: Flags
    
}
struct Flags: Codable {
    let png: String
}
struct Name: Codable {
    let common: String
}


//let population: Int
//let currencies: [String: [String: String]]
//CapitalCoordinates Computable Variable
//let latlng: [Float]
//Сделать через перевод из инт в String миллионы
//Сделать через перевод из инт в String км^2
//Струкртура
//let currencies: String
//Массив из String
//let timeZones: String
//Распарсить структуру
//let flags: Struct

