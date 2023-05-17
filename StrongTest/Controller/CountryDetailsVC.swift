//
//  CountriesList.swift
//  StrongTest
//
//  Created by Ayan on 17.05.2023.
//
import Foundation
import UIKit

class CountryDetailsVC: UIViewController {
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    var country: CountryResponse?
    let countryProperties: [String] = [
        "Region:",
        "Capital:",
        "Capital coorditanes:",
        "Population:",
        "Area:",
        "Currency:",
        "Timezones:"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = country?.name.common
        detailsTableView.frame = view.bounds
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        detailsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailsCell")
        view.addSubview(detailsTableView)
    }
}

extension CountryDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryProperties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        
        if indexPath.row == 0 {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 373, height: 213))
            imageView.downloaded(from: country?.flags.png ?? "")
            cell.addSubview(imageView)
        } else {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height/2))
            label.text = countryProperties[indexPath.row]
            cell.addSubview(label)

            let valueLabel = UILabel(frame: CGRect(x: 0, y: cell.frame.height/2, width: cell.frame.width, height: cell.frame.height/2))
            valueLabel.textAlignment = .left
            valueLabel.numberOfLines = 0
            valueLabel.lineBreakMode = .byWordWrapping
            
            switch indexPath.row {
            case 0:
                valueLabel.text = country?.region
            case 1:
                valueLabel.text = country?.capital?.description
            case 2:
                valueLabel.text = country?.latlng.description
            case 3:
                valueLabel.text = "\(country?.population ?? 0)"
            case 4:
                valueLabel.text = "\(country?.area ?? 0)"
            case 5:
                valueLabel.text = ""
            case 6:
                valueLabel.text = country?.timezones.joined(separator: ", ")
            default:
                valueLabel.text = ""
            }
            
            cell.addSubview(valueLabel)
        }
        
        return cell
    }
}

extension CountryDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 213
        } else {
            return 80
        }
    }
}
