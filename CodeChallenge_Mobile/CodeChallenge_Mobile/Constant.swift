//
//  Constant.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-26.
//  Copyright © 2020 abc. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher
import GoogleSignIn

class Constant {
    public static var current: Constant = Constant()
    
    var authentication: GIDAuthentication?
}

public let googleClientID = "699669699297-6aptfummt0h4uarfp5hr07q29r9gbkhr.apps.googleusercontent.com"
public let queryPart = "snippet,contentDetails"

enum StoryboardId: String {
    case main = "Main"
    
    case login = "LoginController"
    case playlist = "PlaylistController"
    case playlistDetails = "PlaylistDetailsController"
}

enum TableCell: String {
    case playlistCell = "PlaylistCell"
    case playlistDetailsCell = "PlaylistDetailsCell"
    case loadMoreCell = "LoadMoreCell"
}
