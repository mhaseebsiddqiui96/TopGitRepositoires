//
//  UIViewExt.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/28/22.
//

import UIKit
import SkeletonView
import Lottie

//MARK: - Constraints
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


//MARK: - Shimmer Effect
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

//MARK: - No Internet View

extension UIView {
    
    static var noInternetViewTag = 123499
    
    @objc func showNoInternetView(retryTapped: @escaping () -> Void) {
        let animationView: NoInternetView = NoInternetView(frame: self.bounds)
        animationView.retryTapped = retryTapped
        animationView.backgroundColor = .systemBackground
        animationView.tag = UIView.noInternetViewTag
        
        animationView.frame = self.bounds
        
        
        animationView.contentMode = .scaleAspectFit
        
        
        self.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([animationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                                     animationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
                                     animationView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
                                     animationView.topAnchor.constraint(equalTo: topAnchor)])
        
        // 6. Play animation
        
    }
    
    @objc func hideNoInternetView() {
        let view = viewWithTag(UIView.noInternetViewTag) as? NoInternetView
        view?.stopAnimation()
        view?.removeFromSuperview()
    }
    
}


