//
//  RegisterViewController.swift
//  MessegeApp
//
//  Created by Izuchukwu Dennis on 13.09.2021.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    private var scrollview: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .green
//        scrollView.layer.cornerRadius = 100
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFit
        //        imageView.layer.cornerRadius =  2.0
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage(tapGestureRecognizer:)))
        imageView.addGestureRecognizer(gesture)
        
        
        //        print(imageView.gestureRecognizers)
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
    
    private let firstNameField: UITextField = {
        let textfield = UITextField()
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.returnKeyType = .continue
        textfield.layer.cornerRadius = 12
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.placeholder = "Enter first name..."
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textfield.leftViewMode = .always
        textfield.backgroundColor = .white
        return textfield
    }()
    
    private let lastNameField: UITextField = {
        let textfield = UITextField()
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.returnKeyType = .continue
        textfield.layer.cornerRadius = 12
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.placeholder = "Enter last name..."
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textfield.leftViewMode = .always
        textfield.backgroundColor = .white
        return textfield
    }()
    
    private let registerButton: UIButton = {
        let button  = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = .link
        button.setTitle("Register", for: .normal)
        //        button.setTitle("cool", for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .link
        title = "Register"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        passwordField.delegate = self
        emailField.delegate = self
        addsubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2.0
    }
    
    @objc private func didTapImage(tapGestureRecognizer: UITapGestureRecognizer) {
        print("didTapImage")
        presentActionSheet()
        
    }
    
    @objc private func didTapRegister(){
        print("register tapped")
        
        //        navigationController?.pushViewController(registerViewController, animated: true)
    }
    @objc private func didTapRegisterButton() {
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        guard let email = emailField.text,
              let password = passwordField.text,
              let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else{
            alertUser()
            return
        }
        //        firebaselogin
        
        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
            
            guard let strongSelf = self else {
                return
            }
            guard !exists else {
                //                User already exist
                strongSelf.alertUser(message: "User with this email address already exists")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
                guard authDataResult != nil, error == nil else {
                    print("Error registering user\(error!)")
                    return
                }
                let messageAppUser = MessageAppUser(firstName: firstName,
                                                    lastName: lastName,
                                                    emailAddress: email)
                DatabaseManager.shared.insertUser(with: messageAppUser, completion: {(success) in
                    guard success else {
                        return
                    }
                    //Upload immage
                    guard let image = strongSelf.profileImageView.image, let data = image.pngData() else{
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
                })
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
            
            
            
        }
    }
    
    private func alertUser(message: String = "Please make sure you correctly entered your details") {
        
        let alert  = UIAlertController(title: "Ooops",
                                       message: message,
                                       preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func addsubviews(){
        view.addSubview(scrollview)
        scrollview.addSubview(emailField)
        scrollview.addSubview(profileImageView)
        scrollview.addSubview(passwordField)
        scrollview.addSubview(registerButton)
        scrollview.addSubview(firstNameField)
        scrollview.addSubview(lastNameField)
        addConstraints()
    }
    
    private func addConstraints(){
        scrollview.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().offset(0)
            make.bottomMargin.equalToSuperview()
            make.right.left.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
            //            print(profileImageView.frame.size.height + 10)
            make.topMargin.equalTo(emailField.frame.maxY).offset(20)
        }
        
        
        firstNameField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(view.frame.size.width/2)
            make.topMargin.equalTo(profileImageView.snp_bottomMargin).offset(30)
        }
        lastNameField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(view.frame.size.width/2)
            make.topMargin.equalTo(firstNameField.snp_bottomMargin).offset(30)
        }
        emailField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(view.frame.size.width/2)
            make.topMargin.equalTo(lastNameField.snp_bottomMargin).offset(30)
        }
        
        passwordField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(view.frame.size.width/2)
            make.topMargin.equalTo(emailField.snp_bottomMargin).offset(30)
        }
        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(view.frame.size.width/2)
            make.topMargin.equalTo(passwordField.snp_bottomMargin).offset(30)
        }
        
        
    }
    
}
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }else if textField == passwordField {
            didTapRegisterButton()
        }
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(info)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.profileImageView.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func presentActionSheet(){
        
        let actionsheet = UIAlertController(title: "Profile picture",
                                            message: "Please select a prefered upload method",
                                            preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionsheet.addAction(UIAlertAction(title: "Take photo",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                self?.presentCamera()
                                            }))
        actionsheet.addAction(UIAlertAction(title: "Upload from photos",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                self?.presentPhotoPicker()
                                            }))
        present(actionsheet, animated: true, completion: nil)
    }
    private func presentCamera(){
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    private func presentPhotoPicker(){
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

