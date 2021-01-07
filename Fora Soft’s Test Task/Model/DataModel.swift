//
//  DataModel.swift
//  Fora Soft’s Test Task
//
//  Created by Dmitry Sachkov on 07.01.2021.
//

import Foundation


struct SearchResult: Decodable {
    var resultCount: Int
    var results: [Results]
}

struct Results: Decodable {
    var artistName: String
    var collectionName: String
    var collectionId: Int
    var artworkUrl100: String?
    var trackCount: Int
    var releaseDate: String
    var primaryGenreName: String
}
