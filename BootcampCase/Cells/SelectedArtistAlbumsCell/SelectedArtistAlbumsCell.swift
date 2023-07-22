//
//  SelectedArtistAlbumsCell.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import UIKit

final class SelectedArtistAlbumsCell: UITableViewCell {
    static let identifier = "SelectedAlbumCell"
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak private var releaseDate: UILabel!
    @IBOutlet weak private var albumNameLabel: UILabel!
    @IBOutlet weak private var albumımageView: UIImageView!
    
    func configure(with model: SelectedArtistAlbums) {
        guard let name = model.title,
              let releaseDate = model.release_date,
              let pictureURL = model.cover,
              let url = URL(string: pictureURL) else {
            return
        }
        print(url)
        albumNameLabel.text = name
        albumımageView.sd_setImage(with: url, placeholderImage: nil, options: [], completed: nil)
    }
}
