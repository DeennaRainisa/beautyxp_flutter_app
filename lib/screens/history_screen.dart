import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../data/products.dart'; // Imports your hardcoded product data list
import '../models/product.dart'; // Imports your Product class model

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Looks up the item inside your data array to get exact category and image details
  Product? findProductByName(String name) {
    try {
      return allProducts.firstWhere(
        (p) => p.name.trim().toLowerCase() == name.trim().toLowerCase(),
      );
    } catch (_) {
      return null; // Return null safely if product isn't found
    }
  }

  // Returns beautiful UI formatting labels with matching emojis
  String getCategoryEmojiLabel(String category) {
    switch (category.toLowerCase()) {
      case "cleanser":
        return "🫧 Cleanser";
      case "moisturizer":
        return "💧 Moisturizer";
      case "sunscreen":
        return "☀️ Sunscreen";
      default:
        return "✨ Skincare";
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER (Perfect-Centered Title with Left-Aligned White Circular Back Button)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Analysis History",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44), // Balances out the back button perfectly
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// HISTORY LIST
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getAnalysisHistory(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF6B21A8)),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("✨", style: TextStyle(fontSize: 40)),
                          const SizedBox(height: 10),
                          Text(
                            "No history found yet.",
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      String skinType = data['skinType'] ?? 'Unknown';
                      String budget = data['budget'] ?? 'Unknown';
                      List<dynamic> products = data['products'] ?? [];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Card Meta Header (Skin Type, Budget & Delete Button)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Skin: $skinType  |  Budget: $budget",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF6B21A8),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () async {
                                    await firestoreService.deleteAnalysis(doc.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("History item deleted"),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const Divider(height: 20, color: Color(0xFFF3E8FF)),

                            /// Recommended Products list
                            if (products.isEmpty)
                              Text(
                                "No products selected",
                                style: TextStyle(color: Colors.grey[500], fontSize: 13),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: products.length,
                                itemBuilder: (context, pIndex) {
                                  String productName = products[pIndex];
                                  
                                  // Look up item inside your actual list asset mapping
                                  Product? matchedProduct = findProductByName(productName);

                                  // Extract exact variables or fall back if anything is missing
                                  String categoryLabel = matchedProduct != null 
                                      ? getCategoryEmojiLabel(matchedProduct.category)
                                      : "✨ Skincare";
                                      
                                  String assetPath = matchedProduct != null 
                                      ? matchedProduct.image 
                                      : "assets/images/default.png";

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        /// Left side: Real Asset Image Box
                                        Container(
                                          width: 60,
                                          height: 60,
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFDF7F8),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Image.asset(
                                            assetPath,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.spa_outlined,
                                                color: Color(0xFF6B21A8),
                                                size: 24,
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 14),

                                        /// Right side: Exact Category & Name
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                categoryLabel,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF6B21A8),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                productName,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1A1A1A),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}