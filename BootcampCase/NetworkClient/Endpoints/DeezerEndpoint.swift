//
//  DeezerEndpoint.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import Foundation

enum AdvertEndpoint {
    case categoryList
    case artistList(id: Int)
    case selectedArtistAlbums(id: String)
    case selectedAlbumSongs(id: String)
}

extension AdvertEndpoint: Endpoint {
   
    var header: [String : String]? {
        return nil
    }
  //  /api.deezer.com/genre
    var path: String {
        switch self {
        case .categoryList:
            return "/genre"
        case .artistList(let id):
            return "/genre/\(id)/artists"
        case .selectedArtistAlbums(let id):
            return "/artist/\(id)/albums"
        case .selectedAlbumSongs(let id):
            return "/album/\(id)"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .categoryList, .artistList, .selectedArtistAlbums, .selectedAlbumSongs:
            return .get
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .categoryList, .artistList, .selectedArtistAlbums,.selectedAlbumSongs:
            return nil
        }
    }
    var params: [String: Any]? {
          switch self {
          case .categoryList:
              return nil
          case .artistList(let id):
              return ["id": id]
          case .selectedArtistAlbums(let id):
              return ["id": id]
          case .selectedAlbumSongs(let id):
              return ["id": id]
          }
      }
}
