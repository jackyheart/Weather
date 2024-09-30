//
//  SearchConfigurator.swift
//  Weather
//
//  Created by Jacky Tjoa on 24/9/24.
//

final class SearchConfigurator {
    static func configure(_ viewController: SearchViewController) {
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        let repository = WeatherRepository()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.repository = repository
        interactor.router = router
        presenter.view = viewController
        router.view = viewController
    }
}
