//
//  FeedRepository.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 6.3.25..
//

import Foundation

protocol PostRepository {
    func fetchPosts() async throws -> [Post]
}

class FeedRepository: PostRepository {
    
    private let dataSource: DataSourceProtocol
    private let paginationLimit: Int

    init(dataSource: DataSourceProtocol = NetworkDataSource(), paginationLimit: Int = 10) {
        self.dataSource = dataSource
        self.paginationLimit = paginationLimit
    }

    func fetchPosts() async throws -> [Post] {
        let postDTOs = try await dataSource.fetchData()

        return postDTOs
            .prefix(paginationLimit) // Pagination need to be added
            .compactMap { dto in
            let media = dto.images?.compactMap { image -> MediaType? in
                guard let url = URL(string: image.link) else { return nil }
                
                switch image.type {
                case "video/mp4":
                    return .video(url)
                case "image/jpeg", "image/png":
                    return .photo(url)
                default:
                    return nil
                }
            } ?? []

            return media.isEmpty ? nil : Post(id: dto.id, media: media)
        }
    }
}

class FeedMockRepository: PostRepository {
    func fetchPosts() async throws -> [Post] {
        return Post.mock
    }
}
