//
//  SelectedArtistAlbumsModel.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import Foundation

struct SelectedArtistAlbums: Codable {
    let id: Int?
    let title: String?
    let link: String?
    let cover: String?
    let cover_small: String?
    let cover_medium: String?
    let cover_big: String?
    let cover_xl: String?
    let release_date: String?
}

struct SelectedArtistAlbum: Codable {
    let data: [SelectedArtistAlbums]?
}

