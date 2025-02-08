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
    let onCompletion: ((Bool) -> Void)?
    
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var dict: [Int: Bool] = [:]
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
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
        .alert(isPresented: $showResult) {
            Alert(
                title: Text(isCorrect ? "Correct!" : "Wrong!"),
                message: Text(isCorrect ? "You completed the side chain correctly!" : "Try again!"),
                dismissButton: .default(Text(isFullQuiz ? "Next" : "OK")) {
                    if isCorrect {
                        if isFullQuiz {
                            onCompletion?(isCorrect)
                        } else {
                            markQuizAsCompleted()
                            dismiss()
                        }
                    }
                }
            )
        }
    }
    
    private var sideChainStructure: some View {
        HStack {
            Text("R = ")
                .font(.title2)
                .bold()
            
            HStack(alignment: .center) {
                ForEach(Array(aminoAcid.model.correctRGroup.enumerated()), id: \.offset) { index, chain in
                    if index != 0 {
                        Text("-").font(.title)
                    }
                    VStack {
                        if let firstChild = chain.child.first {
                            DropTargetView(
                                correctAnswer: firstChild,
                                index: (index * 10) + 1,
                                shouldShowAnswer: $showResult) { index, isCorrect in
                                    dict[index] = isCorrect
                                }
                        } else {
                            Text(chain.child.first ?? " ")
                                .frame(height: 50)
                        }
                        
                        Text(chain.child.isEmpty ? " " : "|")
                            .frame(height: 10)
                        
                        DropTargetView(
                            correctAnswer: chain.atom,
                            index: (index * 10) + 2,
                            shouldShowAnswer: $showResult) { index, isCorrect in
                                dict[index] = isCorrect
                            }
                        Text(chain.child.count > 1 ? "|" : " ")
                            .frame(height: 10)
                        
                        if chain.child.count > 1, let lastChild = chain.child.last {
                            DropTargetView(
                                correctAnswer: lastChild,
                                index: (index * 10) + 3,
                                shouldShowAnswer: $showResult) { index, isCorrect in
                                    dict[index] = isCorrect
                                }
                        } else {
                            Text(chain.child.first ?? " ")
                                .frame(height: 50)
                        }
                    }
                }
            }
            .frame(height: 180)
        }
    }
    
    private var answerOptions: some View {
        HStack {
            ForEach(getAtoms().shuffled(), id: \.self) { atom in
                DraggableAtomView(atom: atom)
            }
        }
        .padding()
    }
    
    private var checkButton: some View {
        Button("Check Answer") {
            showResult = true
            isCorrect = dict.values.allSatisfy({ $0 })
        }
        .sensoryFeedback(.warning, trigger: isCorrect)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
    
    // MARK: - Private Functions
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
            .rotationEffect(.degrees(isWiggling ? 3 : -3))
            .animation(
                Animation.easeInOut(duration: 0.1)
                    .repeatForever(autoreverses: true), value: isWiggling
            )
            .onAppear {
                isWiggling = true
            }
            .onDrag {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
                return NSItemProvider(object: atom as NSString)
            }
    }
}
