//
//  SelectedAlbumSongsCell.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import UIKit
import SDWebImage
import CoreData

enum CellType {
    case songList
    case favoriList
}

protocol SelectedAlbumSongsCellDelegate: AnyObject {
    func didTapFavoriteButton(track: Track)
    func didRemoveFavoriteButton(track: Track)
}

final class SelectedAlbumSongsCell: UITableViewCell {
    var cellType: CellType = .songList
    
    @IBOutlet weak private var songFavButton: UIButton!
    @IBOutlet weak private var songName: UILabel!
    @IBOutlet weak private var songDate: UILabel!
    @IBOutlet weak private var songImage: UIImageView!
    static let identifier = "SelectedAlbumSongsCell"
    weak var delegate: SelectedAlbumSongsCellDelegate?
    var track: Track?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func songFavTapped(_ sender: UIButton) {
        if let track = track {
            if isTrackFavorited(track: track) {
                delegate?.didRemoveFavoriteButton(track: track)
            } else {
                delegate?.didTapFavoriteButton(track: track)
            }
            updateFavoriteButtonAppearance()
        }
        print("fav button tapped")
    }
    func updateFavoriteButtonAppearance() {
        if let track = self.track, isTrackFavorited(track: track) {
            songFavButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            songFavButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    func configure(with model: Track, albumCoverURL: String) {
        self.track = model
        guard let name = model.title,
              let url = URL(string: albumCoverURL) else {
            return
        }
        print("Track: \(model.title), Album Cover URL: \(albumCoverURL)")
        updateFavoriteButtonAppearance()
        print(url)
        songName.text = name
        songImage.sd_setImage(with: url, placeholderImage: nil, options: [], completed: nil)
    }
    func isTrackFavorited(track: Track) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriModel> = FavoriModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", track.id ?? 0)
        
        do {
            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
            return results.count > 0
        } catch {
            print("Error checking favorite status:", error)
            return false
        }
    }
}

extension SelectedAlbumSongsCell {
    func configureForFavorite(with model: FavoriModel) {
        self.songName.text = model.title
        if let coverURLString = model.coverURL, let coverURL = URL(string: coverURLString) {
            self.songImage.sd_setImage(with: coverURL, placeholderImage: nil, options: [], completed: nil)
            delegate?.didTapFavoriteButton(track: track!)
        }
        songFavButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
}
