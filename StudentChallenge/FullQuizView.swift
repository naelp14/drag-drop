import SwiftUI

struct FullQuizView: View {
    var category: String? = nil
    @State private var aminoAcids: [AminoAcidType] = []
    @State private var currentIndex = 0
    @State private var showFinalResult = false
    @State private var score = 0
    @State private var resetTrigger = UUID()
    @Environment(\.dismiss) private var dismiss

    init(category: String? = nil) {
        self.category = category
        self._aminoAcids = State(initialValue: category == nil
                                 ? AminoAcidType.allCases.shuffled()
                                 : AminoAcidType.allCases.filter { $0.model.category == category }.shuffled())
    }

    var body: some View {
        VStack {
            if showFinalResult {
                finalResultView
            } else {
                quizPage
            }
        }
        .navigationBarBackButtonHidden(true)
        .id(resetTrigger)
    }

    private var quizPage: some View {
        AminoAcidQuizView(
            aminoAcid: aminoAcids[currentIndex],
            completedAminoAcids: Binding.constant([]),
            isFullQuiz: true,
            totalQuestions: aminoAcids.count,
            currentQuestionIndex: currentIndex,
            onCompletion: { isCorrect in
                if isCorrect { score += 1 }
                goToNextQuestion()
            }
        )
    }

    private var finalResultView: some View {
        VStack(spacing: 20) {
            Text("Quiz Completed!")
                .font(.largeTitle)
                .bold()
            
            Text("You should try another to challenge yourself!")
                .font(.title2)
                .multilineTextAlignment(.center)

            Button("Back home") {
                restartQuiz()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }

    private func goToNextQuestion() {
        if currentIndex < aminoAcids.count - 1 {
            currentIndex += 1
            resetTrigger = UUID()
        } else {
            showFinalResult = true
        }
    }

    private func restartQuiz() {
        dismiss()
    }
}
