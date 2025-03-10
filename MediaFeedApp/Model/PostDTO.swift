//
//  PostDTO.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 9.3.25..
//

import Foundation

struct APIResponse: Decodable {
    
    let data: [PostDTO]
    
}

struct PostDTO: Decodable {
    let id: String
    let images: [ImageDTO]?

    struct ImageDTO: Decodable {
        let id: String
        let type: String
        let link: String
    }
}
