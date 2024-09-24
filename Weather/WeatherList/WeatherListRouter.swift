//
//  WeatherListRouter.swift
//  Weather
//
//  Created by Jacky Tjoa on 24/9/24.
//

import UIKit

protocol WeatherListRouterDelegate {
    func navigateToDetailsScreen()
}

class WeatherListRouter: WeatherListRouterDelegate {
    weak var viewController: (UIViewController & WeatherListViewDelegate)?
    
    func navigateToDetailsScreen() {
    }
}
