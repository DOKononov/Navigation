//
//  ContentView.swift
//  Navigation
//
//  Created by Dmitry Kononov on 8.09.25.
//

import SwiftUI

struct DetailsView: View {
    
    var number: Int
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationLink("Go to random number", value: Int.random(in: 0...1000))
            .navigationTitle("Current number \(number)")
            .toolbar {
                Button("Home") {
                    path = NavigationPath()
                }
            }
    }
}

struct ContentView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            DetailsView(number: 0, path: $path)
                .navigationDestination(for: Int.self) { destination in
                    DetailsView(number: destination, path: $path)
                }
        }
    }
}

#Preview {
    ContentView()
}
