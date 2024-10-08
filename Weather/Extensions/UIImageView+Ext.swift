//
//  UIImageView+Ext.swift
//  Weather
//
//  Created by Jacky Tjoa on 28/9/24.
//

import UIKit

extension UIImageView {
    func load(urlString: String?) {
        guard let urlString = urlString, 
                let url = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
