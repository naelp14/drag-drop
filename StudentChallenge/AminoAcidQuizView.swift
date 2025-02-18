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
            Text("Drag the correct atoms into the blanks")
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
            .frame(height: 180)
        }
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

            Text(isCorrect ? "Well done! You've placed all atoms correctly." : "Oops! Try again.")

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

struct DropTargetView: View {
    @State var input: String = "_"
    let correctAnswer: String
    let index: Int
    @Binding var shouldShowAnswer: Bool
    @State private var borderColor: Color = .clear
    let onCheckAnswer: ((Int, Bool) -> Void)?

    var body: some View {
        Text(input)
            .foregroundColor(input.isEmpty ? .red : .black)
            .frame(minWidth: 50)
            .frame(height: 50)
            .background(Color.yellow.opacity(0.3))
            .cornerRadius(8)
            .padding(2)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(shouldShowAnswer ? (input == correctAnswer ? Color.green : Color.red) : Color.black, lineWidth: 1))
            .dropDestination(for: String.self, action: { items, location in
                if let first = items.first {
                    input = first
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.prepare()
                    generator.impactOccurred()
                    onCheckAnswer?(index, correctAnswer == input)
                }
                return true
            })
    }
}

struct DraggableAtomView: View {
    let atom: String
    @State private var isWiggling = false

    var body: some View {
        Text(atom)
            .padding()
            .frame(minWidth: 80, minHeight: 50)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(8)
            .shadow(radius: 2)
            .rotationEffect(.degrees(isWiggling ? 2 : -2))
            .animation(
                Animation.easeInOut(duration: 0.1)
                    .repeatForever(autoreverses: true), value: isWiggling
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...0.2)) {
                    isWiggling = true
                }
            }
            .onDrag {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
                return NSItemProvider(object: atom as NSString)
            }
    }
}
