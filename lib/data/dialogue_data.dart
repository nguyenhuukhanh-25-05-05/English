import 'package:flutter/material.dart';

class DialogueLine {
  final String speaker;
  final String english;
  final String vietnamese;

  const DialogueLine({
    required this.speaker,
    required this.english,
    required this.vietnamese,
  });
}

class Dialogue {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<DialogueLine> lines;

  const Dialogue({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.lines,
  });
}

final allDialogues = <Dialogue>[
  Dialogue(
    title: 'Chào hỏi lần đầu',
    description: 'Gặp gỡ và giới thiệu bản thân',
    icon: Icons.waving_hand_rounded,
    color: const Color(0xFF3B82F6),
    lines: const [
      DialogueLine(
        speaker: 'A',
        english: 'Hello! My name is Tom. Nice to meet you.',
        vietnamese: 'Xin chào! Tôi tên là Tom. Rất vui được gặp bạn.',
      ),
      DialogueLine(
        speaker: 'B',
        english: 'Hi Tom! I am Sarah. Nice to meet you too.',
        vietnamese: 'Chào Tom! Tôi là Sarah. Rất vui được gặp bạn.',
      ),
      DialogueLine(
        speaker: 'A',
        english: 'Where are you from, Sarah?',
        vietnamese: 'Bạn đến từ đâu, Sarah?',
      ),
      DialogueLine(
        speaker: 'B',
        english: 'I am from Vietnam. How about you?',
        vietnamese: 'Tôi đến từ Việt Nam. Còn bạn?',
      ),
    ],
  ),
  Dialogue(
    title: 'Tại nhà hàng',
    description: 'Gọi món và thanh toán',
    icon: Icons.restaurant_rounded,
    color: const Color(0xFFEF4444),
    lines: const [
      DialogueLine(
        speaker: 'Khách',
        english: 'Good evening! A table for two, please.',
        vietnamese: 'Chào buổi tối! Cho tôi bàn hai người.',
      ),
      DialogueLine(
        speaker: 'Nhân viên',
        english: 'Of course. Please follow me. Here is your table.',
        vietnamese: 'Tất nhiên. Mời đi theo tôi. Đây là bàn của quý khách.',
      ),
      DialogueLine(
        speaker: 'Khách',
        english: 'Thank you. Can I see the menu, please?',
        vietnamese: 'Cảm ơn. Cho tôi xem thực đơn được không?',
      ),
      DialogueLine(
        speaker: 'Nhân viên',
        english: 'Here you go. Our special today is grilled salmon.',
        vietnamese: 'Đây ạ. Món đặc biệt hôm nay là cá hồi nướng.',
      ),
    ],
  ),
  Dialogue(
    title: 'Hỏi đường',
    description: 'Tìm đường đến một địa điểm',
    icon: Icons.map_rounded,
    color: const Color(0xFF10B981),
    lines: const [
      DialogueLine(
        speaker: 'A',
        english:
            'Excuse me. Can you help me? I am looking for the train station.',
        vietnamese:
            'Xin lỗi. Bạn có thể giúp tôi không? Tôi đang tìm nhà ga xe lửa.',
      ),
      DialogueLine(
        speaker: 'B',
        english: 'Sure! Go straight ahead for two blocks.',
        vietnamese: 'Tất nhiên! Đi thẳng về phía trước hai dãy nhà.',
      ),
      DialogueLine(
        speaker: 'A',
        english: 'Okay. And then what?',
        vietnamese: 'Được rồi. Rồi sau đó thì sao?',
      ),
    ],
  ),
  Dialogue(
    title: 'Mua sắm quần áo',
    description: 'Chọn và thử quần áo tại cửa hàng',
    icon: Icons.shopping_bag_rounded,
    color: const Color(0xFFF59E0B),
    lines: const [
      DialogueLine(
        speaker: 'Khách',
        english: 'Hi, I am looking for a jacket. Do you have any on sale?',
        vietnamese:
            'Xin chào, tôi đang tìm một chiếc áo khoác. Có cái nào giảm giá không?',
      ),
      DialogueLine(
        speaker: 'Nhân viên',
        english: 'Yes! We have a big sale this week. What size do you need?',
        vietnamese: 'Có! Tuần này chúng tôi giảm giá lớn. Bạn cần cỡ nào?',
      ),
    ],
  ),
  Dialogue(
    title: 'Đặt phòng khách sạn',
    description: 'Đặt phòng và hỏi thông tin',
    icon: Icons.hotel_rounded,
    color: const Color(0xFF8B5CF6),
    lines: const [
      DialogueLine(
        speaker: 'Khách',
        english: 'Good morning. I would like to book a room for three nights.',
        vietnamese: 'Chào buổi sáng. Tôi muốn đặt phòng cho ba đêm.',
      ),
      DialogueLine(
        speaker: 'Lễ tân',
        english: 'Sure. When would you like to check in?',
        vietnamese: 'Vâng. Quý khách muốn nhận phòng khi nào?',
      ),
    ],
  ),
  Dialogue(
    title: 'Phỏng vấn xin việc',
    description: 'Trả lời phỏng vấn tuyển dụng',
    icon: Icons.work_rounded,
    color: const Color(0xFF0EA5E9),
    lines: const [
      DialogueLine(
        speaker: 'Người PV',
        english: 'Please have a seat. Tell me about yourself.',
        vietnamese: 'Mời ngồi. Hãy kể về bản thân bạn.',
      ),
      DialogueLine(
        speaker: 'Ứng viên',
        english: 'Thank you. I have three years of experience in sales.',
        vietnamese:
            'Cảm ơn. Tôi có ba năm kinh nghiệm trong lĩnh vực bán hàng.',
      ),
    ],
  ),
  Dialogue(
    title: 'Tại sân bay',
    description: 'Làm thủ tục và hỏi thông tin chuyến bay',
    icon: Icons.flight_rounded,
    color: const Color(0xFF6366F1),
    lines: const [
      DialogueLine(
        speaker: 'Khách',
        english: 'Good afternoon. I would like to check in for my flight.',
        vietnamese: 'Chào buổi chiều. Tôi muốn làm thủ tục chuyến bay.',
      ),
      DialogueLine(
        speaker: 'Nhân viên',
        english: 'May I see your passport and booking confirmation?',
        vietnamese: 'Cho tôi xem hộ chiếu và xác nhận đặt vé?',
      ),
    ],
  ),
  Dialogue(
    title: 'Họp công việc',
    description: 'Thảo luận về dự án và ý tưởng mới',
    icon: Icons.groups_rounded,
    color: const Color(0xFF8B5CF6),
    lines: const [
      DialogueLine(
        speaker: 'Quản lý',
        english: 'Good morning everyone. Let\'s start the project meeting.',
        vietnamese: 'Chào buổi sáng mọi người. Hãy bắt đầu cuộc họp dự án.',
      ),
      DialogueLine(
        speaker: 'Nhân viên',
        english: 'I have prepared the initial designs for our new website.',
        vietnamese: 'Tôi đã chuẩn bị các thiết kế ban đầu cho trang web mới.',
      ),
    ],
  ),
  Dialogue(
    title: 'Trong hiệu sách',
    description: 'Tìm mua sách và hỏi giá',
    icon: Icons.menu_book_rounded,
    color: const Color(0xFF10B981),
    lines: const [
      DialogueLine(
        speaker: 'Khách',
        english: 'Excuse me, where can I find English learning books?',
        vietnamese: 'Xin lỗi, tôi có thể tìm sách học tiếng Anh ở đâu?',
      ),
      DialogueLine(
        speaker: 'Nhân viên',
        english: 'They are in the education section, on the second floor.',
        vietnamese: 'Chúng ở khu vực giáo dục, trên tầng hai ạ.',
      ),
    ],
  ),
  Dialogue(
    title: 'Đặt xe công nghệ',
    description: 'Trao đổi với tài xế về vị trí',
    icon: Icons.directions_car_rounded,
    color: const Color(0xFF3B82F6),
    lines: const [
      DialogueLine(
        speaker: 'Tài xế',
        english: 'Hello, I am near the main gate. Where are you standing?',
        vietnamese: 'Chào bạn, tôi đang ở gần cổng chính. Bạn đang đứng đâu?',
      ),
      DialogueLine(
        speaker: 'Khách',
        english: 'I am standing in front of the coffee shop.',
        vietnamese: 'Tôi đang đứng trước quán cà phê.',
      ),
    ],
  ),
  Dialogue(
    title: 'Gọi điện thoại',
    description: 'Gọi điện cho bạn bè để hẹn gặp',
    icon: Icons.phone_rounded,
    color: const Color(0xFF14B8A6),
    lines: const [
      DialogueLine(
        speaker: 'An',
        english: 'Hey, this is An. Are you free this Saturday?',
        vietnamese: 'Này, tôi là An. Bạn có rảnh thứ Bảy này không?',
      ),
      DialogueLine(
        speaker: 'Bình',
        english: 'Hi An! Let me think... Yes, I am free in the afternoon.',
        vietnamese: 'Chào An! Để tôi nghĩ... Có, tôi rảnh buổi chiều.',
      ),
    ],
  ),
  Dialogue(
    title: 'Thuê nhà',
    description: 'Hỏi thông tin và thuê căn hộ',
    icon: Icons.home_rounded,
    color: const Color(0xFFF97316),
    lines: const [
      DialogueLine(
        speaker: 'Khách',
        english:
            'Hello, I saw your apartment listing online. Is it still available?',
        vietnamese:
            'Xin chào, tôi thấy tin đăng cho thuê căn hộ trực tuyến. Nó còn không?',
      ),
      DialogueLine(
        speaker: 'Chủ nhà',
        english: 'Yes, it is! Would you like to come and see it?',
        vietnamese: 'Vâng, còn! Bạn có muốn đến xem không?',
      ),
    ],
  ),
  Dialogue(
    title: 'Tại quầy thuốc',
    description: 'Mua thuốc theo đơn',
    icon: Icons.medication_rounded,
    color: const Color(0xFFEF4444),
    lines: const [
      DialogueLine(
        speaker: 'Khách',
        english: 'I have a prescription here. Do you have these medicines?',
        vietnamese: 'Tôi có đơn thuốc ở đây. Anh có những thuốc này không?',
      ),
      DialogueLine(
        speaker: 'Dược sĩ',
        english: 'Let me check. Yes, we have everything in stock.',
        vietnamese: 'Để tôi kiểm tra. Có, chúng tôi có đủ hàng ạ.',
      ),
    ],
  ),
  Dialogue(
    title: 'Gửi bưu phẩm',
    description: 'Gửi quà đi quốc tế',
    icon: Icons.local_post_office_rounded,
    color: const Color(0xFFD97706),
    lines: const [
      DialogueLine(
        speaker: 'Khách',
        english: 'I want to send this package to Vietnam.',
        vietnamese: 'Tôi muốn gửi bưu phẩm này về Việt Nam.',
      ),
      DialogueLine(
        speaker: 'Nhân viên',
        english: 'What is inside the package, and is it fragile?',
        vietnamese: 'Bên trong bưu phẩm có gì, và nó có dễ vỡ không?',
      ),
    ],
  ),
  Dialogue(
    title: 'Tại tiệm làm tóc',
    description: 'Yêu cầu kiểu tóc mới',
    icon: Icons.content_cut_rounded,
    color: const Color(0xFFEC4899),
    lines: const [
      DialogueLine(
        speaker: 'Khách',
        english: 'I would like to get a haircut and a wash.',
        vietnamese: 'Tôi muốn cắt tóc và gội đầu.',
      ),
      DialogueLine(
        speaker: 'Thợ tóc',
        english: 'Sure. How short would you like it?',
        vietnamese: 'Vâng. Chị muốn cắt ngắn cỡ nào ạ?',
      ),
    ],
  ),
];
