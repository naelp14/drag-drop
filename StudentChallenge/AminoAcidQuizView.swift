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
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var dict: [Int: Bool] = [:]
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            instructionText

            VStack {
                Text("Amino Acid: \(aminoAcid.model.name)")
                    .font(.headline)
                    .padding(.bottom, 10)

                aminoAcidStructure
                sideChainStructure
            }
            .padding()

            Text("Select Atoms for \(aminoAcid.model.name)")
                .font(.headline)
                .padding()

            Spacer()
            
            answerOptions
            checkButton
        }
        .padding(8)
        .alert(isPresented: $showResult) {
            Alert(
                title: Text(isCorrect ? "Correct!" : "Wrong!"),
                message: Text(isCorrect ? "You completed the side chain correctly!" : "Try again!"),
                dismissButton: .default(Text("OK")) {
                    if isCorrect {
                        markQuizAsCompleted()
                        dismiss()
                    }
                }
            )
        }
    }
    
    private var instructionText: some View {
        Text("Drag the correct atoms into the blanks")
            .font(.title)
            .bold()
            .padding()
    }
    
    private var aminoAcidStructure: some View {
        HStack {
            VStack {
                Text("H").foregroundColor(.red)
                Text("|")
                Text("N").foregroundColor(.red)
                Text("|")
                Text("H").foregroundColor(.red)
            }
            Text("- ").font(.title)
            VStack {
                Text("H")
                Text("|")
                Text("C")
                Text("|")
                Text("R")
            }
            Text(" -").font(.title)
            VStack {
                Text("O").foregroundColor(.purple)
                Text("||")
                Text("C")
                Text("|")
                Text("OH").foregroundColor(.purple)
            }
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
                Text(atom)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                    .draggable(atom)
            }
        }
        .padding()
    }
    
    private var checkButton: some View {
        Button("Check Answer") {
            showResult = true
            isCorrect = dict.values.allSatisfy({ $0 })
        }
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
            .font(.title)
            .foregroundColor(input.isEmpty ? .red : .black)
            .frame(minWidth: 50)
            .frame(height: 50)
            .background(Color.yellow.opacity(0.3))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(shouldShowAnswer ? (input == correctAnswer ? Color.green : Color.red) : Color.black, lineWidth: 1))
            .dropDestination(for: String.self, action: { items, location in
                if let first = items.first {
                    input = first
                    onCheckAnswer?(index, correctAnswer == input)
                }
                return true
            })
    }
}


