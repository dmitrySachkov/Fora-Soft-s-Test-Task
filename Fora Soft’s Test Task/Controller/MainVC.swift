//
//  MainVC.swift
//  Fora Soft’s Test Task
//
//  Created by Dmitry Sachkov on 07.01.2021.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    private var apiService = ApiService()
    
    var items: [SearchResult]? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
    }
    //MARK: - Search Bar setup
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }


}

extension MainVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&entity=album"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { (_) in
            self.apiService.getSearchResultData(url: urlString) { (results) in
                switch results {
                case .success(let listOff):
                    print(listOff.results)
                   
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

