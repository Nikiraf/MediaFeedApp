//
//  FeedRepositoryTests.swift
//  MedialFeedAppTests
//
//  Created by Aleksandar Nikolic on 9.3.25..
//

import XCTest
@testable import MedialFeedApp

class FeedRepositoryTests: XCTestCase {

    func testFetchPostsUsingMockData() async throws {
        // Given: Prepare the mock repository
        let feedRepository = FeedMockRepository()
        
        // When: Fetch posts from the repository
        let posts = try await feedRepository.fetchPosts()
        
        // Then: Validate that the number of posts and their content match the expected values
        XCTAssertEqual(posts.count, 4, "Expected 4 posts.")
        
        // Validate the individual posts and their media count
        XCTAssertEqual(posts[0].id, "1", "Expected first post to have ID 1.")
        XCTAssertEqual(posts[1].id, "2", "Expected second post to have ID 2.")
        
        // Verify the media count for each post
        XCTAssertEqual(posts[2].media.count, 2, "Expected second post to have 2 media files.")
        XCTAssertEqual(posts[3].media.count, 1, "Expected fourth post to have 1 media file.")
    }
    
}
