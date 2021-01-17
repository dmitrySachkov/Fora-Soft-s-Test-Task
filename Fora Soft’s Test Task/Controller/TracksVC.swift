//
//  TracksVC.swift
//  Fora Soft’s Test Task
//
//  Created by Dmitry Sachkov on 13.01.2021.
//

import UIKit
import RealmSwift


class TracksVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackCount: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var relieseDate: UILabel!

    let realm = try! Realm()
    var trackArray = [String]()
    private var apiService = ApiService()
    var collectionName = ""
    var nameArtist = ""
    var albumId = 0
    var countTrack = 0
    var dateRelese = ""
    var genderPrimName = ""
    var artUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getTrackList()
        getImage()
        albumName.text = collectionName
        artistName.text = nameArtist
        trackCount.text = "\(countTrack)"
        gender.text = genderPrimName
        relieseDate.text = dateRelese
        setupTableView()

    }
    
    //MARK: - Table View setup
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    //MARK: - Get track list
    private func getTrackList() {
        let urlString = "https://itunes.apple.com/lookup?id=\(albumId)&entity=song"
        apiService.getSearchResultData(url: urlString) { (results) in
            switch results {
            case .success(let listOff):
                let items = listOff.results
                for i in items {
                    let trackName = i.trackName
                    self.trackArray.append(trackName ?? "")
                    self.tableView.reloadData() 
                }
                print(self.trackArray)
            case .failure(let error):
                print("We have some error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Get Image
    private func getImage() {
        let urlString = artUrl
        apiService.getImageAlbum(url: urlString) { (image) in
            self.albumImage?.image = image
        }
    }
}

//MARK: - Table View Data Sourse and Delegate
extension TracksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = trackArray[indexPath.row]
        cell.textLabel?.text = track
        return cell
    }
}
