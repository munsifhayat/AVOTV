//
//  SplashViewController.swift
//  AVOTV
//
//  Created by Zeeshan Tariq on 02/09/2021.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 165, height: 165))
        imageView.image = UIImage.init(named: "logoSP")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
        
    }
    
    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.width * 2
            let diffX  = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(x: -(diffX/2), y: diffY/2, width: size, height: size)
            self.imageView.alpha = 0
        }, completion: { isAnimationCompleted in
            
            if isAnimationCompleted {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    if AppStateManager.shared.isUserLoggedIn {
                        Constants.APP_DELEGATE.loadHomeController()
                    }
                    else {
                        Constants.APP_DELEGATE.loadLogInController()
                    }
                })
            }
        })
        
    }
}
