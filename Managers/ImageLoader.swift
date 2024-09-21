//
//  ImageLoader.swift
//  Managers
//
//  Created by Юлия  on 21.09.2024.
//

import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?

    ///Загружает изображение и сохраняет в URLCache + достает из URLCache
    func loadImage(from url: String) {
        guard let imageUrl = URL(string: url) else {
            return
        }

        let cache = URLCache.shared
        let request = URLRequest(url: imageUrl)

        if let cachedResponse = cache.cachedResponse(for: request) {
            if let image = UIImage(data: cachedResponse.data) {
                self.image = image
                return
            }
        }

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, let loadedImage = UIImage(data: data) else {
                return
            }
            let cachedData = CachedURLResponse(response: response!, data: data)
            cache.storeCachedResponse(cachedData, for: request)

            DispatchQueue.main.async {
                self?.image = loadedImage
            }
        }.resume()
    }
    
    ///Загружает изображение и записывает его в файлик + достает из FileManager
    func loadImageUseFileManager(from url: String) {
        let pathsToDocuments = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = pathsToDocuments[0]
        let imageName = url.replaceRegex(".*/", with: "")
        
        if let imageName = imageName {
            let imagePath = documentsDirectory + "/" + imageName
            if FileManager.default.isReadableFile(atPath: imagePath) {
                let image = UIImage(contentsOfFile: imagePath)
                if let image = image {
                    self.image = image
                } else {
                    downloadImage(url, saveAs: imageName)
                }
            } else {
                downloadImage(url, saveAs: imageName)
            }
        }
    }
    
    private func downloadImage(_ url: String, saveAs: String) {
        guard let imageURL = URL(string: url)
        else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL)
            else { return }

            let image = UIImage(data: imageData)
            if let image = image {
                self.image = image
                let pathsToDocuments = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentsDirectory = pathsToDocuments[0]
                let imagePath = documentsDirectory + "/" + saveAs
                do {
                    try imageData.write(to: URL(fileURLWithPath: imagePath))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension String {
    func replaceRegex(pattern: String, withString: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern,
                                                options: .caseInsensitive)
            let range = NSMakeRange(0,
                                    self.utf16.count)
            let replacedString = regex.stringByReplacingMatches(in: self,
                                                                options: [],
                                                                range: range,
                                                                withTemplate: withString)
            return replacedString
        } catch {
            print("Regex compilation failed: \(pattern)")
            return self
        }
    }
}
