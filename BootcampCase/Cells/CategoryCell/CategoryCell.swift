//
//  CategoryCell.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import UIKit
import SDWebImage
final class CategoryCell: UICollectionViewCell {
    
    static let identifier = "CategoryCell"
    
    @IBOutlet weak private var categoryNameLabel: UILabel!
    @IBOutlet weak private var categoryImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: Category) {
        guard let name = model.name,
              let pictureURL = model.picture,
              let url = URL(string: pictureURL) else {
            return
        }
        categoryNameLabel.text = name
        categoryImageView.sd_setImage(with: url, placeholderImage: nil, options: [], completed: nil)
    }
}
