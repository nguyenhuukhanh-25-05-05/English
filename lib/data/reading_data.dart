import 'package:flutter/material.dart';

class ReadingPassage {
  final String title;
  final String category;
  final IconData icon;
  final Color color;
  final List<ReadingParagraph> paragraphs;
  final List<ReadingVocab> vocabulary;
  final List<ReadingQuestion> questions;

  const ReadingPassage({
    required this.title,
    required this.category,
    required this.icon,
    required this.color,
    required this.paragraphs,
    required this.vocabulary,
    required this.questions,
  });
}

class ReadingParagraph {
  final String english;
  final String vietnamese;

  const ReadingParagraph({required this.english, required this.vietnamese});
}

class ReadingVocab {
  final String word;
  final String type;
  final String meaning;
  final String example;

  const ReadingVocab({
    required this.word,
    required this.type,
    required this.meaning,
    required this.example,
  });
}

class ReadingQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  const ReadingQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

final allReadingPassages = <ReadingPassage>[
  ReadingPassage(
    title: 'My Daily Routine',
    category: 'Cuộc sống hàng ngày',
    icon: Icons.wb_sunny_rounded,
    color: const Color(0xFFF59E0B),
    paragraphs: const [
      ReadingParagraph(
        english:
            'I wake up at six o\'clock every morning. First, I brush my teeth and wash my face. Then I eat breakfast with my family. I usually have rice and eggs.',
        vietnamese:
            'Tôi thức dậy lúc sáu giờ mỗi sáng. Đầu tiên, tôi đánh răng và rửa mặt. Sau đó tôi ăn sáng với gia đình. Tôi thường ăn cơm và trứng.',
      ),
      ReadingParagraph(
        english:
            'I go to school at seven thirty. I ride my bicycle because the school is not far from my house. It takes about fifteen minutes.',
        vietnamese:
            'Tôi đi học lúc bảy giờ rưỡi. Tôi đi xe đạp vì trường không xa nhà. Mất khoảng mười lăm phút.',
      ),
      ReadingParagraph(
        english:
            'After school, I do my homework and study English for one hour. In the evening, I watch TV with my family and go to bed at ten o\'clock.',
        vietnamese:
            'Sau giờ học, tôi làm bài tập và học tiếng Anh một tiếng. Buổi tối, tôi xem TV với gia đình và đi ngủ lúc mười giờ.',
      ),
    ],
    vocabulary: const [
      ReadingVocab(
        word: 'Routine',
        type: 'n',
        meaning: 'Thói quen hằng ngày',
        example: 'Exercise is part of my daily routine.',
      ),
      ReadingVocab(
        word: 'Usually',
        type: 'adv',
        meaning: 'Thường xuyên',
        example: 'I usually go to bed at 10 PM.',
      ),
    ],
    questions: const [
      ReadingQuestion(
        question: 'What time does the writer wake up?',
        options: ['5:00 AM', '6:00 AM', '7:00 AM', '7:30 AM'],
        correctAnswerIndex: 1,
        explanation:
            'The text says: "I wake up at six o\'clock every morning."',
      ),
      ReadingQuestion(
        question: 'How does the writer go to school?',
        options: ['By bus', 'By car', 'By bicycle', 'On foot'],
        correctAnswerIndex: 2,
        explanation:
            'The text says: "I ride my bicycle because the school is not far..."',
      ),
    ],
  ),
  ReadingPassage(
    title: 'A Trip to Da Nang',
    category: 'Du lịch',
    icon: Icons.flight_rounded,
    color: const Color(0xFF3B82F6),
    paragraphs: const [
      ReadingParagraph(
        english:
            'Last summer, my family went to Da Nang for a five-day vacation. We took a plane from Ho Chi Minh City. The flight was only one hour and twenty minutes.',
        vietnamese:
            'Mùa hè năm ngoái, gia đình tôi đi Đà Nẵng nghỉ năm ngày. Chúng tôi đi máy bay từ Thành phố Hồ Chí Minh. Chuyến bay chỉ mất một giờ hai mươi phút.',
      ),
      ReadingParagraph(
        english:
            'We visited the Golden Bridge on Ba Na Hills. It was very beautiful and the weather was cool. We also went to My Khe Beach and swam in the ocean.',
        vietnamese:
            'Chúng tôi tham quan Cầu Vàng trên Bà Nà Hills. Nó rất đẹp và thời tiết mát mẻ. Chúng tôi cũng đi biển Mỹ Khê và bơi trong đại dương.',
      ),
      ReadingParagraph(
        english:
            'The food in Da Nang was amazing. We tried Mi Quang, Banh Xeo, and fresh seafood. I want to go back again next year.',
        vietnamese:
            'Đồ ăn ở Đà Nẵng rất tuyệt. Chúng tôi đã thử Mì Quảng, Bánh Xèo, và hải sản tươi. Tôi muốn quay lại vào năm tới.',
      ),
    ],
    vocabulary: const [
      ReadingVocab(
        word: 'Vacation',
        type: 'n',
        meaning: 'Kỳ nghỉ',
        example: 'We are planning a summer vacation.',
      ),
      ReadingVocab(
        word: 'Amazing',
        type: 'adj',
        meaning: 'Kinh ngạc, tuyệt vời',
        example: 'The scenery was amazing.',
      ),
    ],
    questions: const [
      ReadingQuestion(
        question: 'How long was the vacation?',
        options: ['3 days', '5 days', '1 week', '2 days'],
        correctAnswerIndex: 1,
        explanation:
            'The text says: "...went to Da Nang for a five-day vacation."',
      ),
      ReadingQuestion(
        question: 'Where is the Golden Bridge?',
        options: ['My Khe Beach', 'Ba Na Hills', 'Ho Chi Minh City', 'Hoi An'],
        correctAnswerIndex: 1,
        explanation:
            'The text says: "We visited the Golden Bridge on Ba Na Hills."',
      ),
    ],
  ),
  ReadingPassage(
    title: 'Shopping at the Supermarket',
    category: 'Mua sắm',
    icon: Icons.shopping_cart_rounded,
    color: const Color(0xFF10B981),
    paragraphs: const [
      ReadingParagraph(
        english:
            'Every Saturday, my mother and I go to the supermarket to buy groceries for the week. We always make a shopping list before we go.',
        vietnamese:
            'Mỗi thứ Bảy, mẹ và tôi đi siêu thị mua thực phẩm cho cả tuần. Chúng tôi luôn viết danh sách mua sắm trước khi đi.',
      ),
      ReadingParagraph(
        english:
            'First, we go to the fruit section and pick some apples, bananas, and oranges. Then we buy vegetables like carrots, tomatoes, and lettuce.',
        vietnamese:
            'Đầu tiên, chúng tôi đến quầy trái cây và chọn một ít táo, chuối, và cam. Sau đó chúng tôi mua rau như cà rốt, cà chua, và xà lách.',
      ),
      ReadingParagraph(
        english:
            'We also buy chicken, fish, milk, and bread. My mother always checks the prices carefully. She looks for sales and discounts to save money.',
        vietnamese:
            'Chúng tôi cũng mua thịt gà, cá, sữa, và bánh mì. Mẹ tôi luôn kiểm tra giá cẩn thận. Bà tìm khuyến mãi và giảm giá để tiết kiệm.',
      ),
    ],
    vocabulary: const [
      ReadingVocab(
        word: 'Groceries',
        type: 'n',
        meaning: 'Thực phẩm và đồ dùng gia đình',
        example: 'I need to buy some groceries.',
      ),
      ReadingVocab(
        word: 'Discount',
        type: 'n',
        meaning: 'Giảm giá',
        example: 'Is there a discount on this shirt?',
      ),
    ],
    questions: const [
      ReadingQuestion(
        question: 'When do they go to the supermarket?',
        options: ['Every Friday', 'Every Saturday', 'Every Sunday', 'Monthly'],
        correctAnswerIndex: 1,
        explanation: 'The text states: "Every Saturday, my mother and I go..."',
      ),
      ReadingQuestion(
        question: 'What do they do before going?',
        options: [
          'Eat lunch',
          'Make a list',
          'Call a taxi',
          'Check the weather',
        ],
        correctAnswerIndex: 1,
        explanation:
            'The text says: "We always make a shopping list before we go."',
      ),
    ],
  ),
  ReadingPassage(
    title: 'Learning English Online',
    category: 'Giáo dục',
    icon: Icons.laptop_rounded,
    color: const Color(0xFF6366F1),
    paragraphs: const [
      ReadingParagraph(
        english:
            'Nowadays, many Vietnamese students learn English online. They use apps and websites to study vocabulary, grammar, and listening skills.',
        vietnamese:
            'Ngày nay, nhiều học sinh Việt Nam học tiếng Anh trực tuyến. Họ sử dụng ứng dụng và trang web để học từ vựng, ngữ pháp, và kỹ năng nghe.',
      ),
      ReadingParagraph(
        english:
            'Online learning is very convenient because you can study anytime and anywhere. You just need a phone or a computer with an internet connection.',
        vietnamese:
            'Học trực tuyến rất tiện lợi vì bạn có thể học bất cứ lúc nào và ở đâu. Bạn chỉ cần điện thoại hoặc máy tính có kết nối internet.',
      ),
      ReadingParagraph(
        english:
            'However, it is important to practice speaking with real people. Try to find a language partner or join an English club to improve your communication skills.',
        vietnamese:
            'Tuy nhiên, điều quan trọng là phải thực hành nói với người thật. Hãy tìm một bạn học ngôn ngữ hoặc tham gia câu lạc bộ tiếng Anh để cải thiện kỹ năng giao tiếp.',
      ),
    ],
    vocabulary: const [
      ReadingVocab(
        word: 'Convenient',
        type: 'adj',
        meaning: 'Tiện lợi',
        example: 'The app is very convenient to use.',
      ),
      ReadingVocab(
        word: 'Improve',
        type: 'v',
        meaning: 'Cải thiện',
        example: 'I want to improve my speaking skills.',
      ),
    ],
    questions: const [
      ReadingQuestion(
        question: 'Why is online learning convenient?',
        options: [
          'It is free',
          'Study anytime/anywhere',
          'No homework',
          'It is faster',
        ],
        correctAnswerIndex: 1,
        explanation:
            'The text says: "...convenient because you can study anytime and anywhere."',
      ),
      ReadingQuestion(
        question: 'What is important besides online learning?',
        options: [
          'Buying more books',
          'Practicing with real people',
          'Watching movies',
          'Gaming',
        ],
        correctAnswerIndex: 1,
        explanation:
            'The text says: "...it is important to practice speaking with real people."',
      ),
    ],
  ),
  ReadingPassage(
    title: 'Professional Email Etiquette',
    category: 'Công việc (TOEIC)',
    icon: Icons.business_center_rounded,
    color: const Color(0xFF4B5563),
    paragraphs: const [
      ReadingParagraph(
        english:
            'When writing a professional email, always start with a formal greeting. Use "Dear Mr./Ms. [Last Name]" if you know the recipient\'s name. If not, "To Whom It May Concern" is appropriate.',
        vietnamese:
            'Khi viết một email chuyên nghiệp, luôn bắt đầu bằng lời chào trang trọng. Sử dụng "Kính gửi ông/bà [Họ]" nếu bạn biết tên người nhận. Nếu không, "Gửi các bên liên quan" là phù hợp.',
      ),
      ReadingParagraph(
        english:
            'The subject line should be clear and concise. It should summarize the main purpose of the email so the recipient knows what to expect before opening it.',
        vietnamese:
            'Dòng tiêu đề phải rõ ràng và súc tích. Nó nên tóm tắt mục đích chính của email để người nhận biết những gì mong đợi trước khi mở nó.',
      ),
      ReadingParagraph(
        english:
            'Finally, end the email with a professional closing like "Sincerely," or "Best regards," followed by your full name and contact information.',
        vietnamese:
            'Cuối cùng, kết thúc email bằng lời chào kết thúc chuyên nghiệp như "Trân trọng," hoặc "Trân trọng nhất," theo sau là tên đầy đủ và thông tin liên hệ của bạn.',
      ),
    ],
    vocabulary: const [
      ReadingVocab(
        word: 'Recipient',
        type: 'n',
        meaning: 'Người nhận',
        example: 'Please check the recipient\'s address.',
      ),
      ReadingVocab(
        word: 'Concise',
        type: 'adj',
        meaning: 'Súc tích, ngắn gọn',
        example: 'His explanation was clear and concise.',
      ),
    ],
    questions: const [
      ReadingQuestion(
        question: 'How should a professional email start?',
        options: [
          'With "Hi"',
          'With a formal greeting',
          'With the price',
          'With a joke',
        ],
        correctAnswerIndex: 1,
        explanation: 'The text says: "...always start with a formal greeting."',
      ),
      ReadingQuestion(
        question: 'What is the purpose of the subject line?',
        options: [
          'To say hello',
          'To summarize the purpose',
          'To list the price',
          'To show the date',
        ],
        correctAnswerIndex: 1,
        explanation:
            'The text says: "It should summarize the main purpose of the email..."',
      ),
    ],
  ),
  ReadingPassage(
    title: 'Office Relocation Notice',
    category: 'Thông báo (TOEIC)',
    icon: Icons.info_outline_rounded,
    color: const Color(0xFF6B7280),
    paragraphs: const [
      ReadingParagraph(
        english:
            'Attention all employees! Our main office is moving to a new location on April 1st. The new address is 123 Business Avenue, Suite 400. This move is necessary due to our growing team.',
        vietnamese:
            'Chú ý tất cả nhân viên! Văn phòng chính của chúng ta sẽ chuyển đến địa điểm mới vào ngày 1 tháng 4. Địa chỉ mới là 123 Đại lộ Doanh nghiệp, Phòng 400. Việc chuyển văn phòng này là cần thiết do đội ngũ của chúng ta đang phát triển.',
      ),
      ReadingParagraph(
        english:
            'All staff are requested to pack their personal belongings by March 30th. The company has hired professional movers to transport office furniture and equipment over the weekend.',
        vietnamese:
            'Tất cả nhân viên được yêu cầu đóng gói đồ đạc cá nhân trước ngày 30 tháng 3. Công ty đã thuê đơn vị vận chuyển chuyên nghiệp để vận chuyển nội thất và thiết bị văn phòng trong cuối tuần.',
      ),
      ReadingParagraph(
        english:
            'Normal business operations will resume at the new office on Monday morning. Please contact the HR department if you have any questions regarding transportation or parking.',
        vietnamese:
            'Hoạt động kinh doanh bình thường sẽ tiếp tục tại văn phòng mới vào sáng thứ Hai. Vui lòng liên hệ bộ phận nhân sự nếu bạn có bất kỳ câu hỏi nào liên quan đến việc đi lại hoặc đỗ xe.',
      ),
    ],
    vocabulary: const [
      ReadingVocab(
        word: 'Relocation',
        type: 'n',
        meaning: 'Việc chuyển địa điểm',
        example: 'The company relocation took two days.',
      ),
      ReadingVocab(
        word: 'Belongings',
        type: 'n',
        meaning: 'Đồ dùng cá nhân',
        example: 'Keep your belongings with you at all times.',
      ),
    ],
    questions: const [
      ReadingQuestion(
        question: 'Why is the office moving?',
        options: [
          'High rent',
          'Growing team',
          'Bad weather',
          'To be closer to the park',
        ],
        correctAnswerIndex: 1,
        explanation:
            'The text says: "This move is necessary due to our growing team."',
      ),
      ReadingQuestion(
        question: 'When should staff pack their things?',
        options: ['April 1st', 'March 30th', 'Monday morning', 'Next month'],
        correctAnswerIndex: 1,
        explanation:
            'The text says: "...requested to pack their personal belongings by March 30th."',
      ),
    ],
  ),
];
