//
//  ImageContainer.swift
//  Managers
//
//  Created by Юлия  on 21.09.2024.
//

import Foundation
import SwiftUI

///Контейнер для загрузки изображения из FileManager
struct ImageContainer: View {
    
    @StateObject private var imageLoader = ImageLoader()
   
    let imageUrl: String

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            imageLoader.loadImageUseFileManager(from: imageUrl)
        }
    }
}

