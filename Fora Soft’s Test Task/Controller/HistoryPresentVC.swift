//
//  HistoryPresentVC.swift
//  Fora Soft’s Test Task
//
//  Created by Dmitry Sachkov on 17.01.2021.
//

import UIKit
import RealmSwift

class HistoryPresentVC: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    
    private var apiService = ApiService()
    let realm = try! Realm()
    var searchResult = SearchResult()
    var albums = List<Results>()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        setupCollectionView()
        
    }
    
    //MARK: - Collection View setup
    private func setupCollectionView() {
        self.collection.register(UINib(nibName: "AlbumsCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.reloadData()
    }
    
    //MARK: - Get data
    private func setupSearchResult() {
        albums = searchResult.results
    }
}

//MARK: - add Collection View Delegate and Data Sourse
extension HistoryPresentVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlbumsCell
        let album = searchResult.results[indexPath.row]
        cell.albumName.text = album.artistName
        cell.albumName.text = album.collectionName
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
}
