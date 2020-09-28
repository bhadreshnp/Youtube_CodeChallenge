//
//  RootCoordinator.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-26.
//  Copyright © 2020 abc. All rights reserved.
//

import Foundation

class RootCoordinator {
    
    static var shared: RootCoordinator = RootCoordinator()
    
    private(set) lazy var loginCoordinator: LoginCoordinator = {
        let coordinator = LoginCoordinator()
        return coordinator
    }()
    
    private(set) lazy var playlistCoordinator: PlaylistCoordinator = {
        let coordinator = PlaylistCoordinator()
        return coordinator
    }()
    
    func start() {
        appDelegate().window?.rootViewController = loginCoordinator.rootViewController
    }
}
