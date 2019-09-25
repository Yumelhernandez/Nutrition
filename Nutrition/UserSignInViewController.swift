//
//  UserSignInViewController.swift
//  Nutrition
//
//  Created by Yumel Hernandez on 3/17/19.
//  Copyright © 2019 Yumel Hernandez. All rights reserved.
//

import UIKit
import Firebase

class UserSignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var switching: UISegmentedControl!
    @IBOutlet weak var done: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        number.delegate = self
       // number.addDoneButtonToKeyboard(myAction: #selector(self.number.resignFirstResponder))
        password.delegate = self
        
        
        // Do any additional setup after loading the view.
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
    }

    

    @IBAction func switchTapped (_ sender: UISegmentedControl) {
       
        if switching.selectedSegmentIndex == 0 {
            print("Stay on this page")
        } else if switching.selectedSegmentIndex == 1 {
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let main_viewController = storyboard.instantiateViewController(withIdentifier: "PopUp")
            self.present(main_viewController, animated: true, completion: nil)
            
            
        }
    }
    
    
    
    

    
    
    @IBAction func doneTapped(_ sender: Any) {
        if number.text == "" || password.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide both an email and a password")
        } else {
            
            if let number = number.text {
                if let password = password.text {
                    
                   if switching.selectedSegmentIndex == 0 {  //signin
                        
                        Auth.auth().signIn(withEmail: number, password: password) { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                            } else {
                                
                                
                                if let email = Auth.auth().currentUser?.email {
                                    Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observe( .childAdded) { (snapshot) in
                                        
                                   
                                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let main_viewController = storyboard.instantiateViewController(withIdentifier: "sucess")
                                        self.present(main_viewController, animated: true, completion: nil)
                                        
                                        
                                    }}
                                
                                
                                
                              
                            }
                        }
                        
                   }
//                   else if switching.selectedSegmentIndex == 1 {
//
//                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let main_viewController = storyboard.instantiateViewController(withIdentifier: "PopUp")
//                    self.present(main_viewController, animated: true, completion: nil)
//
//                    }
                    
                    
                }
            }
            
        } //else
    }
    
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
}










//                    if switching.selectedSegmentIndex == 0 { //signup
//                        Auth.auth().createUser(withEmail: number, password: password) { (user, error) in
//                            if user != nil {
//                                self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
//                            } else {
//                                print("Sign Up Success")
//                            }
//                        }
//
//                    }
