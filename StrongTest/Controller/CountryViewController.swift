//
//  CountryViewController.swift
//  StrongTest
//
//  Created by Ayan on 12.05.2023.
//

import UIKit
import CoreLocation

class CountryViewController: UIViewController {

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
        
        // Форматирование сырого значения Area в отображение с квадратными киллометрами
        let areaValue = country?.area
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "en_US")
        if let formattedString = formatter.string(from: NSNumber(value: areaValue!)){
            let result = formattedString + " km²"
            areaLabel.text = result
        }
        
        // Установка Флага
        let imgURL = (country?.flags.png)!
        countryFlag.downloaded(from: imgURL)
        
        regionLabel.text = country?.region
        capitalLabel.text = country?.capital?.first
        populationLabel.text = country?.population.description
        capitalCoordinatesLabel.text = country?.latlng.description
        
    }

}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
