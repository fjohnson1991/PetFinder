//
//  SignInViewController.swift
//  PetFinderAPI
//
//  Created by Felicity Johnson on 10/28/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let ref = FIRDatabase.database().reference().root
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInButton(_ sender: AnyObject) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                
            } else if let user = FIRAuth.auth()?.currentUser {
                AnimalDataStore.displayName(email: email)
                self.performSegue(withIdentifier: "loginSuccess", sender: self)
            }
        }
    }
    
    
    @IBAction func signUpButton(_ sender: AnyObject) {
        guard let email = emailTextField.text, !email.isEmpty else { print("Email is empty"); return }
        guard let password = passwordTextField.text, !password.isEmpty else { print("Password is empty"); return }

        if email != "" && password != "" {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    self.ref.child("users").child((user?.uid)!).setValue(email)
                    AnimalDataStore.displayName(email: email)
                    self.performSegue(withIdentifier: "loginSuccess", sender: self)
                } else {
                    if error != nil {
                        self.checkError(error: error!)
                    }
                }
            })
        }
    }
    
    
    
    func checkError(error: Error) {
        if let errCode = FIRAuthErrorCode(rawValue: error._code) {
            switch errCode {
            case .errorCodeEmailAlreadyInUse:
                print("email exists")
                self.presentAlertWithTitle(title: "Oops!", message: "That email already exists")
                break
            case .errorCodeInvalidEmail:
                print("invalid email")
                self.presentAlertWithTitle(title: "Oops!", message: "Invalid email")
                break
            default:
                break
                
            }
        }
    }

    
    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSuccess" {
            _ = segue.destination as! SelectedTableViewController
        }
    }
}

