//
//  WeatherListConfigurator.swift
//  Weather
//
//  Created by Jacky Tjoa on 24/9/24.
//

class WeatherListConfigurator {
    static func configure(_ viewController: WeatherListViewController) {
        let interactor = WeatherListInteractor()
        let presenter = WeatherListPresenter()
        let router = WeatherListRouter()
        let service = WeatherService()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.service = service
        presenter.view = viewController
        viewController.router = router
        router.viewController = viewController
    }
}
