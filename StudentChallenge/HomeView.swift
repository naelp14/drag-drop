//
//  HomeView.swift
//  StudentChallenge
//
//  Created by Nathaniel Putera on 07/02/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showCategorySheet = false
    @State private var selectedCategory: String? = nil
    @State private var navigateToCategoryQuiz = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 200)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    aminoAcidStructure
                }
                .padding()
                
                Text("Side Chain Memorization Quest")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .shadow(radius: 5)
                
                Text("Turn Complex Chemistry into Simple Memory!")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .shadow(radius: 5)
                
                Spacer()
                
                NavigationLink {
                    FullQuizView()
                } label: {
                    Text("Start")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green.opacity(0.8), Color.blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 30)
                
                Button(action: {
                    showCategorySheet = true
                }) {
                    Text("Start Category Quiz")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToCategoryQuiz) {
                if let category = selectedCategory {
                    FullQuizView(category: category)
                }
            }
        }
        .sheet(isPresented: $showCategorySheet) {
            CategorySelectionSheet { selectedCategory in
                showCategorySheet = false
                self.selectedCategory = selectedCategory
                self.navigateToCategoryQuiz = true
            }
            .presentationDetents([.medium])
        }
    }
    
    private var aminoAcidStructure: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.6))
                .shadow(radius: 5)
                .frame(width: 200, height: 180)
                .rotationEffect(.degrees(30))
                .offset(x: -5, y: -5)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.9))
                .shadow(radius: 5)
                .frame(width: 200, height: 180)
            
            HStack {
                VStack {
                    Text("H").foregroundColor(.red)
                    Text("|")
                    Text("N").foregroundColor(.red)
                    Text("|")
                    Text("H").foregroundColor(.red)
                }
                Text("-").font(.title)
                VStack {
                    Text("H")
                    Text("|")
                    Text("C")
                    Text("|")
                    Text("R")
                }
                Text("-").font(.title)
                VStack {
                    Text("O").foregroundColor(.purple)
                    Text("||")
                    Text("C")
                    Text("|")
                    Text("OH").foregroundColor(.purple)
                }
            }
            .padding(20)
        }
    }
}
