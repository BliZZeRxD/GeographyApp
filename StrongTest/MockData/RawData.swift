//
//  RawData.swift
//  StrongTest
//
//  Created by Ayan on 12.05.2023.
//

import Foundation

struct regionsList{
    let region: String
    let country: [String]
    let capitalCity: [String]
}

let asiaRegion = regionsList(region: "Asia", country: ["Kazakhstan","Japan","South Korea"], capitalCity: ["Astana", "Tokyo", "Seoul"])

let europeRegion = regionsList(region: "Europe", country: ["United Kingdome", "France", "Ukraine"], capitalCity: ["London", "Paris", "Kiyv"])

