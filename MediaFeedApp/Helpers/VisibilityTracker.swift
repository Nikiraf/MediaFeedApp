//
//  VisibilityTracker.swift
//  MedialFeedApp
//
//  Created by Aleksandar Nikolic on 9.3.25..
//

import SwiftUI

struct VisibilityTracker: View {
    @Binding var isVisible: Bool

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onChange(of: geometry.frame(in: .global).minY, {
                    updateVisibility(with: geometry)
                })
                .onAppear {
                    updateVisibility(with: geometry)
                }
        }
    }

    private func updateVisibility(with geometry: GeometryProxy) {
        let frame = geometry.frame(in: .global)
        let screenHeight = UIScreen.main.bounds.height
        let fullyVisible = frame.midY > 0 && frame.midY < screenHeight

        DispatchQueue.main.async {
            isVisible = fullyVisible
        }
    }
}
