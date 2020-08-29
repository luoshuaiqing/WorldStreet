//
//  LoginViewController.swift
//  World Street
//
//  Created by Xueyin Chen on 6/13/20.
//  Copyright © 2020 Shuaiqing Luo. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {

    @IBOutlet weak var welcome: UILabel!
    
    @IBAction func loginTapped(_ sender: UIButton) {
        // Get the default auth UI object
        let authUI = FUIAuth.defaultAuthUI()

        guard authUI != nil else {
            return
        }

        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]

        let authViewController = authUI!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBAction func testButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "loginToHome", sender: self)
    }
    
}

extension UIViewController: FUIAuthDelegate {
    public func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        guard error == nil else {
            return
        }

        performSegue(withIdentifier: "loginToHome", sender: self)
    }
}
