//
//  NewChatViewController.swift
//  MessegeApp
//
//  Created by Izuchukwu Dennis on 28.09.2021.
//

import UIKit
import JGProgressHUD

class NewChatViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
    
    private var users = [[String: String]]()
    
    private var results = [[String: String]]()
    
    private var hasFetched = false
    
    private let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users..."
        return searchBar
    }()
    
    private let tableView:UITableView = {
        let tableview = UITableView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.isHidden = true
        return tableview
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "No results"
        label.textColor = .brown
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "NewChatViewController"
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapCancel))
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(noResultLabel)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        noResultLabel.frame = CGRect (x: view.frame.size.width/4,
                                      y: (view.frame.size.height-200)/4,
                                      width: view.frame.size.width/2 ,
                                      height: 200)
    }
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: - SeachBar Delegates

extension NewChatViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else{
            return
        }
        searchBar.resignFirstResponder()
        
        results.removeAll()
        spinner.show(in: view, animated: true)
        self.searchUsers(querry: text)
    }
    
    func searchUsers(querry: String){
        //        check if array has firebase results
        if hasFetched {
            //        if it does, filter
            filterUsers(with: querry)
            
        }else {
            //        if not, fetch then filter
            DatabaseManager.shared.getAllUsers { [weak self] result in
                switch result {
                case .success(let userCollection):
                    self?.hasFetched = true
                    self?.users = userCollection
                    self?.filterUsers(with: querry)
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            }
        }
        //        update the UI
    }
    
    func filterUsers(with term: String) {
        guard hasFetched else {
            return
        }
        self.spinner.dismiss(animated: true)
        let results :[[String: String]] = self.users.filter({
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            return name.hasPrefix(term.lowercased())
        })
        
        self.results = results
        
        updateUI()
    }
    
    func updateUI(){
        if results.isEmpty {
            self.noResultLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.noResultLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
}


//MARK: - TableView Delegates and DataSource

extension NewChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // start conversation
    }
    
}
