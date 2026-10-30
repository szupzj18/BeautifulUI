import BeautifulUI
import SwiftUI

struct ApprovalCardDemo: View {
    static let questions = [
        ApprovalQuestion("How many flavors should we launch?", options: ["Three (core line)", "Five (full case)", "Just one hero"]),
        ApprovalQuestion("Which mix-ins should we stock?", kind: .multiple, options: ["Chocolate chips", "Waffle bits", "Sprinkles"]),
        ApprovalQuestion("Which market do we enter first?", options: ["Food trucks", "Grocery freezers", "Scoop shops"]),
    ]

    @Environment(\.demoState) private var demoState

    var body: some View {
        // -state q2 resumes on the multi-select question; -state sent shows the confirmation.
        switch demoState {
        case "q2":
            ApprovalCard(questions: Self.questions, startAt: 1, answers: ApprovalAnswers(picks: [0: [0], 1: [0, 2]]))
        case "sent":
            ApprovalCard(questions: Self.questions, submitted: true)
        default:
            ApprovalCard(questions: Self.questions)
        }
    }
}
