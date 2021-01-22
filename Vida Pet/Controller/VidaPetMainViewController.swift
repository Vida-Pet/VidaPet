//
//  VidaPetMainViewController.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 15/10/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit
import SCLAlertView

typealias EmptyClosure = () -> Void
class VidaPetMainViewController: UIViewController {
    
    let colorStyle = 0x26BABA
    let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
    }
    
}


// MARK - Loading Helper

extension VidaPetMainViewController {
    
    func setupLoadingIndicator() {
        indicator.color = R.color.vidaPetBlue()
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 120.0, height: 120)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
    }
    
    func loadingIndicator(_ action: LoadingAction) {
        switch action {
        case .start:
            self.view.isUserInteractionEnabled = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            indicator.startAnimating()
            
        case .stop:
            self.view.isUserInteractionEnabled = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            indicator.stopAnimating()
            
        }
        
    }

}

enum LoadingAction {
    case start
    case stop
}



// MARK: - Errors

extension VidaPetMainViewController {
    
    func displayError(_ error: String, withTryAgain tryAgainAction: EmptyClosure?) {
        print(error)
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton(R.string.main.error_try_again(), action: {
            tryAgainAction?()
        })
        alertView.addButton(R.string.main.error_cancel(), action: {})
        alertView.showError(R.string.main.error_title(), subTitle: R.string.main.error_description())
    }
}
