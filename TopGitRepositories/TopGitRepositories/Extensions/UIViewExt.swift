//
//  UIViewExt.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/28/22.
//

import UIKit
import SkeletonView

public extension UIView {
 
    func addSubviewAndPinEdges(_ child: UIView) {
        addSubview(child)
        child.pinEdges(to: self)
    }

    func pinEdges(to other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: other.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.safeAreaLayoutGuide.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}


protocol Skeletonable: SkeletonTableViewDataSource {}

extension UIView {
    var canShimmer: Bool {
        set {
            isSkeletonable = newValue
        } get {
            return isSkeletonable
        }
    }
    
    func displayGradientAnimation() {
        self.showAnimatedGradientSkeleton()
    }
    
    func hideGradientAnimation() {
        self.stopSkeletonAnimation()
        self.hideSkeleton()
    }
}
