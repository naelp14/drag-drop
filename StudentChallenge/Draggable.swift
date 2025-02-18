//
//  Draggable.swift
//  StudentChallenge
//
//  Created by Nathaniel Putera on 18/02/25.
//

import SwiftUI

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
