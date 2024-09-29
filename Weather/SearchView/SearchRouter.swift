//
//  SearchRouter.swift
//  Weather
//
//  Created by Jacky Tjoa on 24/9/24.
//

import UIKit

protocol SearchRouterDelegate {
    func navigateToDetailScreen(withDataItem dataItem: ResultItem?)
}

final class SearchRouter: SearchRouterDelegate {
    weak var view: (UIViewController & SearchViewDelegate)?
    
    func navigateToDetailScreen(withDataItem dataItem: ResultItem?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController")
                as? DetailViewController else {
            return
        }
        detailVC.dataItem = dataItem
        view?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
