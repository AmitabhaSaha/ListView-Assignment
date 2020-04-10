//
//  BaseViewController.swift
//  ListView-Assignment
//
//  Created by Amitabha Saha on 10/04/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showSpinner(_ message: String = "") {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = message
        }
    }
    
    func hideSpinner() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
