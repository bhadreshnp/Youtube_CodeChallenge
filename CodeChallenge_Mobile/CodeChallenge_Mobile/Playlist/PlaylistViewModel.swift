//
//  PlaylistViewModel.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-25.
//  Copyright © 2020 abc. All rights reserved.
//

import GoogleAPIClientForREST

class PlaylistViewModel {
    
    enum LoadingState {
        case notLoaded
        case loading
        case loaded
        case error
    }
    
    private var state: LoadingState = .notLoaded {
        didSet {
            stateChangeHandler?(state)
        }
    }
    
    private var ytService = GTLRYouTubeService()
    private var playlistListResponse: GTLRYouTube_PlaylistListResponse? {
        didSet {
            guard let response = playlistListResponse,
                let items = response.items,
                let totalCount = response.pageInfo?.totalResults else { return }
            listOfPlaylist.append(contentsOf: items)
            totalPlaylist = totalCount.intValue
        }
    }
    
    var totalPlaylist: Int = 0
    var listOfPlaylist: [GTLRYouTube_Playlist] = []
    var stateChangeHandler:((_ state: LoadingState) -> Void)?
    
    init() {
        ytService.authorizer = Constant.current.authentication?.fetcherAuthorizer()
    }
    
    func fetchNextPage() {
        fetchPlaylistList(with: playlistListResponse?.nextPageToken)
    }
}

extension PlaylistViewModel {
    func fetchPlaylistList(with nextPageToken: String? = nil) {
        state = .loading
        
        let query = GTLRYouTubeQuery_PlaylistsList.query(withPart: queryPart)
        query.mine = true
        if (nextPageToken != nil) {
            query.pageToken = nextPageToken
        }
        ytService.executeQuery(query) { (ticket, response, error) in
            
            if let error = error {
                print(error)
                self.state = .error
                return // show alert for error.
            }
            self.playlistListResponse = response as? GTLRYouTube_PlaylistListResponse
            self.state = .loaded
        }
        
    }
}
