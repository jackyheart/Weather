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
        let repository = WeatherRepository()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.repository = repository
        presenter.view = viewController
        viewController.router = router
        router.viewController = viewController
    }
}
