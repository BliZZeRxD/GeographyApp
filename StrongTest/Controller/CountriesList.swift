//
//  CountriesList.swift
//  StrongTest
//
//  Created by Ayan on 11.05.2023.
//

import UIKit

class CountriesList: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    
// MARK: - Public Properties
    var countries = [CountryResponse]()
    var countriesByRegion = [String: [CountryResponse]]()
    var country: CountryResponse?
    var selectedIndexPath: IndexPath?
    var finalCurrencyName: String?
    var finalCurrencyCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }
// MARK: - Functions
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "expandableCell")
        tableView.separatorStyle = .none
//        if let currencyName = country?.currencies?.values.first {
//            finalCurrencyName = currencyName.name ?? ""
//        } else {
//            finalCurrencyName = ""
//        }
//        if let currencyCode = country?.currencies?.keys.first{
//            finalCurrencyCode = currencyCode
//        }
//        else{
//            finalCurrencyCode = ""
//        }
    }

    private func loadData() {
        NetworkManager().downloadJSON { [weak self] countries in
            self?.countries = countries
            self?.groupCountriesByRegion()
            self?.tableView.reloadData()
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

    @objc private func learnMoreButtonTapped(_ sender: UIButton) {
        if let indexPath = tableView.indexPathForRow(at: sender.convert(.zero, to: tableView)) {
            performSegue(withIdentifier: "showDetails", sender: indexPath)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CountryDetailsVC,
           let indexPath = sender as? IndexPath {
            let section = indexPath.section
            let row = indexPath.row
            let region = Array(countriesByRegion.values)[section]
            let country = region[row]
            destination.country = country
        }
    }
}
// MARK: - TableViewDataSource
extension CountriesList: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expandableCell", for: indexPath) as! TableViewCell
        let section = indexPath.section
        let row = indexPath.row
        let region = Array(countriesByRegion.values)[section]
        let country = region[row]
        
        cell.countryFlag.downloaded(from: country.flags.png)
        cell.countryName.text = country.name.common
        cell.capitalCity.text = (country.capital ?? [])?.joined(separator: ", ") ?? ""
        cell.bottomCurrencies.text = "\(country.currencies?.values.first?.name ?? ""), \(country.currencies?.keys.first ?? "")"
        
        cell.learnMore.tag = indexPath.row
        cell.learnMore.addTarget(self, action: #selector(learnMoreButtonTapped(_:)), for: .touchUpInside)
        
        if let bottomView = cell.bottomView {
            if bottomView.isHidden {
                cell.bottomArea.text = country.area.description
                cell.bottomPopulation.text = country.population.description
                cell.bottomArea.isHidden = false
                cell.bottomPopulation.isHidden = false
            } else {
                cell.bottomArea.isHidden = true
                cell.bottomPopulation.isHidden = true
            }
        }
        return cell
    }

}

// MARK: - TableViewDelegate

extension CountriesList: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
            cell.bottomView.isHidden.toggle()
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let baseHeight: CGFloat = 75.0
        let additionalHeight: CGFloat = 141.0
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow, selectedIndexPath == indexPath {
            return baseHeight + additionalHeight
        } else {
            return baseHeight
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return countriesByRegion.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let region = Array(countriesByRegion.values)[section]
        return region.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(countriesByRegion.keys)[section]
    }
}
