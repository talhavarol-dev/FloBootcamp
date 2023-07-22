//
//  CategoryListViewModel.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import Foundation

protocol CategoryListViewModelDelegate: AnyObject{
    func didFetchCategories()
    func didFailFetchingCategories(with error: Error)
}

final class CategoryListViewModel {
    weak var delegate: CategoryListViewModelDelegate?
    
    var categories: [Category] = []
    
    func fetchCategories() {
        Task(priority: .background) {
            let result = await DeezerService.shared.getCategoryList()
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self?.categories += data
                    }
                    self?.delegate?.didFetchCategories()
                case .failure(let error):
                    self?.delegate?.didFailFetchingCategories(with: error)
                }
            }
        }
    }
}
