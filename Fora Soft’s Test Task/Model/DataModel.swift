//
//  DataModel.swift
//  Fora Soft’s Test Task
//
//  Created by Dmitry Sachkov on 13.01.2021.
//

import Foundation
import RealmSwift

class SearchResult: Object, Codable {
    @objc dynamic var searchRequest: String?
    @objc dynamic var resultCount: Int = 0
    dynamic var results = List<Results>()
}

class Results: Object, Codable {
    @objc dynamic var artistName: String = ""
    @objc dynamic var collectionName: String = ""
    @objc dynamic var collectionId: Int = 0
    @objc dynamic var artworkUrl100: String?
    @objc dynamic var trackCount: Int = 0
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var primaryGenreName: String = ""
    @objc dynamic var trackName: String?
}
