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
    var countriesByRegion: [String: [CountryResponse]] = [:]
//    enum Region: Int {
//        case africa = 59
//        case americas = 56
//        case antarctic = 5
//        case asia = 50
//        case europe = 53
//        case oceania = 27
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 72
        tableView.rowHeight = UITableView.automaticDimension
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "expandableCell")
        tableView.separatorStyle = .none
    }
    private func loadData(){
        let networkManager = NetworkManager()
        networkManager.downloadJSON { [weak self] countries in
            self?.countries = countries
            self?.groupCountriesByRegion()
            self?.tableView.reloadData()
            print("Success")
        }
    }
    private func groupCountriesByRegion() {
        for country in countries {
            let region = country.region
            var countriesInRegion = countriesByRegion[region] ?? []
            countriesInRegion.append(country)
            countriesByRegion[region] = countriesInRegion
        }
    }
}

extension CountriesList: UITableViewDataSource{
    
    //Ряды
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expandableCell",for: indexPath) as! TableViewCell
        let section = indexPath.section
        let row = indexPath.row
        let region = Array(countriesByRegion.values)[section]
        let country = region[row]
        let imgURL = country.flags.png
        
        cell.countryFlag.downloaded(from: imgURL)
        cell.countryName.text = country.name.common
        cell.capitalCity.text = country.capital?.description
        cell.bottomArea.text = country.area.description
        cell.bottomPopulation.text = country.population.description
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: indexPath)
    }
    
    //Секции
    func numberOfSections(in tableView: UITableView) -> Int {
        return countriesByRegion.keys.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(countriesByRegion.keys)[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let region = Array(countriesByRegion.values)[section]
        return region.count
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destionation = segue.destination as? CountryViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
                let section = selectedIndexPath.section
                let row = selectedIndexPath.row
                let region = Array(countriesByRegion.values)[section]
                let country = region[row]
                destionation.country = country
            }
    }
}

extension CountriesList: UITableViewDelegate{
    
}
