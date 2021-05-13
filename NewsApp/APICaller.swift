//
//  APICaller.swift
//  NewsApp
//
//  Created by Mert Ergul on 13.05.2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=tr&category=general&apiKey=931bb2bfa8ec452dba7d65b4c9b92b71")
    }
    
    private init (){}
    
    public func getTopStories(completion: @escaping (Result<[Article],Error>)->Void){
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(APIResponce.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

//Models

struct APIResponce: Codable {
    let articles: [Article]
}

struct Article: Codable {
    
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
