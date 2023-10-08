import 'package:flutter/material.dart';

class CardListItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;
  final Icon trailing;

  const CardListItem({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
    this.trailing = const Icon(Icons.chevron_right)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          width: 90,
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
          ),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
