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
    private let kWeatherCell = "weatherCell"
    private let emptyView = SearchEmptyView()
    private var dataArray: [SearchCellModel] = []
    private var filteredArray: [SearchCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchConfigurator.configure(self)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.onViewWillAppear()
    }
    
    private func setupUI() {
        searchBar.placeholder = "Search for a city"
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: kWeatherCell)
        tableView.dataSource = self
        tableView.delegate = self
        self.title = "Search"
    }
}

extension SearchViewController: SearchViewDelegate {
    func displayResultList(_ results: [SearchCellModel]) {
        dataArray = results
        filteredArray = results
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
        if filteredArray.count == 0 {
            tableView.backgroundView = emptyView
        } else {
            tableView.backgroundView = nil
        }
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kWeatherCell, for: indexPath)
        let data = filteredArray[indexPath.row]
        cell.textLabel?.text = data.displayText
        cell.detailTextLabel?.text = data.noteText
        cell.detailTextLabel?.textColor = data.noteTextColor
        return cell
    }
}

//MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor?.didSelectItem(onIndex: indexPath.row)
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.onSearchTextEntered(withSearchString: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        interactor?.didPressSearch(withSearchString: searchText)
    }
}
