//
//  NoInternetView.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/30/22.
//
import Lottie
import UIKit

class NoInternetView: UIView {

    var retryTapped: (() -> Void)?
    
    lazy var animationView: LottieAnimationView = {
        let animationView: LottieAnimationView = LottieAnimationView(name: "retryLotte")

         // 3. Set animation content mode
         animationView.contentMode = .scaleAspectFit
         
         // 4. Set animation loop mode
         animationView.loopMode = .loop
         
         // 5. Adjust animation speed
         animationView.animationSpeed = 0.5
         
         self.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
       
        return animationView
    }()
    
    var retryButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Retry", for: .normal)
        btn.layer.cornerRadius = 12
        btn.backgroundColor = .systemBlue
        btn.layer.borderWidth = 2
        btn.setTitleColor(.white, for: .normal)
        
        return btn
    }()
    
    lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "Something went wrong!"
        return label
    }()
    
    lazy var labelDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "An alien probably blocking your signal."
        label.textColor = .lightGray
        label.textAlignment = .center

        return label
    }()
    
     override init(frame: CGRect) {
         super.init(frame: frame)
         setupView()
     }

     required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    private func setupView() {
        addSubview(retryButton)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([retryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
         retryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                                     retryButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
                                     retryButton.heightAnchor.constraint(equalToConstant: 50)])
        
        retryButton.addTarget(self, action: #selector(retryTap), for: .touchUpInside)
        
        let topStack = UIStackView(arrangedSubviews: [labelTitle, labelDescription])
        topStack.axis = .vertical
        topStack.distribution = .fill
        topStack.alignment = .fill
        topStack.spacing = 8
        topStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topStack)
        NSLayoutConstraint.activate([topStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                                     topStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                                     topStack.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 24),
                                     topStack.bottomAnchor.constraint(lessThanOrEqualTo: retryButton.topAnchor, constant: -24)])
        
        animationView.play()
        
        NSLayoutConstraint.activate([animationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                                     animationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                                     
                                     animationView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24)])
        
        self.backgroundColor = UIColor.white //UIColor(named: ColorConstants.whiteColor)

    }
    
    func stopAnimation() {
        animationView.stop()
    }
    
    @objc func retryTap() {
        retryTapped?()
    }

}
