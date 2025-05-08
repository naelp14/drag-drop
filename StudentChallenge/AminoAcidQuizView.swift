//
//  AminoAcidQuizView.swift
//  StudentChallenge
//
//  Created by Nathaniel Putera on 30/01/25.
//

import SwiftUI

struct AminoAcidQuizView: View {
    let aminoAcid: AminoAcidType
    @Binding var completedAminoAcids: [String]
    let isFullQuiz: Bool
    var totalQuestions: Int = 20
    var currentQuestionIndex: Int = 1
    let onCompletion: ((Bool) -> Void)?

    @State private var showResult = false
    @State private var isCorrect = false
    @State private var dict: [Int: Bool] = [:]
    @State private var shuffledAnswers: [String] = []

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            if isFullQuiz {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }

                ProgressView(value: Double(currentQuestionIndex), total: Double(totalQuestions))
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.horizontal)
            }

            Text("Amino Acid: \(aminoAcid.model.name)")
                .font(.title)
                .padding(.bottom, 10)

            Spacer()
            sideChainStructure
                .padding()

            Spacer()
            Text("Drag the correct groups into the blanks")
                .font(.headline)
                .padding()

            answerOptions
            checkButton
        }
        .padding(8)
        .onAppear {
            resetQuizState()
        }
        .sheet(isPresented: $showResult) {
            successBottomSheet
                .presentationDetents([.height(250)])
                .presentationDragIndicator(.visible)
        }
    }

    private var sideChainStructure: some View {
        HStack {
            Text("R = ")
                .font(.title2)
                .bold()

            if aminoAcid.model.correctRGroup.count >= 4 {
                ScrollView(.horizontal, showsIndicators: false) {
                    answerSkeleton
                }
                .frame(height: 200)
            } else {
                answerSkeleton
                    .frame(height: 180)
            }
        }
    }
    
    private var answerSkeleton: some View {
        HStack(alignment: .center, spacing: 4) {
            ForEach(Array(aminoAcid.model.correctRGroup.enumerated()), id: \.offset) { index, chain in
                if index != 0 {
                    Text("-")
                        .font(.title)
                        .foregroundStyle(.primary)
                        .frame(minWidth: 20)
                }
                VStack {
                    if let firstChild = chain.child.first {
                        DropTargetView(
                            correctAnswer: firstChild,
                            index: (index * 10) + 1,
                            shouldShowAnswer: $showResult
                        ) { index, isCorrect in dict[index] = isCorrect }
                    } else {
                        Text(" ")
                            .frame(height: 50)
                    }
                    
                    Text(chain.child.isEmpty ? " " : "|")
                        .frame(height: 10)
                    
                    DropTargetView(
                        correctAnswer: chain.atom,
                        index: (index * 10) + 2,
                        shouldShowAnswer: $showResult
                    ) { index, isCorrect in dict[index] = isCorrect }
                    
                    Text(chain.child.count > 1 ? "|" : " ")
                        .frame(height: 10)
                    
                    if chain.child.count > 1, let lastChild = chain.child.last {
                        DropTargetView(
                            correctAnswer: lastChild,
                            index: (index * 10) + 3,
                            shouldShowAnswer: $showResult
                        ) { index, isCorrect in dict[index] = isCorrect }
                    } else {
                        Text(" ")
                            .frame(height: 50)
                    }
                }
            }
        }
        .padding(4)
    }
    
    private var answerOptions: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 10)]) {
            ForEach(Array(shuffledAnswers.enumerated()), id: \.offset) { _, atom in
                DraggableAtomView(atom: atom)
            }
        }
        .padding()
    }
    
    private var checkButton: some View {
        Button {
            showResult = true
            if dict.isEmpty || dict.count != shuffledAnswers.count {
                isCorrect = false
            } else {
                isCorrect = dict.values.allSatisfy { $0 }
            }
        } label: {
            Text("Check Answer")
                .sensoryFeedback(.warning, trigger: isCorrect)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        
    }
    
    private var successBottomSheet: some View {
        VStack(spacing: 20) {
            Text(isCorrect ? "🎉 Correct!" : "❌ Wrong!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(isCorrect ? .green : .red)

            Text(isCorrect ? "Well done! You've placed all groups correctly." : "Oops! Try again.")

            if isCorrect {
                if isFullQuiz {
                    Button {
                        showResult = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            onCompletion?(isCorrect)
                        }
                    } label: {
                        Text("Next Question")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Button {
                        showResult = false
                        markQuizAsCompleted()
                        dismiss()
                    } label: {
                        Text("OK")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            } else {
                Button {
                    showResult = false
                } label: {
                    Text("Try Again")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }

    // MARK: - Private Functions
    private func resetQuizState() {
        shuffledAnswers = getAtoms().shuffled()
        dict = [:]
        isCorrect = false
        showResult = false
    }

    private func getAtoms() -> [String] {
        var mainChains = aminoAcid.model.correctRGroup.map({ $0.atom })
        let sideChains = aminoAcid.model.correctRGroup.flatMap({ $0.child })
        mainChains.append(contentsOf: sideChains)
        return mainChains
    }

    private func markQuizAsCompleted() {
        if !completedAminoAcids.contains(aminoAcid.model.name) {
            completedAminoAcids.append(aminoAcid.model.name)
            UserDefaults.standard.setArray(completedAminoAcids, forKey: completedAminoAcidsKey)
        }
    }
}
