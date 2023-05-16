//
//  TableViewCell.swift
//  StrongTest
//
//  Created by Ayan on 11.05.2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var capitalCity: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var bottomPopulation: UILabel!
    @IBOutlet weak var bottomArea: UILabel!
    @IBOutlet weak var bottomCurrencies: UILabel!
    @IBOutlet weak var learnMore: UIButton!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.isHidden = true
        }
    }
    func configure(with country: CountryResponse) {
           let imgURL = country.flags.png
           countryFlag.downloaded(from: imgURL)
           countryName.text = country.name.common
           capitalCity.text = country.capital?.description
           bottomArea.text = country.area.description
           bottomPopulation.text = country.population.description
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
