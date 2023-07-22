//
//  CategoryListViewModel.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//
import Foundation

protocol ArtistListViewModelDelegate: AnyObject {
    func didFetchArtistsSuccessfully()
    func didFailFetchingArtists(with error: Error)
}

final class ArtistListViewModel {
    
    weak var delegate: ArtistListViewModelDelegate?
    
    var artists: [Artist] = []
    
    func fetchArtists(for categoryId: Int) {
        Task(priority: .background) {
            let result = await DeezerService.shared.getArtistList(id: categoryId)
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self?.artists.append(contentsOf: data)
                    }
                    self?.delegate?.didFetchArtistsSuccessfully()
                case .failure(let error):
                    self?.delegate?.didFailFetchingArtists(with: error)
                }
            }
        }
    }
}
