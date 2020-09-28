//
//  PlaylistCoordinator.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-25.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

class PlaylistCoordinator {
    
    public private(set) lazy var rootViewController: UINavigationController = {
        let controller = UINavigationController(rootViewController: playlistController)
        controller.navigationBar.isTranslucent = true
        return controller
    }()
    
    public var playlistController: PlaylistController {
        let playlistVC = UIStoryboard(name: StoryboardId.main.rawValue, bundle: nil)
            .instantiateViewController(withIdentifier: StoryboardId.playlist.rawValue) as! PlaylistController
        playlistVC.delegate = self
        return playlistVC
    }
}

extension PlaylistCoordinator: PlaylistControllerDelegate {
    
    func goToPlaylistDetailController(playlist: GTLRYouTube_Playlist) {
        let vc = UIStoryboard(name: StoryboardId.main.rawValue, bundle: nil)
            .instantiateViewController(withIdentifier: StoryboardId.playlistDetails.rawValue) as! PlaylistDetailsController
        vc.playlist = playlist
        rootViewController.show(vc, sender: nil)
    }
}
