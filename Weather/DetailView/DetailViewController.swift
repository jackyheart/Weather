//
//  DetailViewController.swift
//  Weather
//
//  Created by Jacky Tjoa on 28/9/24.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func displayResult(result: WeatherCondition)
}

class DetailViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var degreeCelciusLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    var interactor: DetailInteractor?
    var dataItem: ResultItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = dataItem?.areaName.first?.value
        interactor?.onViewLoaded(withDataItem: dataItem)
    }
}

extension DetailViewController: DetailViewControllerDelegate {
    
    func displayResult(result: WeatherCondition) {
        
    }
}
