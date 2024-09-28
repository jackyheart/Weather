//
//  DetailInteractor.swift
//  Weather
//
//  Created by Jacky Tjoa on 28/9/24.
//

protocol DetailInteractorDelegate {
    func onViewLoaded()
}

class DetailInteractor: DetailInteractorDelegate {
    var repository: WeatherRepositoryDelegate?
    var presenter: DetailPresenterDelegate?
    
    func onViewLoaded() {
        
    }
}
