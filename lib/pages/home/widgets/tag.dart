import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  const Tag({super.key, required String tag, required Color color})
      : _color = color,
        _tag = tag;
  final String _tag;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(
          4,
        ),
      ),
      child: Center(
        child: Text(
          _tag,
          style: TextStyle(
              color: _color, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
