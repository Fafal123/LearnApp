//
//  RegisterViewController.swift
//  LearnApp
//
//  Created by Rafal Snarski on 31/05/2022.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    //create scrollView
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //a boolean that determines whether subviews are confined to the bounds of the view
        scrollView.clipsToBounds = true
        return scrollView
    }()
    //create imageView
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "First Name..."
        //this line add space before writing text in textField
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0 ))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Last Name..."
        //this line add space before writing text in textField
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0 ))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    //craete emailField
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address..."
        //this line add space before writing text in textField
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0 ))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Passowrd..."
        //this line add space before writing text in textField
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0 ))
        field.leftViewMode = .always
        field.backgroundColor = .white
        //write text security
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton: UIButton = {
       let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        //sublayer are clipped to layer's bounds
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        view.backgroundColor = .white
        //added item in barButton
       
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = view.width
        imageView.frame = CGRect(x: 0,
                                 y: 20,
                                 width: size,
                                 height: size/3)
        
        firstNameField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 10,
                                  width: scrollView.width - 60,
                                 height: 52)
        
        lastNameField.frame = CGRect(x: 30,
                                  y: firstNameField.bottom + 20,
                                  width: scrollView.width - 60,
                                 height: 52)
        
        emailField.frame = CGRect(x: 30,
                                  y: lastNameField.bottom + 10,
                                  width: scrollView.width - 60,
                                 height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                  width: scrollView.width - 60,
                                 height: 52)
        
        registerButton.frame = CGRect(x: 30,
                                     y: passwordField.bottom + 10,
                                  width: scrollView.width - 60,
                                 height: 52)
    }
    
    @objc private func registerButtonTapped() {
        guard let firstName = firstNameField.text,
                let lastName = lastNameField.text,
                let email = emailField.text,
                let password = passwordField.text,
                !email.isEmpty,
                !password.isEmpty,
                !firstName.isEmpty,
                !lastName.isEmpty,
                password.count >= 6 else {
            alertUserLoginError()
            return
        }
        // Firebase Log In
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
            guard let result = authResult, error == nil else {
                print("Error creating user")
                return
            }
            
            let user = result.user
            print("Created User: \(user)")
            self.navigationController?.popViewController(animated: true)
        })
        
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Proszę uzupełnić poprawnie wszystkie pola.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Zamknij", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            registerButtonTapped()
        }
        return true
    }
}

