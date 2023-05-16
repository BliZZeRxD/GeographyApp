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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 72
        tableView.rowHeight = UITableView.automaticDimension
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "expandableCell")
        tableView.separatorStyle = .none
    }
    
    private func loadData() {
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

extension CountriesList: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expandableCell", for: indexPath) as! TableViewCell
        let section = indexPath.section
        let row = indexPath.row
        let region = Array(countriesByRegion.values)[section]
        let country = region[row]
        let imgURL = country.flags.png
        
        cell.countryFlag.downloaded(from: imgURL)
        cell.countryName.text = country.name.common
        cell.capitalCity.text = country.capital?.description
        
        // Configure the "Learn More" button action
        cell.learnMore.tag = indexPath.row
        cell.learnMore.addTarget(self, action: #selector(learnMoreButtonTapped(_:)), for: .touchUpInside)
        
        // Check if the cell should be expanded and show additional information
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
    
    @objc func learnMoreButtonTapped(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPosition) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showDetails", sender: indexPath)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CountryViewController,
           let indexPath = sender as? IndexPath {
            let section = indexPath.section
            let row = indexPath.row
            let region = Array(countriesByRegion.values)[section]
            let country = region[row]
            destination.country = country
        }
    }
}

extension CountriesList: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
            cell.bottomView.isHidden = !cell.bottomView.isHidden
            
            UIView.animate(withDuration: 0.3) {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        let region = Array(countriesByRegion.values)[section]
        let country = region[row]

        let baseHeight: CGFloat = 72.0 // Базовая высота ячейки без дополнительной информации
        let additionalHeight: CGFloat = 144.0 // Дополнительная высота при раскрытом состоянии

        if let selectedIndexPath = tableView.indexPathForSelectedRow, selectedIndexPath == indexPath {
            // Если ячейка выбрана, то возвращаем высоту с дополнительной информацией
            return baseHeight + additionalHeight
        } else {
            // Иначе возвращаем базовую высоту ячейки
            return baseHeight
        }
    }

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
}
