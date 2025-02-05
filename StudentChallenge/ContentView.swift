//
//  ContentView.swift
//  StudentChallenge
//
//  Created by Nathaniel Putera on 23/01/25.
//

import SwiftUI

let completedAminoAcidsKey = "completedAminoAcids"

struct AminoAcidSelectionView: View {
    @State private var completedAminoAcids: [String] = UserDefaults.standard.getArray(forKey: completedAminoAcidsKey)
    
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
            categorySections
        }
    }
    
    private var categorySections: some View {
        ForEach(groupedAminoAcids.keys.sorted(), id: \.self) { category in
            Section(header: Text(category).bold()) {
                aminoAcidRows(for: category)
            }
        }
    }
    
    private func aminoAcidRows(for category: String) -> some View {
        ForEach(groupedAminoAcids[category]!, id: \.self) { aminoAcid in
            aminoAcidRow(for: aminoAcid)
        }
    }
    
    private func aminoAcidRow(for aminoAcid: AminoAcidType) -> some View {
        NavigationLink(
            destination: AminoAcidQuizView(
                aminoAcid: aminoAcid,
                completedAminoAcids: $completedAminoAcids
            ),
            label: {
                HStack {
                    Text(aminoAcid.rawValue)
                        .padding()
                    Spacer()
                    if completedAminoAcids.contains(aminoAcid.rawValue) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
        )
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
