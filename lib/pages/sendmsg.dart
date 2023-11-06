import 'package:app_settings/app_settings.dart';
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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ask for Position',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey)),
              TextFormField(
                controller: txtMsgController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: 'Enter a phone number'),
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
                  child: Text('Send SMS'))
            ],
          ),
        ),
      ),
    );
  }
}

void executeFunction(SmsMessage sms) async {
  // Perform the desired action when a new SMS message arrives.
  print(
      'Received SMS:${sms.body!.toLowerCase() == 'find_me'}__${sms.address}__${sms.serviceCenterAddress}');
  if (sms.body!.toLowerCase().contains('find_me')) {
    Telephony telephony = Telephony.instance;
    var result = await _determinePosition();
    telephony.sendSms(
        to: sms.address!,
        message:
            'you can click here to get the result in maps https://www.google.com/maps/search/?api=1&query=${result.latitude},${result.longitude}');
  }
}

void executeBackgroundFunction(SmsMessage sms) async {
  // Perform the desired action when a new SMS message arrives.
  print(
      'Received SMS:${sms.body!.toLowerCase().contains('find_me')}__${sms.address}__${sms.serviceCenterAddress}');
  if (sms.body!.toLowerCase().contains('find_me')) {
    var result = await _determinePosition();
    Telephony.backgroundInstance.sendSms(
        to: sms.address!,
        message:
            'you can click here to get the result in maps https://www.google.com/maps/search/?api=1&query=${result.longitude},${result.latitude}');
  }
}

Future<Position> _determinePosition() async {
  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  var result = await Geolocator.getCurrentPosition().then((value) => value);
  return result;
}
