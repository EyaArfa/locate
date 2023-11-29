import 'package:telephony/telephony.dart';
import './getPosition.dart';

void executeBackgroundFunction(SmsMessage sms) async {
  // Perform the desired action when a new SMS message arrives.
  print(
      'Received SMS:${sms.body!.toLowerCase().contains('find_me')}__${sms.address}__${sms.serviceCenterAddress}');
  if (sms.body!.toLowerCase().contains('find_me')) {
    var result = await determinePosition();
    Telephony.backgroundInstance.sendSms(
        to: sms.address!,
        message:
        'you can click here to get the result in maps https://www.google.com/maps/search/?api=1&query=${result.longitude},${result.latitude}');
  }
}