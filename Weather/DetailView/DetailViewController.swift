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
    @IBOutlet weak var degreeCelciusLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    var interactor: DetailInteractorDelegate?
    var dataItem: ResultItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailConfigurator.configure(self)
        self.title = dataItem?.areaName.first?.value
        interactor?.onViewLoaded(withDataItem: dataItem)
    }
}

extension DetailViewController: DetailViewControllerDelegate {
    
    func displayResult(result: DetailViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.cityLabel.text = result.city
            self?.countryLabel.text = result.country
            self?.degreeCelciusLabel.text = result.temperatureCelcius
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
