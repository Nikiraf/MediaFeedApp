//
//  DataSource.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 6.3.25..
//

import Foundation

protocol NetworkClient {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}

protocol DataSourceProtocol {
    func fetchData() async throws -> [PostDTO]
}

class NetworkDataSource: DataSourceProtocol {
    private let client: NetworkClient

    init(client: NetworkClient = URLSessionNetworkClient()) {
        self.client = client
    }

    func fetchData() async throws -> [PostDTO] {
        guard let url = URL(string: Constants.baseURL) else { throw URLError(.badURL) }
        return try await client.fetch(APIResponse.self, from: url).data
    }
}

class URLSessionNetworkClient: NetworkClient {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.setValue("\(Constants.apiClientIDKey) \(Constants.apiClientIDValue)", forHTTPHeaderField: "\(Constants.apiAuthorizationKey)")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}

