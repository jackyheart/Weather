//
//  WeatherListConfigurator.swift
//  Weather
//
//  Created by Jacky Tjoa on 24/9/24.
//

import UIKit

class WeatherListConfigurator {
    static func configure(_ viewController: ViewController) {
        let interactor = WeatherListInteractor()
        let presenter = WeatherListPresenter()
        let router = WeatherListRouter()
        let service = WeatherService()
        
        viewController.output = interactor
        interactor.output = presenter
        interactor.service = service
        presenter.output = viewController
        viewController.router = router
        router.viewController = viewController
    }
}
