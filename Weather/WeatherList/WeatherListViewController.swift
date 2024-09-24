//
//  ViewController.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

import UIKit

protocol WeatherListViewDelegate: AnyObject {
    func displayCityList()
}

class WeatherListViewController: UIViewController {
    let kWeatherCell = "weatherCell"
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var interactor: WeatherListInteractorDelegate?
    var router: WeatherListRouterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherListConfigurator.configure(self)
        setupUI()
    }
    
    private func setupUI() {
        searchBar.placeholder = "Search for a city"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kWeatherCell)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension WeatherListViewController: WeatherListViewDelegate {
    func displayCityList() {
    }
}

//MARK: - UITableViewDataSource

extension WeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kWeatherCell, for: indexPath)
        cell.textLabel?.text = "cell \(indexPath.row)"
        return cell
    }
}

//MARK: - UITableViewDataSource

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - UISearchBarDelegate

extension WeatherListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, 
                   shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool {
        
        let currentText = searchBar.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return true
    }
}
