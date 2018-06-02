//
//  ViewController.swift
//  ActivityLog
//
//  Created by Shravan Sukumar on 28/05/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import UIKit

enum ValidationError: Error {
    case invalidPassoword
    case invalidEmail
    case empty
    
    func message() -> String {
        switch self {
        case .invalidPassoword:
            return "Password must be minimum 8 characters lenght."
        case .empty:
            return "All fields are mandatory."
        case .invalidEmail:
            return "Please check your email"
        }
    }
}

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    // MARK: - Variables
    var password: String!
    var email: String!
    var userName: String!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Sign In"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Private Methods
    private func validate() throws {
        if userName == nil || password == nil || email == nil {
            throw ValidationError.empty
        }
        if let email = email {
            if !email.isValidEmail() {
                throw ValidationError.invalidEmail
            }
        }
        if let password = password {
            if password.count < 8 {
                throw ValidationError.invalidPassoword
            }
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Okay", style: .default) { _ in }
        alert.addAction(okayButton)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        var isErrorCaught: Bool = false
        do { try validate() }
        catch (let error) {
            if let error = error as? ValidationError {
                isErrorCaught = true
                showAlert(error.message())
            }
        }
        if !isErrorCaught {
            let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "collectDetailsViewController") as! CollectDetailsViewController
            navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 0:
            userName = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        case 1:
            email = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        default:
            password = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        }
        return true
    }
}

