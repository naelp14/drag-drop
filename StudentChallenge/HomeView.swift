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
    @State private var showFullQuizView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                aminoAcidStructure
                
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
                
                Button {
                    showFullQuizView = true
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
        }
        .fullScreenCover(isPresented: $showFullQuizView) {
            FullQuizView()
        }
        .sheet(isPresented: $showCategorySheet) {
            CategorySelectionSheet { selectedCategory in
                self.selectedCategory = selectedCategory
                showCategorySheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.navigateToCategoryQuiz = true
                })
            }
            .presentationDetents([.medium])
        }
        .onChange(of: selectedCategory, { _, newValue in
            if newValue != nil {
                navigateToCategoryQuiz = true
            }
        })
        .fullScreenCover(isPresented: $navigateToCategoryQuiz, content: {
            if let category = selectedCategory {
                FullQuizView(category: category)
            }
        })
    }
    
    private var aminoAcidStructure: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cyan.opacity(0.5))
                .shadow(radius: 5)
                .frame(width: 200, height: 180)
                .rotationEffect(.degrees(15))
                .offset(x: -5, y: -5)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cyan.opacity(0.9))
                .shadow(radius: 5)
                .frame(width: 200, height: 180)
            
            HStack {
                VStack {
                    Text("H").foregroundColor(.red)
                    Text("|").foregroundColor(.primary)
                    Text("N").foregroundColor(.red)
                    Text("|").foregroundColor(.primary)
                    Text("H").foregroundColor(.red)
                }
                Text("-")
                    .font(.title)
                    .foregroundColor(.primary)
                VStack {
                    Text("H").foregroundColor(.primary)
                    Text("|").foregroundColor(.primary)
                    Text("C").foregroundColor(.primary)
                    Text("|").foregroundColor(.primary)
                    Text("R").foregroundColor(.primary)
                }
                Text("-")
                    .font(.title)
                    .foregroundColor(.primary)
                VStack {
                    Text("O").foregroundColor(.purple)
                    Text("||").foregroundColor(.primary)
                    Text("C").foregroundColor(.primary)
                    Text("|").foregroundColor(.primary)
                    Text("OH").foregroundColor(.purple)
                }
            }
            .padding(20)
        }
    }
}
