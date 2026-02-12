import 'quiz_data.dart';

class ToeicPatterns {
  // --- PART 5 & 6 GRAMMAR SETS ---
  static List<QuizQuestion> getPart5Sample() {
    return [
      const QuizQuestion(
        part: ToeicPart.part5,
        type: QuestionType.multipleChoice,
        question:
            "Ms. Hanh _______ for the position of Senior Accountant last week.",
        correctAnswer: "applied",
        options: ["apply", "applying", "applied", "application"],
        explanation: "Thì quá khứ đơn (last week) cần động từ V-ed.",
      ),
      const QuizQuestion(
        part: ToeicPart.part5,
        type: QuestionType.multipleChoice,
        question:
            "The newly _______ policy will take effect starting next month.",
        correctAnswer: "implemented",
        options: ["implement", "implementing", "implemented", "implementation"],
        explanation:
            "Cần một quá khứ phân từ làm tính từ bổ nghĩa cho 'policy'.",
      ),
    ];
  }

  // --- PART 7 READING PASSAGES ---
  static List<QuizQuestion> getPart7Sample() {
    const emailPassage = """
From: HR Department
To: All Staff
Subject: New Office Guidelines

Dear employees,
Please be advised that starting next Monday, all staff must wear their ID badges at all times while in the building. This is to ensure the security of our workplace. 

Additionally, we are implementing a new recycling program. Please dispose of paper products in the blue bins located in the breakroom.

Sincerely,
Management
""";
    return [
      const QuizQuestion(
        part: ToeicPart.part7,
        type: QuestionType.multipleChoice,
        passage: emailPassage,
        question: "What is the main purpose of this email?",
        correctAnswer: "To announce new workplace rules",
        options: [
          "To welcome new employees",
          "To announce new workplace rules",
          "To schedule a meeting",
          "To invite staff to a party",
        ],
        explanation: "Email thông báo quy định về thẻ tên và tái chế.",
      ),
      const QuizQuestion(
        part: ToeicPart.part7,
        type: QuestionType.multipleChoice,
        passage: emailPassage,
        question: "Where should paper products be discarded?",
        correctAnswer: "In the blue bins",
        options: [
          "In the blue bins",
          "In the local park",
          "In the manager's office",
          "In the parking lot",
        ],
      ),
    ];
  }

  // --- PART 3 CONVERSATIONS ---
  static List<QuizQuestion> getPart3Sample() {
    const transcript = """
M: Hi, I'm calling to see if my order is ready for pickup. I ordered a laptop bag yesterday.
W: Let me check... Ah, yes. It's ready. You can come by anytime before 6 PM.
M: Great. I'll be there in about 30 minutes. Do I need to show any identification?
W: Yes, a photo ID is required.
""";
    return [
      const QuizQuestion(
        part: ToeicPart.part3,
        type: QuestionType.multipleChoice,
        transcript: transcript,
        question: "Why is the man calling?",
        correctAnswer: "To check on an order status",
        options: [
          "To request a refund",
          "To check on an order status",
          "To ask for directions",
          "To report a lost item",
        ],
      ),
      const QuizQuestion(
        part: ToeicPart.part3,
        type: QuestionType.multipleChoice,
        transcript: transcript,
        question: "What must the man bring with him?",
        correctAnswer: "A photo identification",
        options: [
          "A credit card",
          "A printed receipt",
          "A photo identification",
          "A spare bag",
        ],
      ),
    ];
  }
}
