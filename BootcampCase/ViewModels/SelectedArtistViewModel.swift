//
//  SelectedArtistViewModel.swift
//  BootcampCase

//
//  Created by Muhammet  on 22.07.2023.
//

import Foundation

protocol SelectedArtistViewModelDelegate: AnyObject {
    func didFetchAlbumsSuccessfully()
    func didFailFetchingAlbums(with error: Error)
}

final class SelectedArtistViewModel {
    
    weak var delegate: SelectedArtistViewModelDelegate?
    
    var albums: [SelectedArtistAlbums] = []
    
    func fetchAlbums(for artistId: Int) {
        Task(priority: .background) {
            let result = await DeezerService.shared.getArtistAlbums(id: String(artistId))
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self?.albums.append(contentsOf: data)
                    }
                    self?.delegate?.didFetchAlbumsSuccessfully()
                case .failure(let error):
                    self?.delegate?.didFailFetchingAlbums(with: error)
                }
            }
        }
    }
}

