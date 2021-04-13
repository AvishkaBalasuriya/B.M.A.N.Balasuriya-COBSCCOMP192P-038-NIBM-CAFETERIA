//
//  ForgetPasswordViewController.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-02.
//

import UIKit

class ForgetPasswordViewController: UIViewController {
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var lblLoginTap: UILabel!

    var firebaseService=FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardHider()
        addTapFunctions()
    }

    @IBAction func resetPassword(_ sender: Any) {
        self.firebaseService.forgetPassword(emailAddress:txtEmailAddress.text!)
        {(result:Int?)->Void in
            if(result==200){
                self.showAlert(title: "Success", message: "Password reset link sent to your email")
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier:"LoginView") as? LoginViewController
                self.navigationController?.pushViewController(loginViewController!, animated: true)
            }else if(result==401){
                self.showAlert(title: "Oops!", message: "Invalid email address")
            }else if(result==500){
                self.showAlert(title: "Oops!", message: "An error occures while registering")
            }
        }
    }
    
    @objc func loginTapFunction(sender:UITapGestureRecognizer) {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier:"LoginView") as? LoginViewController
        self.navigationItem.leftBarButtonItem=nil
        self.navigationItem.hidesBackButton=true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.pushViewController(loginViewController!, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addKeyboardHider(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addTapFunctions(){
        let loginTap = UITapGestureRecognizer(target: self, action: #selector(ForgetPasswordViewController.loginTapFunction))
        lblLoginTap.isUserInteractionEnabled = true
        lblLoginTap.addGestureRecognizer(loginTap)
    }

}
