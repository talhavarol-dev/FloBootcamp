//
//  SelectedArtistAlbums.swift
//  BootcampCase
//
//  Created by Muhammet  on 22.07.2023.
//

import UIKit
import SDWebImage

final class SelectedArtistVC: UIViewController, SelectedArtistViewModelDelegate {
 
    @IBOutlet weak private var tableView: UITableView!
    
    var artistID: Int?
    var artistImageUrl: String?
    var viewModel = SelectedArtistViewModel()
    private let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadArtistImage()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectedArtistAlbumsCell", bundle: nil), forCellReuseIdentifier: SelectedArtistAlbumsCell.identifier)
        viewModel.delegate = self
        guard let artistID = artistID else { return }
        viewModel.fetchAlbums(for: artistID)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 250))
        artistImageView.frame = headerView.bounds
        headerView.addSubview(artistImageView)
        tableView.tableHeaderView = headerView
        tableView.frame = view.bounds
    }
    func didFetchAlbumsSuccessfully() {
        tableView.reloadData()
    }
    
    func didFailFetchingAlbums(with error: Error) {
        print(error)
    }
    
    private func loadArtistImage() {
        if let artistImageUrl = artistImageUrl {
            let url = URL(string: artistImageUrl)
            artistImageView.sd_setImage(with: url, placeholderImage: nil, options: [], completed: nil)
        }
    }
}

extension SelectedArtistVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedArtistAlbumsCell.identifier) as! SelectedArtistAlbumsCell
        cell.configure(with: viewModel.albums[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.albums[indexPath.row]
        let artistListVC = UIStoryboard(name: "SongList", bundle: nil)
        let vc = artistListVC.instantiateViewController(identifier: "SongListViewController") as! SongListVC
        vc.title = category.title
        vc.albumID = category.id
        
        vc.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

