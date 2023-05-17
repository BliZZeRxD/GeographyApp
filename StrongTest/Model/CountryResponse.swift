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
    let timezones: [String]
    let currencies: [String: Currency]?
}

struct Flags: Codable {
    let png: String
}

struct Name: Codable {
    let common: String
}

struct Currency: Codable {
    let name: String?
    let symbol: String?
}
func convertCoordinatesToDegrees(latlng: [Double]) -> (latitude: String, longitude: String)? {
    guard latlng.count == 2 else {
        return nil
    }

    let latitude = convertCoordinateToDegrees(latlng[0])
    let longitude = convertCoordinateToDegrees(latlng[1])

    return (latitude, longitude)
}

func convertCoordinateToDegrees(_ coordinate: Double) -> String {
    let degrees = Int(coordinate)
    let minutes = Int(abs((coordinate - Double(degrees)) * 60))

    return String(format: "%d° %d'", degrees, minutes)
}


//let currencies: [String: [String: String]]
//CapitalCoordinates Computable Variable
//let latlng: [Float]
//Сделать через перевод из инт в String миллионы
//Сделать через перевод из инт в String км^2
//Струкртура
//let currencies: String
//Массив из String
//let timeZones: String

