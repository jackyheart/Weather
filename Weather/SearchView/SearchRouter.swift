//
//  SearchRouter.swift
//  Weather
//
//  Created by Jacky Tjoa on 24/9/24.
//

import UIKit

protocol SearchRouterDelegate {
    func navigateToDetailsScreen()
}

class SearchRouter: SearchRouterDelegate {
    weak var viewController: (UIViewController & SearchViewDelegate)?
    
    func navigateToDetailsScreen() {
    }
}
