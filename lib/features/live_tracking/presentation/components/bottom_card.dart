import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_tracker/core/utils/app_colors.dart';

import '../../../../core/utils/app_text_styles.dart';

class BottomCard extends StatefulWidget {
  const BottomCard({super.key});

  @override
  State<BottomCard> createState() => _BottomCardState();
}

class _BottomCardState extends State<BottomCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(vertical: 10),
        //height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.background
        ),
        child: Column(
          children: [
          Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child:   Row(
              children: [
                Icon(Icons.access_time_sharp),
                SizedBox(
                  width: 9,
                ),
            Expanded(
              child: Text(
                "The package is estimated to arrive within the next 25 minutes.",
                  style: AppTextStyles.body,

              )),
              ],
            ),
          ),
          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.secondary
            ),

            child: Text("Info") ,
          ),)
          ],
        ),
      ),
    );
  }
}
