//
//  ContentView.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 5.3.25..
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            FeedView(viewModel: FeedViewModel(repository: FeedRepository()))
        }
    }
}


#Preview {
    ContentView()
}
