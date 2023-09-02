import 'package:flutter/material.dart';

class CardListItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;

  const CardListItem({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          leading: SizedBox(
            width: 80,
            child: Image.network(
              imageUrl,
            ),
          ),
          title: Text(title),
          subtitle: Text(description),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap),
    );
  }
}
