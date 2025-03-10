//
//  PostView.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 5.3.25..
//

import SwiftUI

struct PostView: View {
    
    @State private var selectedPage = 0
    
    let mediaItems: [MediaType]

    var body: some View {
        VStack {
            TabView(selection: $selectedPage) {
                ForEach(mediaItems.indices, id: \.self) { index in
                    let media = mediaItems[index]
                    
                    switch media {
                    case .photo(let url):
                        CustomImageView(url: url)
                            .tag(index)
                    case .video(let url):
                        VideoPlayerView(videoURL: url)
                            .tag(index)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 300)
            
            if mediaItems.count > 1 {
                HStack(spacing: 5) {
                    ForEach(mediaItems.indices, id: \.self) { index in
                        Circle()
                            .fill(selectedPage == index ? Color.blue : Color.gray.opacity(0.5))
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .padding(.bottom, mediaItems.count > 1 ? 10 : 0)
    }
}
