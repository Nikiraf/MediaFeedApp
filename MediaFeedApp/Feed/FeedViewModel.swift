//
//  FeedViewModel.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 5.3.25..
//

import SwiftUI

@MainActor
class FeedViewModel: ObservableObject {

    @Published var posts: [Post] = []
    @Published var errorMessage: String?
    
    private let repository: PostRepository

    init(repository: PostRepository) {
        self.repository = repository
    }

    func fetchPosts() async {
        do {
            posts = try await repository.fetchPosts()
        } catch {
            errorMessage = "Failed to load posts"
        }
    }
}
