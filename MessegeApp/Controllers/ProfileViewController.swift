//
//  ProfileViewController.swift
//  MessegeApp
//
//  Created by Izuchukwu Dennis on 25.09.2021.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
class ProfileViewController: UIViewController {
   
    private let data = ["Log Out"]
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(logOutButton)
        view.addSubview(tableView)
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        tableView.reloadData()
//        tableView.tableHeaderView?.imag
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        logOutButton.center = view.center
        tableView.frame = view.bounds
    }
    
    
    private let logOutButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        button.backgroundColor = .blue
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.setTitle("Log Out", for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)
        return button
    }()
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    //    private let topViewWithImage(){
    //
//    }
    
    @objc  private func didTapLogOut() {
        
        let alert = UIAlertController(title: "Confirm logout",
                                      message: "Are you sure you want to logout",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out",
                                      style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
//            Log out User from facebook
            FBSDKLoginKit.LoginManager().logOut()
            
//            Log out User from google
            GIDSignIn.sharedInstance.signOut()

            do{
                        try FirebaseAuth.Auth.auth().signOut()
                        let loginViewController = LoginViewController()
                        let navigationVC = UINavigationController(rootViewController: loginViewController)
                        navigationVC.modalPresentationStyle = .fullScreen
                strongSelf.present(navigationVC, animated: true, completion: nil)
                    }catch {
                        print("Failed to log out with error \(error)")
                    }

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
//    private let registerButton: UIButton = {
//        let button  = UIButton()
//        button.layer.cornerRadius = 12
//        button.backgroundColor = .link
//        button.setTitle("Register", for: .normal)
//        //        button.setTitle("cool", for: .highlighted)
//        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
//        return button
//    }()
}



extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.addSubview(logOutButton)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = .red
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .bold)
//        logOutButton.center = cell.center
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didTapLogOut()
    }
    
    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/" + filename
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300))
        headerView.backgroundColor = .gray
        
        let imageView = UIImageView(frame: CGRect(x: (headerView.frame.size.width - 150)/2,
                                                  y: 75,
                                                  width: 150,
                                                  height: 150))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        headerView.addSubview(imageView)
        
        StorageManager.shared.downloadUrl(for: path) {[weak self] result in
            switch result {
            case .success(let url):
                self?.downloadImage(imageView: imageView, url: url)
            case .failure(let error):
                print("Failed to get download URL: \(error)")
            }
        }

        return headerView
    }
    
    func downloadImage(imageView: UIImageView, url: URL){
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }.resume()
    }
}
