//
//  AlbumDetailModel.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import Foundation
struct AlbumDetail: Codable {
    let id: Int?
    let title: String?
    let upc: String?
    let link: String?
    let share: String?
    let cover: String?
    let cover_small: String?
    let cover_medium: String?
    let cover_big: String?
    let cover_xl: String?
    let md5_image: String?
    let genre_id: Int?
    let genres: GenreList?
    let label: String?
    let nb_tracks: Int?
    let duration: Int?
    let fans: Int?
    let release_date: String?
    let record_type: String?
    let available: Bool?
    let tracklist: String?
    let explicit_lyrics: Bool?
    let explicit_content_lyrics: Int?
    let explicit_content_cover: Int?
    let contributors: [Contributor]?
    let artist: Artist?
    let type: String?
    let tracks: TrackList?
}

struct GenreList: Codable {
    let data: [Genre]?
}

struct Genre: Codable {
    let id: Int?
    let name: String?
    let picture: String?
    let type: String?
}

struct Contributor: Codable {
    let id: Int?
    let name: String?
    let link: String?
    let share: String?
    let picture: String?
    let picture_small: String?
    let picture_medium: String?
    let picture_big: String?
    let picture_xl: String?
    let radio: Bool?
    let tracklist: String?
    let type: String?
    let role: String?
}

struct TrackList: Codable {
    let data: [Track]?
}

struct Track: Codable {
    let id: Int?
    let readable: Bool?
    let title: String?
    let title_short: String?
    let title_version: String?
    let link: String?
    let duration: Int?
    let rank: Int?
    let explicit_lyrics: Bool?
    let explicit_content_lyrics: Int?
    let explicit_content_cover: Int?
    let preview: String?
    let md5_image: String?
}
