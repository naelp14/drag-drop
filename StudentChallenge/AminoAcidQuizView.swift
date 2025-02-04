//
//  AminoAcidQuizView.swift
//  StudentChallenge
//
//  Created by Nathaniel Putera on 30/01/25.
//

import SwiftUI

struct AminoAcidQuizView: View {
    let aminoAcid: AminoAcidType
    @State private var userInputs: [String?]
    @State private var showResult = false
    @State private var isCorrect = false
    
    init(aminoAcid: AminoAcidType) {
        self.aminoAcid = aminoAcid
        self._userInputs = State(initialValue: Array(repeating: nil, count: aminoAcid.model.correctRGroup.count))
    }

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
//                message: Text(isCorrect ? "You completed the side chain correctly!" : "Try again! The correct atoms were \(aminoAcid.correctRGroup.joined(separator: " - "))."),
                message: Text("Corect"),
                dismissButton: .default(Text("OK"))
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
//                    ForEach(0..<userInputs.count, id: \.self) { index in
//                        DropTargetView(selectedAtom: $userInputs[index])
//                    }
            
            // try to assign to each box, and check
            HStack(alignment: .center) {
                ForEach(Array(aminoAcid.model.correctRGroup.enumerated()), id: \.offset) { index, chain in
                    if index != 0 {
                        Text("-").font(.title)
                    }
                    VStack {
                        if let firstChild = chain.child.first {
                            DropTargetView(correctAnswer: firstChild, shouldShowAnswer: $showResult)
                        } else {
                            Text(chain.child.first ?? " ")
                                .frame(height: 50)
                        }
                        
                        Text(chain.child.isEmpty ? " " : "|")
                            .frame(height: 10)
                        
                        DropTargetView(correctAnswer: chain.atom, shouldShowAnswer: $showResult)
                        
                        Text(chain.child.count > 1 ? "|" : " ")
                            .frame(height: 10)
                        
                        if chain.child.count > 1, let lastChild = chain.child.last {
                            DropTargetView(correctAnswer: lastChild, shouldShowAnswer: $showResult)
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
        }
        .padding()
        .background(userInputs.contains(nil) ? Color.gray : Color.green)
        .foregroundColor(.white)
        .cornerRadius(10)
        .disabled(userInputs.contains(nil))
    }
    
    private func getAtoms() -> [String] {
        var mainChains = aminoAcid.model.correctRGroup.map({ $0.atom })
        let sideChains = aminoAcid.model.correctRGroup.flatMap({ $0.child })
        mainChains.append(contentsOf: sideChains)
        return mainChains
    }
}

struct DropTargetView: View {
    @State var input: String = "_"
    let correctAnswer: String
    @Binding var shouldShowAnswer: Bool
    @State private var borderColor: Color = .clear

    var body: some View {
        Text(input)
            .font(.title)
            .foregroundColor(input.isEmpty ? .red : .black)
            .frame(minWidth: 50)
            .frame(height: 50)
            .background(Color.yellow.opacity(0.3))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))
            .border(shouldShowAnswer ? (input == correctAnswer ? Color.green : Color.red) : .clear, width: 2)
            .dropDestination(for: String.self, action: { items, location in
                if let first = items.first {
                    input = first
                }
                return true
            })
    }
}


