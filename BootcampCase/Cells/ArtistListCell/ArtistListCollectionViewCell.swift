//
//  ArtistListCollectionViewCell.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import UIKit

final class ArtistListCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ArtistCell"
    
    @IBOutlet weak private var artistImageView: UIImageView!
    @IBOutlet weak private var artistNameLabel: UILabel!
    
    func configure(with model: Artist) {
        guard let name = model.name,
              let pictureURL = model.picture,
              let url = URL(string: pictureURL) else {
              
            return
        }
        print(url)
        artistNameLabel.text = name
        artistImageView.sd_setImage(with: url, placeholderImage: nil, options: [], completed: nil)
    }
}
