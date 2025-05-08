//
//  CategorySelectionView.swift
//  StudentChallenge
//
//  Created by Nathaniel Putera on 07/02/25.
//

import SwiftUI

struct CategorySelectionSheet: View {
    let onCategorySelected: (String) -> Void
    
    let categories = [
        "Nonpolar, Aliphatic",
        "Aromatic",
        "Polar, Uncharged",
        "Acidic (Negative)",
        "Basic (Positive)"
    ]
    
    var body: some View {
        VStack {
            Text("Select a Category")
                .font(.title)
                .bold()
                .padding()
            
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    onCategorySelected(category)
                }) {
                    Text(category)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.primary)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.vertical, 20)
    }
}
