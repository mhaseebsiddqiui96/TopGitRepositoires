//
//  ImageExt.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/30/22.
//

import UIKit
import SDWebImage

extension UIImage {
    static var star: UIImage? {
        return UIImage(named: "img_star")
    }
}

extension UIImageView {
    func downLoadImage(with url: URL?) {
        sd_setImage(with: url)
    }
    
    func cancelDownload() {
        sd_cancelCurrentImageLoad()
    }
}
