import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:edt/pages/bottom_bar/provider/bottombar_provider.dart';
import 'package:edt/utils/helper.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

void complainDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: SizedBox(
              width: getWidth(context) * 0.85,
              // height: getHeight(context) * 0.61,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0, top: 15),
                        child: Icon(
                          Icons.close,
                          color: Color(0xff5A5A5A),
                        ),
                      ),
                    ),
                  ),
                  SvgPicture.asset('assets/icons/payment_success.svg'),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Send Successful',
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff2a2a2a)),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    'Your complain has been send successful',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff898989)),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 11, right: 11, bottom: 24),
                    child: GestureDetector(
                        onTap: () {
                          Provider.of<BottomNavProvider>(context,listen: false).setIndex(0);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomBar()),
                                  (route)=>false
                                  );
                        },
                        child: getContainer(context, 'Back Home')),
                  )
                ],
              )),
        ),
      );
    },
  );
}
