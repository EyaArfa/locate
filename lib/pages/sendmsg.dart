import 'package:app_settings/app_settings.dart';
import 'package:find_me/functions/getPosition.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:telephony/telephony.dart';

class SendMessagePage extends StatelessWidget {
  final _key = GlobalKey<FormState>();
  TextEditingController txtMsgController = TextEditingController();
  final Telephony telephony = Telephony.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _key,
            child: Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ask for Position',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,

                          color: Color(0xFF694881))),
                  Expanded(child: Image(image: AssetImage('assets/find.png'))),
                  TextFormField(
                    controller: txtMsgController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(prefixIcon: Icon(Icons.phone),hintText: 'Enter a phone number',border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),

                    validator: (value) {
                      if (value!.isEmpty) return 'please enter a valid number';
                      return null;
                    },
                  ),
                  TextButton(
                      onPressed: () async {
                        print(txtMsgController.text);

                        bool? permissionsGranted =
                        await telephony.requestPhoneAndSmsPermissions;

                        if (permissionsGranted == true &&
                            _key.currentState!.validate()) {
                          await telephony.sendSms(
                              to: txtMsgController.text, message: 'find_me');
                        }
                      },
                      child: Text('Send SMS')),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void executeFunction(SmsMessage sms) async {
  // Perform the desired action when a new SMS message arrives.

  if (sms.body!.toLowerCase().contains('find_me')) {
    Telephony telephony = Telephony.instance;
    var result = await determinePosition();
    telephony.sendSms(
        to: sms.address!,
        message:
            'you can click here to get the result in maps https://www.google.com/maps/search/?api=1&query=${result.latitude},${result.longitude}');
  }
}




