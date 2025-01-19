import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/bottom_bar/bottom_bar.dart';
import 'package:edt/widgets/back_button.dart';
import 'package:edt/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginOtpScreen extends StatelessWidget {
  const LoginOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var userPro=Provider.of<UserRoleProvider>(context);
    return Scaffold(
      appBar: getBackButton(context),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            'Account Verification',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Color(0xff2a2a2a),
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 13,
          ),
          Text(
            'Enter your OTP Code',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Color(0xffa0a0a0),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          OtpTextField(
            fieldHeight: 60,
            fieldWidth: 55,
            borderRadius: BorderRadius.all(Radius.circular(7)),
            numberOfFields: 5,
            focusedBorderColor: Color(0xff0F69DB),
            // enabledBorderColor: Colors.blue,
            showFieldAsBox: true,
            onCodeChanged: (String code) {},
            onSubmit: (String verificationCode) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Verification Code"),
                      content: Text('Code entered is $verificationCode'),
                    );
                  });
            },
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              spacing: 7,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Didn’t receive code?',
                  style: GoogleFonts.poppins(
                      color: Color(0xff5a5a5a),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  'Resend again',
                  style: GoogleFonts.poppins(
                      color: Color(0xff0F69DB),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomBar()));
              },
              child: getContainer(context, 'Verify')),
          )
        ],
      ),
    );
  }
}
