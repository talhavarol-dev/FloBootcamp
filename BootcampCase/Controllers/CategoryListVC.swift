//
//  CategoryListVC.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import UIKit

final class CategoryListVC: UIViewController, CategoryListViewModelDelegate {
 
    @IBOutlet weak private var collectionView: UICollectionView!
    
    private var viewModel = CategoryListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)
        viewModel.delegate = self
    }
    private func fetchData() {
        viewModel.fetchCategories()
    }
    func didFetchCategories() {
        collectionView.reloadData()
    }
    func didFailFetchingCategories(with error: Error) {
        print(error)
    }
}
extension CategoryListVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        cell.configure(with: viewModel.categories[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = viewModel.categories[indexPath.row]
        let artistListVC = UIStoryboard(name: "ArtistList", bundle: nil)
        let vc = artistListVC.instantiateViewController(identifier: "ArtistListViewController") as! ArtistListVC
        vc.categoryID = category.id
        vc.title = category.name
        vc.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension CategoryListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = collectionViewWidth / 2 // İki hücre sırasıyla
        let cellHeight: CGFloat = 180 // İstenilen yüksekliği belirtin
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 1
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
