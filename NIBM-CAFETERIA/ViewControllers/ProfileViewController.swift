//
//  ProfileViewController.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-05.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblEmail.text=UserData.emailAddress
        lblMobileNumber.text=UserData.mobileNumber
    }
}
