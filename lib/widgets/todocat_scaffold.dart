import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo_cat/widgets/nav_bar.dart';

class TodoCatScaffold extends StatelessWidget {
  const TodoCatScaffold({super.key, required this.body});
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            child: Column(
              children: [
                SizedBox(
                  height: Platform.isMacOS ? 100 : 80,
                ),
                Expanded(
                  child: body,
                ),
              ],
            ),
          ),
          const Positioned(top: 0, child: NavBar()),
        ],
      ),
    );
  }
}