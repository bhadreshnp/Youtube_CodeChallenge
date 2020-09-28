//
//  PlaylistController.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-25.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

protocol PlaylistControllerDelegate: class {
    func goToPlaylistDetailController(playlist: GTLRYouTube_Playlist)
}

class PlaylistController: UIViewController {
    
    private enum PlaylistTableLayout {
        case loaded(numberOfPlaylist: Int, showLoadMore: Bool)
        
        enum Section {
            case load(numberOfPlaylist: Int)
            case loadMore
            
            enum Row {
                case playlist
                case loadMore
            }
            
            var rows: [Row] {
                switch self {
                case .load(let totalPlaylist):
                    var rows: [Row] = []
                    rows.append(contentsOf: Array(repeating: .playlist, count: totalPlaylist))
                    return rows
                    
                case .loadMore:
                    return [.loadMore]
                }
            }
        }
        
        var sections: [Section] {
            switch self {
            case .loaded(let totalPlaylist, let showLoadMore):
                var sections: [Section] = []
                sections.append(.load(numberOfPlaylist: totalPlaylist))
                if showLoadMore {
                    sections.append(.loadMore)
                }
                return sections
            }
        }
    }
    
    @IBOutlet weak var tableview: UITableView!
    weak var delegate: PlaylistControllerDelegate?
    
    private var viewModel = PlaylistViewModel()
    private var layout: PlaylistTableLayout {
        let playlistItems = viewModel.listOfPlaylist.count
        let showLoadMore = playlistItems != viewModel.totalPlaylist
        
        return .loaded(numberOfPlaylist: playlistItems,
                       showLoadMore: showLoadMore)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        viewModel.stateChangeHandler = stateChangeHandler
        loadPlaylist()
    }
    
    private func loadPlaylist() {
        viewModel.fetchPlaylistList()
    }
    
    private func stateChangeHandler(_ state: PlaylistViewModel.LoadingState) {
        switch state {
        case .notLoaded, .error:
            // show error alert here
            break
            
        case .loading:
            // show loading indicator
            break
            
        case .loaded:
            tableview.reloadData()
        }
    }
}

extension PlaylistController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return layout.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layout.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = layout.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row {
        case .playlist:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.playlistCell.rawValue, for: indexPath) as! PlaylistCell
            
            let playlist = viewModel.listOfPlaylist[indexPath.row]
            let config = PlaylistCellConfig(title: playlist.snippet?.title,
                                            count: playlist.contentDetails?.itemCount?.intValue,
                                            imageUrlString: playlist.snippet?.thumbnails?.defaultProperty?.url)
            cell.configure(with: config)
            return cell
            
        case .loadMore:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.loadMoreCell.rawValue, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        
        let section = layout.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row {
        case .playlist:
            let playlist = viewModel.listOfPlaylist[indexPath.row]
            delegate?.goToPlaylistDetailController(playlist: playlist)
            
        case .loadMore:
            viewModel.fetchNextPage()
        }
    }
}
