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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wtr")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let gokartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gokart")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var frontLeftTire: UITextField = {
        let field = UITextField()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.backgroundColor = .red
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(gokartImageView)
        scrollView.addSubview(logOutButton)
        scrollView.addSubview(userDataLabel)
        
        logOutButton.addTarget(self, action: #selector(logOutTap), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
       validateAuth()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        imageView.frame = CGRect(x: 0,
                                 y: 20,
                                 width: size,
                                 height: size/2)
        gokartImageView.frame = CGRect(x: (size/2) - 70,
                                 y: imageView.bottom + 20,
                                 width: 150,
                                 height: size/2)
        
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

