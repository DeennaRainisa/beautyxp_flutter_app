import 'package:flutter/material.dart';
import '../widgets/budget_card.dart';
import 'recommendation_screen.dart';

class BudgetSelectionScreen extends StatefulWidget {
  const BudgetSelectionScreen({super.key});

  @override
  State<BudgetSelectionScreen> createState() =>
      _BudgetSelectionScreenState();
}

class _BudgetSelectionScreenState
    extends State<BudgetSelectionScreen> {

  int selectedBudget = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F8),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Back Button
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Skin type: Oily Skin",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Select Your Budget",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E8FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [

                    Icon(Icons.wallet),

                    SizedBox(width: 15),

                    Expanded(
                      child: Text(
                        "We'll recommend the best products for your Oily Skin within your budget.",
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 25),

              BudgetCard(
                selected: selectedBudget == 0,
                icon: "💚",
                title: "RM20 - RM50",
                badge: "Affordable",
                subtitle:
                    "Budget-friendly picks that still work great",
                onTap: () {
                  setState(() {
                    selectedBudget = 0;
                  });
                },
              ),

              const SizedBox(height: 15),

              BudgetCard(
                selected: selectedBudget == 1,
                icon: "💛",
                title: "RM50 - RM100",
                badge: "Popular",
                subtitle:
                    "Mid-range products with proven ingredients",
                onTap: () {
                  setState(() {
                    selectedBudget = 1;
                  });
                },
              ),

              const SizedBox(height: 15),

              BudgetCard(
                selected: selectedBudget == 2,
                icon: "💎",
                title: "RM100+",
                badge: "Premium",
                subtitle:
                    "Premium & luxury skincare formulas",
                onTap: () {
                  setState(() {
                    selectedBudget = 2;
                  });
                },
              ),

            ],
          ),
        ),
      ),

      /// BOTTOM CONTINUE BUTTON
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 24,
          top: 14,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B21A8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: selectedBudget == -1
              ? null
              : () {

                  String budget = "";

                  switch (selectedBudget) {
                    case 0:
                      budget = "Budget";
                      break;

                    case 1:
                      budget = "Mid";
                      break;

                    case 2:
                      budget = "Premium";
                      break;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecommendationScreen(
                        skinType: "Oily", // temporary
                        budget: budget,
                      ),
                    ),
                  );
                },
          child: const Text(
            "Continue",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}