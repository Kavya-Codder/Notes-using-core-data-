//
//  Extension.swift
//  ShoppingApp
//
//  Created by Sunil Developer on 05/01/23.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, hendler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: hendler)
        alertVC.addAction(ok)
        self.present(alertVC, animated: true, completion: nil)
    }
}
