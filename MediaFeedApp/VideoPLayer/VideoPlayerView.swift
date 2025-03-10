//
//  VideoPlayerView.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 5.3.25..
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    
    @StateObject private var viewModel: VideoPlayerViewModel
    
    private let videoURL: URL
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        _viewModel = StateObject(wrappedValue: VideoPlayerViewModel(videoURL: videoURL))
    }
    
    var body: some View {
        VStack {
            if viewModel.isVideoReady {
                VideoPlayer(player: viewModel.getPlayer())
                    .frame(height: 300)
                    .background(VisibilityTracker(isVisible: $viewModel.isVisible))
            } else {
                ProgressView("Loading video...")
                    .frame(height: 300)
            }
        }
        .onAppear {
            viewModel.setupPlayer()
        }
    }
}
