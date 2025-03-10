//
//  VideoPlayerViewModel.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 6.3.25..
//

import AVFoundation
import Combine
import UIKit

class VideoPlayerViewModel: ObservableObject {
    
    @Published var isVideoReady = false
    @Published var isVisible = false {
        didSet {
            updatePlaybackState()
        }
    }
    
    private var player: AVPlayer = AVPlayer()
    private var cancellables = Set<AnyCancellable>()
    private let videoURL: URL
    private var downloadTask: URLSessionDownloadTask?
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        setupObservers()
    }
    
    func setupPlayer() {
        player.pause()
        isVideoReady = false
        
        if let cachedVideoURL = CacheManager.shared.getCachedVideoURL(for: videoURL),
           FileManager.default.fileExists(atPath: cachedVideoURL.path) {
            playVideo(from: cachedVideoURL)
        } else {
            downloadAndCacheVideo { [weak self] localURL in
                guard let self = self, let localURL = localURL else { return }
                self.playVideo(from: localURL)
            }
        }
    }
    
    private func playVideo(from url: URL) {
        DispatchQueue.main.async {
            self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
            self.isVideoReady = true
            self.updatePlaybackState()
        }
    }
    
    private func downloadAndCacheVideo(completion: @escaping (URL?) -> Void) {
        downloadTask?.cancel()
        
        downloadTask = URLSession.shared.downloadTask(with: videoURL) { [weak self] location, response, error in
            guard let self = self else {
                completion(nil)
                return
            }
            
            // Check if the request was canceled
            if let error = error as NSError?, error.code == -999 {
                // This means the request was canceled
                print("Download task was canceled.")
                completion(nil)
                return
            }
            
            // Handle other download errors
            if let error = error {
                print("Error downloading video: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Ensure a valid location was returned
            guard let location = location,
                  let destinationURL = CacheManager.shared.getCachedVideoURL(for: self.videoURL) else {
                completion(nil)
                return
            }
            
            do {
                // Move the downloaded file to the cache directory
                try FileManager.default.moveItem(at: location, to: destinationURL)
                completion(destinationURL)
            } catch {
                print("Error moving downloaded video: \(error.localizedDescription)")
                completion(nil)
            }
        }
        downloadTask?.resume()
    }
    
    private func updatePlaybackState() {
        if isVideoReady {
            if isVisible {
                player.play()
            } else {
                player.pause()
            }
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                if self?.isVideoReady == true {
                    self?.player.pause()
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in self?.updatePlaybackState() }
            .store(in: &cancellables)
    }
    
    func getPlayer() -> AVPlayer {
        return player
    }
    
    deinit {
        downloadTask?.cancel()
        player.replaceCurrentItem(with: nil)
    }
}
