//
//  DeezerService.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import Foundation

protocol DeezerServicable {
    func getCategoryList() async -> Result<SongCategory, RequestError>
    func getArtistList(id: Int) async -> Result<ArtistsList, RequestError>
    func getArtistAlbums(id: String) async -> Result<SelectedArtistAlbum, RequestError>

}

struct DeezerService: HTTPClient, DeezerServicable {

    public static var shared = DeezerService()
    
    func getCategoryList() async -> Result<SongCategory, RequestError> {
        return await sendRequest(endpoint: AdvertEndpoint.categoryList, responseModel: SongCategory.self)
    }

    func getArtistList(id: Int) async -> Result<ArtistsList, RequestError>{
        return await sendRequest(endpoint: AdvertEndpoint.artistList(id: id), responseModel: ArtistsList.self)
    }
    func getArtistAlbums(id: String) async -> Result<SelectedArtistAlbum, RequestError>{
        return await sendRequest(endpoint: AdvertEndpoint.selectedArtistAlbums(id: id), responseModel: SelectedArtistAlbum.self)
    }
    func getAlbumSongs(id: String) async -> Result<AlbumDetail, RequestError>{
        return await sendRequest(endpoint: AdvertEndpoint.selectedAlbumSongs(id: id), responseModel: AlbumDetail.self)
    }
}
