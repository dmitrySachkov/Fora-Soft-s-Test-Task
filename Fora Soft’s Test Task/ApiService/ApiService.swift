//
//  ApiService.swift
//  Fora Soft’s Test Task
//
//  Created by Dmitry Sachkov on 07.01.2021.
//

import Foundation

class ApiService {
    
    private var dataTask: URLSessionDataTask?
    
    //MARK: - Get albums data
    func getSearchResultData(url: String, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        
        guard let urlString = URL(string: url) else { return }
        
        //MARK: - URLSession
        dataTask = URLSession.shared.dataTask(with: urlString) { (data, response, error) in
            
           //Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            guard let response  = response as? HTTPURLResponse else {
                //Handle Error
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            guard let data = data else {
                print("Empty Data")
                return
            }
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(SearchResult.self, from: data)
               //Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            }
            catch let error {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
    
    //MARK: - Get image data
    func getImageAlbum(url: String, completion: @escaping ((Data) -> Void)) {
        guard let urlString = URL(string: url) else { return }
        URLSession.shared.dataTask(with: urlString) { (data, response, error) in
            //Handle Error
            if let error = error {
                print("Data Task Error: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                guard let data = data else { return}
                completion(data)
            }
        }.resume()
    }    
}

