//
//  Post.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 5.3.25..
//

import Foundation

struct Post: Identifiable {
    
    let id: String
    let media: [MediaType]
    
}

extension Post {
    static var mock: [Post] {
        [
            Post(id: "1", media: [
                .photo(URL(string: "https://i.pinimg.com/1200x/0f/62/65/0f6265fe8dc448b8f032f161db77c033.jpg")!),
                .video(URL(string: "https://imgur.com/9dSjOMX.mp4")!)
            ]),
            Post(id: "2", media: [
                .photo(URL(string: "https://i.pinimg.com/736x/85/f5/be/85f5bedff0758abea714994d3c398559.jpg")!),
                .video(URL(string: "https://imgur.com/ZDtzoJV.mp4")!)
            ]),
            Post(id: "3", media: [
                .video(URL(string: "https://imgur.com/ZDtzoJV.mp4")!),
                .photo(URL(string: "https://www.whitestone-gallery.com/cdn/shop/articles/Portrait_three_1200x1200.jpg")!)
            ]),
            Post(id: "4", media: [
                .video(URL(string: "https://imgur.com/9dSjOMX.mp4")!)
            ])
        ]
    }
}
