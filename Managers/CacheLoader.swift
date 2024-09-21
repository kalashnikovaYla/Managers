//
//  CacheLoader.swift
//  Managers
//
//  Created by Юлия  on 21.09.2024.
//

import Foundation

final class CacheLoader {
    
    static let shared = CacheLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    ///Загрузка изображения по URL
    func downloadImage(url: URL, completion: @escaping (Result<Data, Error>)->Void) {
        let key = url.absoluteString as NSString
        
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data ))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let key = url.absoluteString as NSString
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}

