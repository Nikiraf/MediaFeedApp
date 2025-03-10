//
//  CustomImageViewModel.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 9.3.25..
//

import SwiftUI
import Combine

class CustomImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = true
    
    private var url: URL
    private var cancellables = Set<AnyCancellable>()
    
    init(url: URL) {
        self.url = url
        loadImage()
    }
    
    private func loadImage() {
        if let cachedImage = ImageCacheManager.shared.cachedImage(for: url) {
            image = cachedImage
            isLoading = false
        } else {
            downloadImage()
        }
    }

    private func downloadImage() {
        isLoading = true

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            guard let data = data, error == nil, let downloadedImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            ImageCacheManager.shared.cacheImage(downloadedImage, for: self.url)

            DispatchQueue.main.async {
                self.image = downloadedImage
                self.isLoading = false
            }
        }.resume()
    }
}
