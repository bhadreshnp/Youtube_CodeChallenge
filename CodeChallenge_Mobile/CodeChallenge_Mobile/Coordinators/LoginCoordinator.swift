//
//  LoginCoordinator.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-25.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class LoginCoordinator {
    
    public private(set) lazy var rootViewController: UINavigationController = {
        let controller = UINavigationController(rootViewController: loginController)
        controller.setNavigationBarHidden(true, animated: false)
        return controller
    }()
    
    public var loginController: LoginController {
        let loginController = UIStoryboard(name: StoryboardId.main.rawValue, bundle: nil)
            .instantiateViewController(withIdentifier: StoryboardId.login.rawValue) as! LoginController
        loginController.loginDelegate = self
        return loginController
    }
}

extension LoginCoordinator: LoginControllerDelegate {
    
    func goToPlaylistController() {
        let playlistRootVC = RootCoordinator.shared.playlistCoordinator.rootViewController
        appDelegate().window?.rootViewController = playlistRootVC
    }
}
