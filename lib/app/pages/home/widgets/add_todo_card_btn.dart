import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:todo_cat/app/data/schemas/task.dart';
import 'package:todo_cat/app/pages/home/controller.dart';
import 'package:todo_cat/app/pages/home/widgets/add_todo_dialog.dart';

class AddTodoCardBtn extends StatelessWidget {
  AddTodoCardBtn({super.key, required this.task});
  final HomeController ctrl = Get.find();
  final Task task;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {ctrl.selectTask(task), showAddTodoDialog(task)},
      child: Container(
        width: 1.sw,
        margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(238, 238, 240, 1),
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 36.w,
                color: Colors.grey[600],
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                "addTodo".tr,
                style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAddTodoDialog(Task task) {
  Get.generalDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: 250.ms,
    pageBuilder: (_, __, ___) {
      return GestureDetector(child: const AddTodoDialog());
    },
  );
}
