//
//  SongListVC.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import UIKit
import AVFoundation
import CoreData

final class SongListVC: UIViewController, SongListViewModelDelegate {
    var albumID: Int? {
        didSet {
            viewModel.albumID = albumID
        }
    }
    private var viewModel = SongListViewModel()
    
    @IBOutlet weak private var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectedAlbumSongsCell", bundle: nil), forCellReuseIdentifier: SelectedAlbumSongsCell.identifier)
        viewModel.fetchData()
        viewModel.delegate = self
    }
    func didUpdateData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func didReceiveError(error: String) {
        print(error)
    }
    func playAudio(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        viewModel.audioPlayer = AVPlayer(playerItem: playerItem)
        viewModel.audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: .main) { [weak self] time in
            if time.seconds >= 30 {
                self?.viewModel.stopAudio()
            }
        }
        viewModel.audioPlayer?.play()
        tableView.reloadData()
    }

    func addTrackToFavorites(track: Track, coverURL: String?) {
        let favoriteTrack = NSEntityDescription.insertNewObject(forEntityName: "FavoriModel", into: CoreDataManager.shared.context) as! FavoriModel
        favoriteTrack.id = Int64(track.id ?? 0)
        favoriteTrack.title = track.title
        favoriteTrack.coverURL = coverURL
        CoreDataManager.shared.saveContext()
    }
    func isTrackAlreadyFavorited(track: Track) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriModel> = FavoriModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", track.id ?? 0)
        
        do {
            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Error checking favorite:", error)
            return false
        }
    }
}

extension SongListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedAlbumSongsCell.identifier) as! SelectedAlbumSongsCell
        cell.delegate = self
        if let track = viewModel.mergedData?.tracks?.data?[indexPath.row],
           let albumCoverUrl = viewModel.mergedData?.cover_medium {
            cell.configure(with: track, albumCoverURL: albumCoverUrl)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let urlString = viewModel.mergedData?.tracks?.data?[indexPath.row].preview,
           let url = URL(string: urlString) {
            playAudio(url: url)
        }
    }
}
extension SongListVC: SelectedAlbumSongsCellDelegate {
    func didTapFavoriteButton(track: Track) {
        if isTrackAlreadyFavorited(track: track) {
            print("This track is already favorited!")
            return
        }
        if let albumCoverUrl = viewModel.mergedData?.cover_medium {
            addTrackToFavorites(track: track, coverURL: albumCoverUrl)
        }
        tableView.reloadData()
    }
    
    func didRemoveFavoriteButton(track: Track) {
        let fetchRequest: NSFetchRequest<FavoriModel> = FavoriModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", track.id ?? 0)
        
        do {
            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
            if let objectToDelete = results.first {
                CoreDataManager.shared.context.delete(objectToDelete)
                CoreDataManager.shared.saveContext()
            }
        } catch {
            print("Error removing favorite:", error)
        }
        tableView.reloadData()
    }}
