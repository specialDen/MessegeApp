//
//  MainTabBarController.swift
//  MessegeApp
//
//  Created by Izuchukwu Dennis on 25.09.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let conversationControllers = UINavigationController(rootViewController: ActiveChatsViewController())
        let profileControllers = UINavigationController(rootViewController: ProfileViewController())
        setViewControllers([conversationControllers, profileControllers], animated: false)
        conversationControllers.title  = "Chats"
        profileControllers.title = "Profile"
        view.backgroundColor = .cyan
    }
    
    
}
