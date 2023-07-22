//
//  FavoriListVC.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import UIKit
import CoreData

final class FavoriListVC: UIViewController {
    
    var favoriteTracks = [FavoriModel]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectedAlbumSongsCell", bundle: nil), forCellReuseIdentifier: SelectedAlbumSongsCell.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteTracks = CoreDataManager.shared.fetchFavoriteTracks()
        tableView.reloadData()
    }
}
extension FavoriListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedAlbumSongsCell.identifier) as! SelectedAlbumSongsCell
        let favoriteTrack = favoriteTracks[indexPath.row]
        cell.configureForFavorite(with: favoriteTrack)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
extension FavoriListVC: SelectedAlbumSongsCellDelegate {
    func didTapFavoriteButton(track: Track) {
        let fetchRequest: NSFetchRequest<FavoriModel> = FavoriModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", track.id ?? 0)
        do {
            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
            if let objectToDelete = results.first {
                CoreDataManager.shared.context.delete(objectToDelete)
                CoreDataManager.shared.saveContext()
                
                if let index = favoriteTracks.firstIndex(where: { $0.id == Int64(track.id ?? 0) }) {
                    favoriteTracks.remove(at: index)
                    tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                }
            }
        } catch {
            print("Error removing favorite:", error)
        }
    }
    func didRemoveFavoriteButton(track: Track) {
    }
}

