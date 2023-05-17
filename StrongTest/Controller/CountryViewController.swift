//
//  CountryViewController.swift
//  StrongTest
//
//  Created by Ayan on 12.05.2023.
//

import UIKit
import CoreLocation

class CountryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var capitalCoordinatesLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    
    var country: CountryResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = country?.name.common
        
        // MARK: - AreaFormater
        let areaValue = country?.area
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "en_US")
        if let formattedString = formatter.string(from: NSNumber(value: areaValue!)){
            let result = formattedString + " km²"
            areaLabel.text = result
        }
        
        // MARK: - FlagConfiguration
        let imgURL = (country?.flags.png)!
        countryFlag.downloaded(from: imgURL)
        
        // MARK: - CountryPropertiesVariables
        regionLabel.text = country?.region
        capitalLabel.text = country?.capital?.description
        populationLabel.text = country?.population.description
        capitalCoordinatesLabel.text = country?.latlng.description
        timeZoneLabel.text = country?.timezones.first
        
    }

}


