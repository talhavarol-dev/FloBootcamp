# FloBootcamp
# Müzik Dinleme Uygulaması
Deezer API den gelen müziklerin, 45 saniyelik denemekelerini dinletmektedir. Bu süreç uzatılabilir.

### Technologies
+ MVVM Architecture ✅ 
+ Storyboard and .xib ✅
+ Async/Await ✅ 
+ Generic URLSessions Layer ✅ 
+ CoreData ✅
+ CollectionView ✅
+ TableView ✅
+ SDWebImage ✅ 
+ Unit Test ✅ 

## Genel Yapı

Proje içerisinde, türkçe karakter kullanmamaya, class ve değişkenlerinlerin Acces Level düzeylerine oldukça dikkat ettim.
MVVM kullanırken, ViewModel içerisinden Protokol ve Delegate yapısı ile ViewController a geçiş yaptım.
Kullanıcıdan aldığım FAVORİ bilgisini CoreData üzerinde tuttum. 
Auto Layout konusunda StackView yapısı kullanmaya özen gösterdim. i
Uygulama içerisinde tek bir Storyboard dosyası üzerinde çalışılmamıştır. Her ekran ayrı bir Storyboard olacak şekilde tasarlanmış ve gerekli yerlerde XIB yapısı kullanılmıştır.
### Service
Servis yapısı olarak Generic URLSessions Async/Await yapısı kullanılmıştır.
```swift
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
```

### Protokol ve Delegate Yapısı ViewModel
```swift

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
```

### Access Level Örneği
```swift
final class ArtistListCollectionViewCell: UICollectionViewCell {
    //MARK: IBOutlets
    @IBOutlet weak private var artistImageView: UIImageView!
    @IBOutlet weak private var artistNameLabel: UILabel!
```

### Uygulama içerisinde "unwrapping" yapmamaya özen gösterim. Genel olarak Guard Let yapısını kullandım.
```swift
  func configure(with model: Track, albumCoverURL: String) {
        self.track = model
        guard let name = model.title,
        let url = URL(string: albumCoverURL) else {
          return
        }
    }
```

## Görseller
![Simulator Screenshot - iPhone 14 Pro - 2023-07-22 at 20 36 55_190x400](https://github.com/talhavarol-dev/FloBootcamp/assets/80515499/1d00cda2-b967-4a07-b5bf-b9d4d2557157)
![Simulator Screenshot - iPhone 14 Pro - 2023-07-22 at 20 37 08_190x400](https://github.com/talhavarol-dev/FloBootcamp/assets/80515499/5738e72a-108a-4056-a334-03ec1bae3558)
![Simulator Screenshot - iPhone 14 Pro - 2023-07-22 at 20 37 13_190x400](https://github.com/talhavarol-dev/FloBootcamp/assets/80515499/4fba751b-34ad-4b8d-8220-90fb9f3fbde0)
![Simulator Screenshot - iPhone 14 Pro - 2023-07-22 at 20 37 19_190x400](https://github.com/talhavarol-dev/FloBootcamp/assets/80515499/856bd006-9556-49c2-8fc0-b5f955649ab2)
![Simulator Screenshot - iPhone 14 Pro - 2023-07-22 at 20 37 32_190x400](https://github.com/talhavarol-dev/FloBootcamp/assets/80515499/4504714d-f5ce-4caf-8315-77da61140c12)

<img width="329" alt="Ekran Resmi 2023-07-22 20 49 43" src="https://github.com/talhavarol-dev/FloBootcamp/assets/80515499/9a85b44d-0ca2-4e4e-afba-e9fe4a754416">


