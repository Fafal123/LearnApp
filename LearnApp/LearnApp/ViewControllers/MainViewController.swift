//
//  ViewController.swift
//  LearnApp
//
//  Created by Rafal Snarski on 31/05/2022.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {

    private var user: String = ""
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private var userDataInput: UITextField = {
        let field = UITextField()
        field.placeholder = "test"
        field.layer.borderWidth = 1
        return field
    }()
    
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("LogOut", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        return button
    }()
    
    private let userDataLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let outputDataLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.backgroundColor = .red
       
        view.addSubview(scrollView)

        scrollView.addSubview(logOutButton)
        scrollView.addSubview(userDataLabel)
        scrollView.addSubview(userDataInput)
        
        
        logOutButton.addTarget(self, action: #selector(logOutTap), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
       validateAuth()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screen = UIScreen.main.bounds
        let screenWidth = screen.width
        print("size \(screenWidth)")
        
        scrollView.frame = view.bounds
        
        let size = view.width
        userDataLabel.frame = CGRect(x: 0,
                                y: 40,
                             width: size,
                            height: 20)
        logOutButton.frame = CGRect(x: size - 75,
                                     y: 40,
                                  width: 70,
                                 height: 25)
        outputDataLabel.frame = CGRect(x: 10, y: userDataLabel.bottom + 50, width: screenWidth - 20, height: 150)
        userDataInput.frame = CGRect(x: 10, y: 250,  width: screenWidth - 20, height: 100)
        
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        } else {
          Auth.auth().addStateDidChangeListener { auth, user in
                guard let user = user else {
                    return
                }
                self.userDataLabel.text = user.email
                self.user = user.email ?? ""
            }
        }
    }
    
    @objc private func logOutTap() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
        catch {
           print("Failed to log out")
        }
    }
}

