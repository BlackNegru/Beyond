import 'package:flutter/material.dart';

import '../../misc/colors.dart';
import '../../widgets/app_largetext.dart';
import '../../widgets/app_text.dart';

class FAQPage extends StatelessWidget {
  final String userId;

  const FAQPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor.withOpacity(0.8), // Set the color for the AppBar
        title: AppLargeText(text: "FAQs", color: Colors.white),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Ensure icon color matches the AppBar color
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: ListView(
          children: [
            FaqItem(
              question: "What types of experiences can I book through Beyond?",
              answer:
              "Beyond offers a wide range of experiences including trekking, hiking,"
                  " underwater diving, snorkeling, ballooning, and kayaking. Each experience is carefully curated to ensure the best adventure possible.",
            ),
            FaqItem(
              question: "How do I book an experience?",
              answer:
              "Booking an experience is easy. Simply browse our list of experiences,"
                  " select the one you're interested in, and follow the prompts to book. You'll need to provide some details and payment information to complete your booking.",
            ),
            FaqItem(
              question: "What should I bring for my experience?",
              answer:
              "What you need to bring depends on the experience you're booking. Generally, it's a good idea to bring appropriate clothing, any personal equipment if specified, and your excitement for the adventure!",
            ),
            FaqItem(
              question: "Can I cancel or reschedule my booking?",
              answer:
              "Yes, you can cancel or reschedule your booking. Please refer to our cancellation policy on the booking page or contact our support team for assistance.",
            ),
            FaqItem(
              question: "Is transportation included in the experience?",
              answer:
              "Transportation details vary by experience. Some experiences include transportation, while others do not. Please check the specifics of your booking to see what is included.",
            ),
            FaqItem(
              question: "Are there any age restrictions for the experiences?",
              answer:
              "Age restrictions vary depending on the experience. Some activities may have minimum age requirements or restrictions based on health conditions. Please check the details of each experience for specific information.",
            ),
            FaqItem(
              question: "What safety measures are in place for the experiences?",
              answer:
              "We prioritize safety in all our experiences. Each provider"
                  " follows strict safety protocols and guidelines. You will receive specific safety instructions before the start of your experience.",
            ),
            FaqItem(
              question: "How do I contact support if I have more questions?",
              answer:
              "If you have more questions or need further assistance, you can contact our support team via the following methods:",
            ),
            SizedBox(height: 10),
            // Contact Information
            AppLargeText(text: "Contact Information", color: Colors.black.withOpacity(0.7), size: 15),
            SizedBox(height: 10),
            AppText(text: "Phone: +1-800-123-4567", color: AppColors.textColor1),
            AppText(text: "Phone: +1-800-234-5678", color: AppColors.textColor1),
            SizedBox(height: 10),
            AppText(text: "Email: support@beyondapp.com", color: AppColors.textColor1),
            AppText(text: "Email: help@beyondapp.com", color: AppColors.textColor1),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({
    required this.question,
    required this.answer,
    super.key,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppLargeText(
                text: widget.question,
                color: Colors.black.withOpacity(0.7),
                size: 9,
              ),
              Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.textColor1,
              ),
            ],
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: AppText(
              text: widget.answer,
              color: AppColors.textColor1,
            ),
          ),
        SizedBox(height: 15),
      ],
    );
  }
}
