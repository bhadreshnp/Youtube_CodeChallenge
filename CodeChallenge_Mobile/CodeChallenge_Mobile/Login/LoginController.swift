//
//  LoginController.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-25.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

protocol LoginControllerDelegate: class {
    func goToPlaylistController()
}

class LoginController: UIViewController {
    
    private enum LoadingState {
        case notLoaded
        case loading
        case loaded
        case error
    }
    
    private var state: LoadingState = .notLoaded {
        didSet {
            stateChangeHandler()
        }
    }
    
    // Can be used GIDSignInButton, for Google logo in button UI. but I'm using custom button.
    @IBOutlet weak var signInButton: UIButton!
    
    weak var loginDelegate: LoginControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Don't need to login everytime, when app launch.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        state = .loading
        
        // Asking permission to access youtube playlist.
        GIDSignIn.sharedInstance()?.scopes = [kGTLRAuthScopeYouTubeReadonly]
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    private func stateChangeHandler() {
        switch state {
        case .notLoaded, .error:
            // show error alert here
            break
            
        case .loading:
            // show loading indicator
            break
            
        case .loaded:
            loginDelegate?.goToPlaylistController()
        }
    }
    
}

extension LoginController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            state = .error
            return
        }
        
        Constant.current.authentication = user.authentication
        state = .loaded
    }
}
