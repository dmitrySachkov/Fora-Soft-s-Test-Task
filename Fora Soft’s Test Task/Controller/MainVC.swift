//
//  MainVC.swift
//  Fora Soft’s Test Task
//
//  Created by Dmitry Sachkov on 13.01.2021.
//

import UIKit
import RealmSwift

class MainVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    private var apiService = ApiService()
    let realm = try! Realm()
    var albums = List<Results>()
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupCollectionView()

    }
    //MARK: - Search Bar setup
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    //MARK: - Collection View setup
    private func setupCollectionView() {
        self.collectionView.register(UINib(nibName: "AlbumsCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    //MARK: - Load data to Realm
    private func loadSearchResult() {
        let someItems = realm.objects(SearchResult.self).last?.results
        albums = someItems!
        albums.sorted(byKeyPath: "collectionName", ascending: true)
        self.collectionView.reloadData()
    }
}

//MARK: - Search Bar
extension MainVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&entity=album"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { (_) in
            self.apiService.getSearchResultData(url: urlString) { (results) in
                switch results {
                case .success(let listOff):
                        do {
                            try self.realm.write() {
                                let newSearchResult = SearchResult()
                                newSearchResult.searchRequest = searchText
                                newSearchResult.results = listOff.results
                                self.realm.add(newSearchResult.self)
                            }
                            self.loadSearchResult()
                        } catch {
                            print("We have some error: \(error)")
                    }
                case .failure(let error):
                    //Show alert message in case of error
                    self.showAlertWith(title: "Could Not Connect!", message: "Please check your internet connection \n or try again later")
                    print("Error processing json data: \(error)")
                }
            }
        })
    }

    // MARK: - Alert message
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
//MARK: - add Collection View Delegate and Data Sourse
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlbumsCell
        let album = albums[indexPath.row]
        cell.albumName.text = album.collectionName
        cell.artistName.text = album.artistName
        apiService.getImageAlbum(url: album.artworkUrl100 ?? "") { (image) in
            cell.albumImage.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(identifier: "TracksVC") as! TracksVC
        let album = albums[indexPath.item]
        let id = album.collectionId
        vc.albumId = id
        let artist = album.artistName
        vc.nameArtist = artist
        let collection = album.collectionName
        vc.collectionName = collection
        let trackCount = album.trackCount
        vc.countTrack = trackCount
        let releaseDate = album.releaseDate
        vc.dateRelese = releaseDate
        let primaryGenreName = album.primaryGenreName
        vc.genderPrimName = primaryGenreName
        let artworkUrl100 = album.artworkUrl100
        vc.artUrl = artworkUrl100 ?? "https://landcraft.in/images/no-img.png"
        navigationController?.pushViewController(vc, animated: true)
    }
}
