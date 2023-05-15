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
    var getCountryProperty: CountryResponse?
    
    var regionCounrtyNumbers: [String:Int] = [
        "Asia": 50,
        "Americas": 56,
        "Antarctic": 5,
        "Africa": 59,
        "Europe": 53,
        "Oceania": 27
    ]
//    var regions: [String] = [
//        "Asia", "Americas", "Antarctic", "Africa", "Europe", "Oceania"
//    ]
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name.common
        cell.detailTextLabel?.text = country.capital?.first
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    //Секции
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return regionCounrtyNumbers.count
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return regionCounrtyNumbers.keys = "Asia"
//    }
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
