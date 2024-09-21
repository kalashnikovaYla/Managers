//
//  AsyncImageView.swift
//  Managers
//
//  Created by Юлия  on 21.09.2024.
//

import Foundation
import SwiftUI

/// Загружает и кеширует изображения с ProgressView()
struct AsyncImageView: View {
    
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
            imageLoader.loadImage(from: imageUrl)
        }
    }
}
