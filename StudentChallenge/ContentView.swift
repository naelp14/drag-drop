//
//  ContentView.swift
//  StudentChallenge
//
//  Created by Nathaniel Putera on 23/01/25.
//

import SwiftUI

let completedAminoAcidsKey = "completedAminoAcids"

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            AminoAcidSelectionView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Browse")
                }
        }
    }
}

#Preview {
    ContentView()
}
