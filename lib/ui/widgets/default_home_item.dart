import 'package:flutter/material.dart';

class DefaultHomeItem extends StatelessWidget {
  final IconData iconData;
  final IconData rightIcon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool div;

  const DefaultHomeItem({
    this.iconData = Icons.info,
    this.rightIcon = Icons.chevron_right,
    this.title = "",
    required this.onTap,
    this.description = "",
    this.div = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(iconData, size: 25.0),
                  const SizedBox(height: 4.0),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  if (description.isNotEmpty) const SizedBox(height: 4.0),
                  if (description.isNotEmpty)
                    Text(
                      description.length <= 50
                          ? description
                          : '${description.substring(0, 50)}...', // Limita a 40 caracteres e adiciona "..."
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                ],
              ),
            ),
            const Spacer(),
            Icon(rightIcon,
                size: 30, color: const Color.fromARGB(255, 192, 191, 191)),
            const SizedBox(
              width: 20,
            )
          ]),
          if (div)
            const Divider(
              color: Color.fromARGB(255, 218, 218, 218),
              thickness: 1,
              indent: 5,
              endIndent: 5,
            ),
        ],
      ),
    );
  }
}
