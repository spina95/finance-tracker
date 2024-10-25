import 'package:flutter/material.dart';

class CustomCardWidget extends StatefulWidget {
  final Widget content;
  final String? title;
  final Widget? widget;

  const CustomCardWidget(
      {super.key, required this.content, this.title, this.widget});

  @override
  _CustomCardWidgetState createState() => _CustomCardWidgetState();
}

class _CustomCardWidgetState extends State<CustomCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.title != null)
                  Text(
                    widget.title!,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                if (widget.widget != null) widget.widget!
              ],
            ),
          ),
          widget.content,
        ],
      ),
    );
  }
}
