//
//  ViewController.swift
//  Weather
//
//  Created by Jacky Tjoa on 23/9/24.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func displayResultList(_ results: [SearchCellModel])
    func displayErrorAlert(error: Error?)
}

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var interactor: SearchInteractorDelegate?
    var router: SearchRouterDelegate?
    private let kWeatherCell = "weatherCell"
    private let emptyView = SearchEmptyView()
    private var dataArray: [SearchCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchConfigurator.configure(self)
        setupUI()
    }
    
    private func setupUI() {
        searchBar.placeholder = "Search for a city"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kWeatherCell)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SearchViewController: SearchViewDelegate {
    func displayResultList(_ results: [SearchCellModel]) {
        dataArray = results
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func displayErrorAlert(error: Error?) {
        DispatchQueue.main.async { [weak self] in
            let nsError = error as? NSError
            let message = nsError?.userInfo["message"] as? String
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self?.present(alert, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray.count == 0 {
            tableView.backgroundView = emptyView
        } else {
            tableView.backgroundView = nil
        }
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kWeatherCell, for: indexPath)
        let data = dataArray[indexPath.row]
        cell.textLabel?.text = data.displayText
        return cell
    }
}

//MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = dataArray[indexPath.row]
        interactor?.didSelectItem(with: cellData)
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, 
                   shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool {
        
        let currentText = searchBar.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if updatedText.count >= 3 {
        }
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        interactor?.onSearch(searchString: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            dataArray.removeAll()
            tableView.reloadData()
        }
    }
}
