//
//  ArtistListModel.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import Foundation

struct Artist: Codable {
    let id: Int?
    let name: String?
    let picture: String?
}

struct ArtistsList: Codable {
    let data: [Artist]?
}
