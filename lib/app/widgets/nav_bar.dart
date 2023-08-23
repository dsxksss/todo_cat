import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo_cat/env.dart';
import 'package:window_manager/window_manager.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    super.key,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with WindowListener {
  bool isMaximize = false;

  @override
  void initState() {
    super.initState();
    updateMaximized();
  }

  void minimizeWindow() async {
    await windowManager.minimize();
  }

  void updateMaximized() async {
    final maximized = await windowManager.isMaximized();
    setState(() {
      isMaximize = maximized;
    });
  }

  void targetMaximizeWindow() async {
    if (isMaximize) {
      await windowManager.restore();
    } else {
      await windowManager.maximize();
    }
    updateMaximized();
  }

  void closeWindow() async {
    await windowManager.close();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => {windowManager.startDragging()},
      child: Container(
        width: 1.w,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "${"myTasks".tr} ${runMode.name}",
                    style: TextStyle(
                      fontSize: 60.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/imgs/logo.svg',
                    width: 100.w,
                    height: 100.w,
                  )
                ].animate().moveY(duration: 400.ms).fade(duration: 500.ms),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.outlined(
                    onPressed: minimizeWindow,
                    icon: Icon(
                      Icons.horizontal_rule_rounded,
                      size: 45.w,
                    ),
                  ),
                  SizedBox(
                    width: isMaximize ? 30.w : 20.w,
                  ),
                  isMaximize
                      ? Padding(
                          padding: EdgeInsets.only(top: 15.w),
                          child: IconButton.outlined(
                            onPressed: targetMaximizeWindow,
                            icon: Icon(
                              Icons.filter_none_rounded,
                              size: 30.w,
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 5.w),
                          child: IconButton.outlined(
                            onPressed: targetMaximizeWindow,
                            icon: Icon(
                              Icons.crop_square_rounded,
                              size: 40.w,
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 10.w,
                  ),
                  IconButton.outlined(
                    onPressed: closeWindow,
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                      size: 46.w,
                    ),
                  ),
                ]
                    .animate(interval: 100.ms)
                    .moveY(duration: 400.ms)
                    .fade(duration: 400.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
