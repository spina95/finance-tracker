import 'package:flutter/material.dart';

class CustomCardWidget extends StatefulWidget {
  final Widget content;
  final String? title;
  final Widget? widget;
  final Function? onTap;

  const CustomCardWidget({
    super.key,
    required this.content,
    this.title,
    this.widget,
    this.onTap,
  });

  @override
  _CustomCardWidgetState createState() => _CustomCardWidgetState();
}

class _CustomCardWidgetState extends State<CustomCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title!,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.8),
                        ),
                  ),
                  if (widget.widget != null) widget.widget!
                ],
              ),
            ),
          InkWell(
            onTap: widget.onTap == null
                ? null
                : () {
                    widget.onTap!();
                  },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).cardColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 0),
                      blurRadius: 50,
                      spreadRadius: 0,
                    ),
                  ]),
              child: widget.content,
            ),
          ),
        ],
      ),
    );
  }
}
