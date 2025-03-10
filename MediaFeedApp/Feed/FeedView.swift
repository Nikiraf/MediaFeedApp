//
//  FeedView.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 5.3.25..
//

import SwiftUI
import AVKit

struct FeedView: View {
    
    @StateObject private var viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.posts.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 10) {
                        PostView(mediaItems: viewModel.posts[index].media)
                    }
                }
            }
            .task {
                await viewModel.fetchPosts()
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorMessage ?? ""),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private func divider(for index: Int) -> some View {
        Group {
            if index != viewModel.posts.count - 1 {
                Divider()
                    .frame(height: 2)
                    .background(Color.gray)
                    .padding(.vertical, 8)
            }
        }
    }
    
}
