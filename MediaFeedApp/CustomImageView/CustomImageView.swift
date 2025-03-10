//
//  CustomImageView.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 5.3.25..
//

import SwiftUI

struct CustomImageView: View {
    
    @StateObject private var viewModel: CustomImageViewModel
    
    init(url: URL) {
        _viewModel = StateObject(wrappedValue: CustomImageViewModel(url: url))
    }
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }

            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}
