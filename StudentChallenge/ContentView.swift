//
//  ContentView.swift
//  StudentChallenge
//
//  Created by Nathaniel Putera on 23/01/25.
//

import SwiftUI

struct AminoAcidSelectionView: View {
    private var groupedAminoAcids: [String: [AminoAcidType]] = {
        return Dictionary(grouping: AminoAcidType.allCases, by: { $0.model.category })
    }()

    var body: some View {
        VStack {
            title
            list
        }
    }
    
    private var title: some View {
        Text("Select an Amino Acid Quiz")
            .font(.title)
            .bold()
            .padding()
    }
    
    private var list: some View {
        List {
            ForEach(groupedAminoAcids.keys.sorted(), id: \.self) { category in
                Section(header: Text(category).bold()) {
                    ForEach(groupedAminoAcids[category]!, id: \.self) { aminoAcid in
                        NavigationLink(
                            destination: AminoAcidQuizView(aminoAcid: aminoAcid),
                            label: {
                                Text(aminoAcid.rawValue)
                                    .padding()
                            }
                        )
                    }
                }
            }
        }
    }
}


struct ContentView: View {
    var body: some View {
        NavigationView {
            AminoAcidSelectionView()
        }
    }
}

#Preview {
    ContentView()
}
