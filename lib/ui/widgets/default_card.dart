import 'package:flutter/material.dart';

class DefaultCard extends StatelessWidget {
  const DefaultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                Icon(Icons.credit_card, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  '',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          // Add card details here
        ],
      ),
    );
  }
}
