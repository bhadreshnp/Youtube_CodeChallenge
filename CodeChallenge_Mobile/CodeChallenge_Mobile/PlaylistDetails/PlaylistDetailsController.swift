//
//  PlaylistDetailsController.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-25.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

protocol PlaylistDetailsControllerDelegate: class {
    func didSelectVideo()
}

class PlaylistDetailsController: UIViewController {
    
    private enum PlaylistDetailsTableLayout {
        case loaded(numberOfVideos: Int, showLoadMore: Bool)
        
        enum Section {
            case load(numberOfVideos: Int)
            case loadMore
            
            enum Row {
                case video
                case loadMore
            }
            
            var rows: [Row] {
                switch self {
                case .load(let totalVideos):
                    var rows: [Row] = []
                    rows.append(contentsOf: Array(repeating: .video, count: totalVideos))
                    return rows
                    
                case .loadMore:
                    return [.loadMore]
                }
            }
        }
        
        var sections: [Section] {
            switch self {
            case .loaded(let totalVideos, let showLoadMore):
                var sections: [Section] = []
                sections.append(.load(numberOfVideos: totalVideos))
                if showLoadMore {
                    sections.append(.loadMore)
                }
                return sections
            }
        }
    }
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var playlistThumbnailImageView: UIImageView!
    @IBOutlet weak var totalVideos: UILabel!
    
    weak var delegate: PlaylistDetailsControllerDelegate?
    
    private var viewModel = PlaylistDetailsViewModel()
    private var layout: PlaylistDetailsTableLayout {
        let numberOfVideos = viewModel.listOfVideos.count
        let showLoadMore = numberOfVideos != viewModel.totalVideos
        
        return .loaded(numberOfVideos: numberOfVideos, showLoadMore: showLoadMore)
    }
    
    var playlist: GTLRYouTube_Playlist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        setupUI()
        
        viewModel.stateChangeHandler = stateChangeHandler
        
        viewModel.playlistId = playlist.identifier
        loadPlaylist()
    }
    
    func setupUI() {
        title = playlist.snippet?.title
        playlistThumbnailImageView.setImage(from: playlist.snippet?.thumbnails?.high?.url, contentMode: .scaleAspectFit)
        if let count = playlist.contentDetails?.itemCount?.intValue {
            totalVideos.text = "Total videos: \(count)"
        }
    }
    
    private func loadPlaylist() {
        viewModel.fetchPlaylist()
    }
    
    private func stateChangeHandler(_ state: PlaylistDetailsViewModel.LoadingState) {
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

extension PlaylistDetailsController: UITableViewDataSource, UITableViewDelegate {
    
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
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.playlistDetailsCell.rawValue, for: indexPath) as! PlaylistDetailsCell
            
            let video = viewModel.listOfVideos[indexPath.row]
            let config = PlaylistDetailsCellConfig(title: video.snippet?.title,
                                                   author: "",
                                                   minute: "",
                                                   imageUrlString: video.snippet?.thumbnails?.defaultProperty?.url)
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
        case .video:
//            let playlist = viewModel.listOfPlaylist[indexPath.row]
            delegate?.didSelectVideo()
            
        case .loadMore:
            viewModel.fetchNextPage()
        }
    }
}
