//
//  UIViewController+LoadingHUD.swift
//  CP1PhotoViewer
//
//  Created by g.shu on 2018/05/21.
//  Copyright © 2018 Yuan Zhou. All rights reserved.
//

import UIKit
import MBProgressHUD

/// A UIViewController extension that provides the ability to show and hide a loading HUD in asynchronous process.
extension UIViewController {
    
    func showLoadingHUD(view: UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "Loading..."
    }
    
    func hideLoadingHUD(view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
