import SwiftUI

struct FullQuizView: View {
    var category: String? = nil // ✅ Optional category parameter
    @State private var aminoAcids: [AminoAcidType] = []
    @State private var currentIndex = 0
    @State private var showFinalResult = false
    @State private var score = 0
    
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
    }

    private var quizPage: some View {
        AminoAcidQuizView(
            aminoAcid: aminoAcids[currentIndex],
            completedAminoAcids: Binding.constant([]),
            isFullQuiz: true,
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
            
            Text("You scored \(score) out of \(aminoAcids.count)")
                .font(.title2)

            Button("Restart Quiz") {
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
        } else {
            showFinalResult = true
        }
    }

    private func restartQuiz() {
        aminoAcids.shuffle()
        currentIndex = 0
        score = 0
        showFinalResult = false
    }
}
