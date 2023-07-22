//
//  SongCategoriesModel.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import Foundation


struct SongCategory: Codable {
    let data: [Category]?
}

struct Category: Codable {
    let id: Int?
    let name: String?
    let picture: String?
    let pictureMedium: String?

    enum CodingKeys: String, CodingKey {
        case id, name, picture
        case pictureMedium
      
    }
}
