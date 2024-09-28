//
//  DetailViewController.swift
//  Weather
//
//  Created by Jacky Tjoa on 28/9/24.
//

import UIKit

class DetailViewController: UIViewController {
    var dataItem: ResultItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = dataItem?.areaName.first?.value
    }
}
