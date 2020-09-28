//
//  PlaylistDetailsViewModel.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-26.
//  Copyright © 2020 abc. All rights reserved.
//

import GoogleAPIClientForREST

class PlaylistDetailsViewModel {
    
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
    private var playlistResponse: GTLRYouTube_PlaylistItemListResponse? {
        didSet {
            guard let response = playlistResponse,
                let items = response.items,
                let totalCount = response.pageInfo?.totalResults else { return }
            listOfVideos.append(contentsOf: items)
            totalVideos = totalCount.intValue
        }
    }
    var playlistId: String?
    var totalVideos: Int = 0
    var listOfVideos: [GTLRYouTube_PlaylistItem] = [] {
        didSet {
            saveIntoDatabase()
        }
    }
    var stateChangeHandler:((_ state: LoadingState) -> Void)?
    private var database: DatabaseHelper = DatabaseHelper()
    
    init() {
        ytService.authorizer = Constant.current.authentication?.fetcherAuthorizer()
    }
    
    private func saveIntoDatabase() {
        guard let playlistId = playlistId else {
            return
        }
        
        for video in listOfVideos {
            guard let videoId = video.contentDetails?.videoId else {
                return
            }
            // TODO: - Do not add row here, if it already exist in database table.
            database.insert(playlistId: playlistId, videoId: videoId)
        }
    }
    
    func fetchNextPage() {
        fetchPlaylist(with: playlistResponse?.nextPageToken)
    }
}

extension PlaylistDetailsViewModel {
    func fetchPlaylist(with nextPageToken: String? = nil) {
        state = .loading
        
        // TODO: - Fetch all videos of playlist from database, if it already exist in database table, instead of API call.
        
        let query = GTLRYouTubeQuery_PlaylistItemsList.query(withPart: queryPart)
        query.playlistId = playlistId
        if (nextPageToken != nil) {
            query.pageToken = nextPageToken
        }
        ytService.executeQuery(query) { (ticket, response, error) in
            
            if let error = error {
                print(error)
                self.state = .error
                return // show alert for error.
            }
            self.playlistResponse = response as? GTLRYouTube_PlaylistItemListResponse
            self.state = .loaded
        }
        
    }
}
