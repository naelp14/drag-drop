//
//  AminoAcidSelectionView.swift
//  StudentChallenge
//
//  Created by Nathaniel Putera on 07/02/25.
//

import SwiftUI

struct AminoAcidSelectionView: View {
    @State private var completedAminoAcids: [String] = UserDefaults.standard.getArray(forKey: completedAminoAcidsKey)
    @State private var searchText = ""
    
    private var groupedAminoAcids: [String: [AminoAcidType]] = {
        return Dictionary(grouping: AminoAcidType.allCases, by: { $0.model.category })
    }()
    
    private var filteredAminoAcids: [String: [AminoAcidType]] {
        if searchText.isEmpty {
            return groupedAminoAcids
        } else {
            return groupedAminoAcids.compactMapValues { aminoAcids in
                let filtered = aminoAcids.filter { $0.model.name.localizedCaseInsensitiveContains(searchText) }
                return filtered.isEmpty ? nil : filtered
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                categorySections
            }
            .navigationTitle("Browse")
            .searchable(text: $searchText, prompt: "Search Amino Acids")
        }
    }
    
    private var categorySections: some View {
        ForEach(filteredAminoAcids.keys.sorted(), id: \.self) { category in
            Section(header: Text(category).bold()) {
                aminoAcidRows(for: category)
            }
        }
    }
    
    private func aminoAcidRows(for category: String) -> some View {
        ForEach(filteredAminoAcids[category]!, id: \.self) { aminoAcid in
            aminoAcidRow(for: aminoAcid)
        }
    }
    
    private func aminoAcidRow(for aminoAcid: AminoAcidType) -> some View {
        NavigationLink(
            destination: AminoAcidQuizView(
                aminoAcid: aminoAcid,
                completedAminoAcids: $completedAminoAcids,
                isFullQuiz: false,
                onCompletion: nil
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
