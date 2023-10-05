//
//  UIImageView + Extension.swift
//  MyAppClothes
//
//  Created by gayeugur on 21.09.2023.
//

import Foundation
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        kf.indicatorType = .activity
        kf.setImage(with: resource)
    }
}
