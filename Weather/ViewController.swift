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

class ViewController: UIViewController {
    let kWeatherCell = "weatherCell"
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var output: WeatherListInteractorDelegate?
    var router: WeatherListRouterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherListConfigurator.configure(self)
        searchBar.placeholder = "Search for a city"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kWeatherCell)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: WeatherListViewDelegate {
    func displayCityList() {
    }
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
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

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, 
                   shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool {
        
        let currentText = searchBar.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        if updatedText.count < 3 {
            return false
        }
        return true
    }
    
    
}
