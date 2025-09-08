//
//  ContentView.swift
//  Navigation
//
//  Created by Dmitry Kononov on 8.09.25.
//

import SwiftUI

@Observable
class PathStore {
    var path: NavigationPath { didSet { save() } }
    
    private let savePath = URL.documentsDirectory.appending(component: "SavedPath")
    
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }
        path = NavigationPath()
    }
    
   private  func save() {
        guard let representation = path.codable else { return }
        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("failed to save navigation path: \(error)")
        }
    }
}

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
    @State private var pathStore = PathStore()
    
    var body: some View {
        NavigationStack(path: $pathStore.path) {
            DetailsView(number: 0, path: $pathStore.path)
                .navigationDestination(for: Int.self) { destination in
                    DetailsView(number: destination, path: $pathStore.path)
                }
        }
    }
}

#Preview {
    ContentView()
}
