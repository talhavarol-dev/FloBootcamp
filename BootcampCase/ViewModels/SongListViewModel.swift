//  BootcampCase

//  Created by Muhammet  on 22.07.2023.


import Foundation
import AVFoundation

protocol SongListViewModelDelegate: AnyObject {
    func didUpdateData()
    func didReceiveError(error: String)
    func playAudio(url: URL)
}


final class SongListViewModel {
    
    // MARK: - Properties
    var albumID: Int?
    var mergedData: AlbumDetail?
    var audioPlayer: AVPlayer?
    
    // MARK: - Delegate
    weak var delegate: SongListViewModelDelegate?
    
    // MARK: - Data Fetching
    func fetchData() {
        guard let albumID = self.albumID else { return }
        
        Task(priority: .background) { [weak self] in
            guard let self = self else { return }
            let result = await DeezerService.shared.getAlbumSongs(id: albumID.description)
            switch result {
            case .success(let response):
                self.mergedData = response
                self.delegate?.didUpdateData()                
            case .failure(let error):
                self.delegate?.didReceiveError(error: error.localizedDescription)
            }
        }
    }
    
    func track(at index: Int) -> Track? {
        return mergedData?.tracks?.data?[index]
    }
    
    func albumCoverURL() -> String? {
        return mergedData?.cover_medium
    }
    
    func didSelectRow(at index: Int) {
        if let urlString = track(at: index)?.preview, let url = URL(string: urlString) {
            delegate?.playAudio(url: url)
        }
    }
    
    // MARK: - Audio Functions
    func playAudio(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        
        audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: .main) { [weak self] time in
            if time.seconds >= 30 {
                self?.stopAudio()
            }
        }
        audioPlayer?.play()
    }
    
    func stopAudio() {
        audioPlayer?.pause()
        audioPlayer = nil
    }
    func numberOfRows() -> Int {
           return mergedData?.tracks?.data?.count ?? 0
       }
        
}
