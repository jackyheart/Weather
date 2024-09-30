//
//  DetailConfigurator.swift
//  Weather
//
//  Created by Jacky Tjoa on 28/9/24.
//

final class DetailConfigurator {
    static func configure(_ viewController: DetailViewController) {
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let repository = WeatherRepository()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.repository = repository
        presenter.view = viewController
    }
}
