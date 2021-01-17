//
//  HistoryVC.swift
//  Fora Soft’s Test Task
//
//  Created by Dmitry Sachkov on 13.01.2021.
//

import UIKit
import RealmSwift

class HistoryVC: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    let realm = try! Realm()
    var searchResult = [SearchResult]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(Realm.Configuration.defaultConfiguration.fileURL)
        getSearchResult()
        setupTableView()
    }
    //MARK: - Table View setup
    private func setupTableView() {
        self.table.delegate = self
        self.table.dataSource = self
        self.table.reloadData()
    }
    //MARK: - Load data to Realm
    private func getSearchResult() {
        let someResult = realm.objects(SearchResult.self)
        searchResult.append(contentsOf: someResult)
        print(searchResult)
    }

}

//MARK: - add Collection View Delegate and Data Sourse
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let result = searchResult[indexPath.row]
        cell.textLabel?.text = result.searchRequest
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(identifier: "HistoryPresentVC") as! HistoryPresentVC
        let request = searchResult[indexPath.row]
        
        vc.searchResult = request
        navigationController?.pushViewController(vc, animated: true)
    }
}
