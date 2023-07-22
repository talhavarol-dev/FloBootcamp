//
//  ArtistListVC.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import UIKit

final class ArtistListVC: UIViewController, ArtistListViewModelDelegate {
   
    @IBOutlet weak private var collectionView: UICollectionView!
    var viewModel = ArtistListViewModel()
    var categoryID: Int? {
        didSet {
            guard let id = categoryID else {
                print("categoryID is nil")
                return
            }
            viewModel.fetchArtists(for: id)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ArtistListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ArtistListCollectionViewCell.identifier)
    }
    func didFetchArtistsSuccessfully() {
        collectionView.reloadData()
    }
    
    func didFailFetchingArtists(with error: Error) {
        print(error)
    }
}

extension ArtistListVC: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.artists.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistListCollectionViewCell.identifier, for: indexPath) as! ArtistListCollectionViewCell
        cell.configure(with: viewModel.artists[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artist = viewModel.artists[indexPath.row]
        let artistAlbumsVC = UIStoryboard(name: "SelectedArtistAlbums", bundle: nil)
        let vc = artistAlbumsVC.instantiateViewController(identifier: "SelectedArtistVCV") as! SelectedArtistVC
        vc.artistID = artist.id
        vc.title =  artist.name
        vc.artistImageUrl = artist.picture
        vc.hidesBottomBarWhenPushed = false // Add this line to hide the TabBarController
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ArtistListVC: UICollectionViewDelegateFlowLayout{
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
