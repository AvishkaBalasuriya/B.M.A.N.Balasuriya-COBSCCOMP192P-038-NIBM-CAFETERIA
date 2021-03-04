//
//  LoginViewController.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-02.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblRegister: UILabel!
    @IBOutlet weak var lblForgetPassword: UILabel!
    
    var firebaseService=FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardHider()
        addTapFunctions()
    }
    
    @IBAction func loginUser(_ sender: Any) {
        self.firebaseService.loginUser(emailAddress:txtEmailAddress.text!,password: txtPassword.text!)
        {(result:Int?)->Void in
            if(result==1){
                let storePageViewController = self.storyboard?.instantiateViewController(withIdentifier:"StorePageView") as? StorePageViewController
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationItem.leftBarButtonItem=nil
                self.navigationItem.hidesBackButton=true
                self.navigationController?.pushViewController(storePageViewController!, animated: true)
            }else if(result==2){
                self.showAlert(title: "Oops!", message: "Email is already registered")
            }else if(result==3){
                self.showAlert(title: "Oops!", message: "Username or password is incorrect")
            }else if(result==0){
                self.showAlert(title: "Oops!", message: "An error occures while registering")
            }
        }
    }

    @objc func registerTapFunction(sender:UITapGestureRecognizer) {
        let registerViewController = storyboard?.instantiateViewController(withIdentifier:"RegisterView") as? RegisterViewController
        self.navigationItem.leftBarButtonItem=nil
        self.navigationItem.hidesBackButton=true
        self.navigationController?.pushViewController(registerViewController!, animated: true)
    }
    
    @objc func forgetPasswordTapFunction(sender:UITapGestureRecognizer) {
        let forgetPasswordViewController = storyboard?.instantiateViewController(withIdentifier:"ForgetPasswordView") as? ForgetPasswordViewController
        self.navigationItem.leftBarButtonItem=nil
        self.navigationItem.hidesBackButton=true
        self.navigationController?.pushViewController(forgetPasswordViewController!, animated: true)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func addKeyboardHider(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func addTapFunctions(){
        let registerTap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.registerTapFunction))
        lblRegister.isUserInteractionEnabled = true
        lblRegister.addGestureRecognizer(registerTap)
        
        let forgetPasswordTap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.forgetPasswordTapFunction))
        lblForgetPassword.isUserInteractionEnabled = true
        lblForgetPassword.addGestureRecognizer(forgetPasswordTap)
    }
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
