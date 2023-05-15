//
//  CountriesList.swift
//  StrongTest
//
//  Created by Ayan on 11.05.2023.
//

import UIKit

class CountriesList: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    var countries = [CountryResponse]()
//    var getCountryProperty: CountryResponse?
    
//    enum Region: Int {
//        case africa = 59
//        case americas = 56
//        case antarctic = 5
//        case asia = 50
//        case europe = 53
//        case oceania = 27
//    }
    var regions: [String] = [
        "Africa", "Americas", "Antarctic", "Asia", "Europe", "Oceania"
    ]
//    var countriesInAfrica = Region.africa
    override func viewDidLoad() {
        super.viewDidLoad()
        let networkManager = NetworkManager()
        networkManager.downloadJSON { [weak self] countries in
            self?.countries = countries
            self?.tableView.reloadData()
            print("Success")
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 72
        tableView.rowHeight = UITableView.automaticDimension
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "expandableCell")
        tableView.separatorStyle = .none
    }
}

extension CountriesList: UITableViewDataSource{
    
    //Ряды
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "expandableCell") as? TableViewCell)!
        let country = countries[indexPath.row]
        let imgURL = country.flags.png
        cell.countryFlag.downloaded(from: imgURL)
        cell.countryName.text = country.name.common
        cell.capitalCity.text = country.capital?.description
        cell.bottomArea.text = country.area.description
        cell.bottomPopulation.text = country.population.description
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    //Секции
    func numberOfSections(in tableView: UITableView) -> Int {
        return regions.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return regions.first
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destionation = segue.destination as? CountryViewController{
            destionation.country = countries[tableView.indexPathForSelectedRow!.row]
        }
    }
}

extension CountriesList: UITableViewDelegate{
    
}
