import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class BottomCard extends StatefulWidget {
  final RoadInfo? roadInfo;
   const BottomCard({super.key, required this.roadInfo});

  @override
  State<BottomCard> createState() => _BottomCardState();
}

class _BottomCardState extends State<BottomCard> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
      //  width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.background,
        ),
        child: Column(
          children: [
            _buildEtaRow(),
             SizedBox(height: 15),
            _buildMainCard(),
             SizedBox(height: 8),

          ],
        ),
      ),
    );
  }

  Widget _buildEtaRow() {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 29.5.w, vertical: 16.h),
      child: Row(
        children: [
          Icon(
              Icons.access_time_sharp,
              size: 18,
              color: Color(0xff666666)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "The package is estimated to arrive within the next ${widget.roadInfo?.duration  == null
                  ? "calculating"
                  : (widget.roadInfo!.duration! / 60).round()} minutes.",
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.secondary,
        ),
        child: Column(
          children: [
            _buildCourierRow(),
            const SizedBox(height: 15),
            _buildOrderRow(),
             SizedBox(height: 20.h),
            _buildJourneyStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildCourierRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/images/person.png"),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Presley Williams", style: AppTextStyles.title),
                Text(
                  "Courier",
                  style:AppTextStyles.greyTexts,
                ),
              ],
            ),
          ],
        ),
        _buildCallButton(),
      ],
    );
  }

  Widget _buildCallButton() {
    return Container(

      padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.containerColor,
      ),
      child: Row(
        children: [
          Container(
            height: 24.w,
            width: 24.w,
            //padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
            ),
            child: Icon(
              Icons.phone_outlined,
              size: 14,
              color: AppColors.containerColor,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            "Call",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xffFFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID",
              style: AppTextStyles.greyTexts,
            ),
            Text(
              "ORD-682834513",
              style: AppTextStyles.semiBold,
            ),
          ],
        ),
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 19.5),
      decoration: BoxDecoration(
        color: const Color(0xfff6f0eb),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: const [
          CircleAvatar(
            radius: 3,
            backgroundColor: Color(0xfff3801f),
          ),
          SizedBox(width: 5),
          Text(
            "On Delivery",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xfff3801f),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyStatus() {
    return Row(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1,
                  color: const Color(0xfffd4c00),
                ),
              ),
              child: const CircleAvatar(
                radius: 5,
                backgroundColor: Color(0xfffd4c00),
              ),
            ),
             SizedBox(
              height: 60,
              child: DottedLine(direction: Axis.vertical),
            ),
            const Icon(Icons.location_on_outlined),
          ],
        ),
        const SizedBox(width: 5),
        Expanded(child: _buildJourneyDetails()),
      ],
    );
  }

  Widget _buildJourneyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopJourneyInfo(),
        SizedBox(height: 28.h),
        _buildBottomJourneyInfo(),
      ],
    );
  }

  Widget _buildTopJourneyInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  [
       Expanded(
         child:  Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               "On Delivery",
               style: AppTextStyles.greyTexts,
             ),
             Text(
               "Courier is delivering the package",
               style: GoogleFonts.inter(
                   fontSize: 12,
                   fontWeight: FontWeight.w500,
                   color: Color(0xff1b1c1e)
               ),
             ),
             Text(
               "${widget.roadInfo?.duration == null ? "calculating" : (widget.roadInfo!.duration! / 60).round()} minutes to destination.",
               style: AppTextStyles.greyTexts,
             ),
           ],
         ),
       ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "10:47 AM",
              style: AppTextStyles.greyTexts,
            ),
            Text(
                "18 Jan, 2026",
              style: AppTextStyles.semiBold,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomJourneyInfo() {
    return Column(
      children:  [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                "Delivered",
              style: AppTextStyles.greyTexts,
            ),
            SizedBox(width: 80, child: DottedLine(
                direction: Axis.horizontal,
              dashColor: AppColors.grey,
            )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                "Akobo, Ibadan",
              style: AppTextStyles.semiBold,
            ),
            SizedBox(width: 80, child: DottedLine(direction: Axis.horizontal)),
          ],
        ),
      ],
    );
  }
}