//
//  DetailViewController.swift
//  Weather
//
//  Created by Jacky Tjoa on 28/9/24.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func displayResult(result: DetailViewModel)
    func displayErrorAlert(error: Error?)
}

class DetailViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var temperatureCelciusLabel: UILabel!
    @IBOutlet weak var celciusLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    var interactor: DetailInteractorDelegate?
    var dataItem: ResultItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailConfigurator.configure(self)
        resetValues()
        displayNavigationTitle()
        interactor?.onViewLoaded(withDataItem: dataItem)
    }
    
    private func resetValues() {
        self.cityLabel.text = ""
        self.countryLabel.text = ""
        self.temperatureCelciusLabel.text = ""
        self.celciusLabel.isHidden = true
        self.weatherImageView.image = nil
        self.weatherLabel.text = ""
    }
    
    private func displayNavigationTitle() {
        let city = dataItem?.areaName.first?.value ?? ""
        let country = dataItem?.country.first?.value ?? ""
        self.title = "\(city), \(country)"
    }
}

extension DetailViewController: DetailViewControllerDelegate {
    
    func displayResult(result: DetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.cityLabel.text = result.city
            self?.countryLabel.text = result.country
            self?.temperatureCelciusLabel.text = result.temperatureCelcius
            self?.celciusLabel.isHidden = false
            self?.weatherLabel.text = result.weatherDescription
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
