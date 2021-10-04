//
//  LoginViewController.swift
//  MessegeApp
//
//  Created by Izuchukwu Dennis on 13.09.2021.
//

import UIKit
import SnapKit
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD


class LoginViewController: UIViewController {
    let registerViewController = RegisterViewController()
    private let spinner = JGProgressHUD(style: .dark)
    
    private var scrollview: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .green
        return scrollView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon")
        imageView.contentMode = .scaleAspectFit
        //        imageView.layer.cornerRadius = 40
        //        imageView.clipsToBounds = true
        //        print(imageView.gestureRecognizers?.count)
        return imageView
    }()
    
    
    private let emailField: UITextField = {
        let textfield = UITextField()
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.returnKeyType = .continue
        textfield.layer.cornerRadius = 12
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.placeholder = "Enter email address..."
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textfield.leftViewMode = .always
        textfield.backgroundColor = .white
        return textfield
    }()
    
    private let passwordField: UITextField = {
        let textfield = UITextField()
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.returnKeyType = .done
        textfield.layer.cornerRadius = 12
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.placeholder = "Enter password..."
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textfield.leftViewMode = .always
        textfield.backgroundColor = .white
        textfield.isSecureTextEntry = true
        //        textfield.rightView = UIView(frame: CGRect(x: textfield.frame.width - 10, y: 0, width: 10, height: 35))
        //        textfield.rightViewMode = .always
        return textfield
    }()
    
    private let logInButton: UIButton = {
        let button  = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = .link
        button.setTitle("Log In", for: .normal)
        //        button.setTitle("cool", for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        return button
    }()
    
    
    
    //
    private let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        button.layer.cornerRadius = 12
        button.permissions = ["email", "public_profile"]
        //        button.frame = CGRect(x: 0, y: 0, width: 207, height: 40)
        return button
    }()
    
    private let googleLoginButton:GIDSignInButton = {
        let button = GIDSignInButton()
        //        button.layer.cornerRadius = 12
        //        button.permissions = ["email", "public_profile"]
        //        button.frame = CGRect(x: 0, y: 0, width: 207, height: 40)
        button.addTarget(self, action: #selector(didTapGoogleLogin), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .link
        title = "Login"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        logInButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        passwordField.delegate = self
        emailField.delegate = self
        facebookLoginButton.delegate = self
        
        addsubviews()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        facebookLoginButton.layer.cornerRadius = 12
        //        googleLoginButton.frame = CGRect(x: 30, y: 200, width: 120, height: 50)
        //        googleLoginButton.center = scrollview.center
        addConstraints()
        //        googleLoginButton.frame.origin = CGPoint(x: 30, y: 60)
    }
    
    
    @objc private func didTapRegister(){
        print("register tapped")
        
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @objc private func didTapLogin() {
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else{
            alertUser()
            return
        }
        //        firebaselogin
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authDataResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authDataResult, error == nil else {
                print("failed to log in user with error: \(error!)")
                return
            }
            
//            let user = result.user
            
            UserDefaults.standard.set(email, forKey: "email")
            
            print("user logged in: \(result.user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func alertUser() {
        
        let alert  = UIAlertController(title: "Ooops", message: "Please make sure you corectly entered your details", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
    private func addsubviews(){
        view.addSubview(scrollview)
        scrollview.addSubview(emailField)
        scrollview.addSubview(logoImageView)
        scrollview.addSubview(passwordField)
        scrollview.addSubview(logInButton)
        scrollview.addSubview(facebookLoginButton)
        scrollview.addSubview(googleLoginButton)
        
    }
    private func addConstraints(){
        scrollview.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().offset(0)
            make.bottomMargin.equalToSuperview()
            make.right.left.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
            //            print(logoImageView.frame.size.height + 10)
            make.topMargin.equalTo(emailField.frame.maxY).offset(20)
        }
        emailField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(view.frame.size.width/2)
            make.topMargin.equalTo(logoImageView.snp_bottomMargin).offset(30)
        }
        
        passwordField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(view.frame.size.width/2)
            make.topMargin.equalTo(emailField.snp_bottomMargin).offset(30)
        }
        logInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(view.frame.size.width/2)
            make.topMargin.equalTo(passwordField.snp_bottomMargin).offset(30)
        }
        facebookLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(view.frame.size.width/2)
            //            print("width = \(view.frame.size.width/2)")
            make.topMargin.equalTo(logInButton.snp_bottomMargin).offset(30)
        }
        googleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(view.frame.size.width/2)
            //            print("width = \(view.frame.size.width/2)")
            make.topMargin.equalTo(facebookLoginButton.snp_bottomMargin).offset(30)
        }
        
        
    }
    
    
    
    
}
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }else if textField == passwordField {
            didTapLogin()
        }
        return true
    }
}




//bug - doesnt redraw views after rotating phone


extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("Failed to log in user to facebook")
            return
        }
        let facebookRequest  = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                          parameters: ["fields" : "email, first_name, last_name, picture.type(large)"],
                                                          tokenString: token,
                                                          version: nil,
                                                          httpMethod: .get)
        facebookRequest.start { graphRequestConnecting, result, error in
            guard let result = result as? [String: Any],
                  error == nil else {
                      print("failed to make facebook graph request")
                      return
                  }
            
            print(result)
            guard let firstName = result["first_name"] as? String,
                  let lastName = result["last_name"] as? String,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String: Any],
                  let data = picture["data"] as? [String: Any],
                  let pictureUrl = data["url"] as? String
            else {
                print("failed to make get email and name as string")
                return
            }
            //            let nameComponents = userName.components(separatedBy: " ")
            //            guard nameComponents.count == 2 else {
            //                return
            //            }
            //            let firstName = nameComponents[0]
            //            let lastName = nameComponents[1]
            
            UserDefaults.standard.set(email, forKey: "email")
            
            DatabaseManager.shared.userExists(with: email) { exists in
                if !exists {
                    let messageAppUser = MessageAppUser(firstName: firstName,
                                                        lastName: lastName,
                                                        emailAddress: email)
                    DatabaseManager.shared.insertUser(with: messageAppUser, completion: {(success) in
                        if success{
                            guard let url = URL(string: pictureUrl)else{
                                return
                            }
                            URLSession.shared.dataTask(with: url) { data, _, _ in
                                guard let data = data else {
                                    return
                                }
                                //Upload immage
                                let fileName = messageAppUser.profilePictureFilename
                                StorageManager.shared.uploadPrifilePicture(with: data, fileName: fileName) { result in
                                    switch result {
                                    case .success(let downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case .failure(let error):
                                        print("Storage manager error: \(error)")
                                    }
                                }
                            }.resume()
                        }
                    })
                }
            }
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        fireBaseLogin(with: credential)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        
    }
    
    
}

//MARK: - Handle google Sign in

extension LoginViewController {
    
    @objc private func didTapGoogleLogin(){
        //        GoogleSignIn.GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) {[weak self] user, error in
        //
        //
        //            // If sign in succeeded, display the app's main content View.
        //          }
        
        
        guard let clientID = FirebaseApp.app()?.options.clientID
        else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GoogleSignIn.GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [weak self] user, error in
            
            
            guard error == nil, let strongSelf = self else {
                
                return
            }
            //            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            //
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            guard let email = user?.profile?.email,
                  let firstName = user?.profile?.givenName,
                  let lastName = user?.profile?.familyName else {
                      print("can't find email")
                      return
                  }
            
            UserDefaults.standard.set(email, forKey: "email")
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            strongSelf.fireBaseLogin(with: credential)
            DatabaseManager.shared.userExists(with: email) { exists in
                if !exists {
                    let messageAppUser = MessageAppUser(firstName: firstName,
                                                        lastName: lastName,
                                                        emailAddress: email)
                    DatabaseManager.shared.insertUser(with: messageAppUser, completion: {(success) in
                        if success {
                            
                            //Upload immage
                            if let userHasImage = user?.profile?.hasImage {
                                if userHasImage {
                                    guard let url = user?.profile?.imageURL(withDimension: 200) else {
                                        return
                                    }
                                    URLSession.shared.dataTask(with: url) { data, _, _ in
                                        guard let data = data else {
                                            return
                                        }
                                    
                                    let fileName = messageAppUser.profilePictureFilename
                                    StorageManager.shared.uploadPrifilePicture(with: data, fileName: fileName) { result in
                                        switch result {
                                        case .success(let downloadUrl):
                                            UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                            print(downloadUrl)
                                        case .failure(let error):
                                            print("Storage manager error: \(error)")
                                        }
                                    }
                                    }.resume()
                                }
                            }
                            
                            
                            
                        }
                    })
                }
            }
            
            // ...
        }
        
        
    }
    
    private func fireBaseLogin(with credential:  AuthCredential ){
        spinner.show(in: view)
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authDataResult, error in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard authDataResult != nil, error == nil else{
                print("Google credential login failed, MFA maybe needed with error: \n \(String(describing: error))")
                return
            }
            
            print("Successfully logged user in")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    
    
}
