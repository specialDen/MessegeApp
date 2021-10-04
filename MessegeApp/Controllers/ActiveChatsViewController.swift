//
//  ViewController.swift
//  MessegeApp
//
//  Created by Izuchukwu Dennis on 13.09.2021.
//

import UIKit
import SnapKit
import FirebaseAuth
import JGProgressHUD

class ActiveChatsViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        activeChatsTableView.delegate = self
        activeChatsTableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true

//        DatabaseManager.shared.test()
    }
    override func viewDidLayoutSubviews() {
//        configureNavBar()
//        composeNewConversationBarButton.target = self
//        composeNewConversationBarButton.action = #selector(didTapCompose)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        validateAuth()
        
        
//        composeNewConversationBarButton
//        (barButtonSystemItem: .compose, target: self, action: )
    }
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let loginViewController = LoginViewController()
            let navigationVC = UINavigationController(rootViewController: loginViewController)
            navigationVC.modalPresentationStyle = .fullScreen
            present(navigationVC, animated: false, completion: nil)
//            print("fjhbgvhjbh \(FirebaseAuth.Auth.auth().currentUser)")
        }
    }
    //MARK: - Setup NavigatioBar's Top Profile Image Button

    let leftBarButtonItem: UIBarButtonItem = {
       let button = UIBarButtonItem()
//        let profilePicture = UIImage()
//        profilePicture.images
//        button.image = UIImage(named: "onyii")
        button.title = ""
        button.tintColor = .blue
        button.image = UIImage(systemName: "gear")
        print("barbutton")
        return button
    }()
//    let composeNewConversationBarButton: UIBarButtonItem = {
//        let button = UIBarButtonItem()
////        button.tintColor = .blue
//        button.image = UIImage(systemName: "square.and.pencil")
//        print("barbutton")
//        return button
//    }()
    
    @objc private func didTapCompose() {
        let newChatVC = NewChatViewController()
        let navVC = UINavigationController(rootViewController: newChatVC)
        present(navVC, animated: true, completion: nil)
    }
    func configureNavBar(){
        navigationItem.title = "Chats"
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCompose))
    }
    //MARK: - SetupSearchBar
    let activeChatsSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barTintColor = .green
        return searchBar
    }()
    //MARK: - SetUp tableview

    let activeChatsTableView: UITableView = {
        let tableView = UITableView()
//        tableView.tintColor = .blue
//        tableView.isHidden = true
        tableView.register(ActiveChatsTableViewCell.self, forCellReuseIdentifier: ActiveChatsTableViewCell.reuseIdentifier)
        tableView.layer.cornerRadius = 20
//        tableView.delegate = ViewController.self
//        tableView.dataSource = ViewController.self
        return tableView
    }()
    
    //MARK: - Arrange Views in Stacks
    private lazy var mainStackView: UIStackView = {
        [activeChatsSearchBar, activeChatsTableView].toStackView(orientation: .vertical, distribution: .fill, spacing: 0)
    }()
    
    private func setupUI(){
        addSubViews()
        configureNavBar()
    }
    private func addSubViews(){
        view.addSubview(mainStackView)
//        view.addSubview(activeChatsSearchBar)
        setConstraints()
    }
    private func setConstraints(){
//        activeChatsTableView.snp.makeConstraints { make in
//            make.bottom.left.right.equalToSuperview()
//            make.top.equalToSuperview().offset(200)
//        }
//        activeChatsSearchBar.snp.makeConstraints { make in
//            make.leftMargin.rightMargin.equalToSuperview()
//            make.topMargin.equalTo(20)
//            make.bottomMargin.equalTo(-view.frame.maxY+200)
//
////            make.height.equalTo(60)
//        }
        mainStackView.snp.makeConstraints { make in
            make.topMargin.equalTo(0)
            make.bottomMargin.equalTo(-20)
            make.right.left.equalToSuperview()
        }
    }
    
    


}

//MARK: - Handle TableView

extension ActiveChatsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActiveChatsTableViewCell.reuseIdentifier, for: indexPath)
        cell.backgroundColor = .yellow
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80.0
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = "User 1"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
