import 'package:cogniopenapp/src/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //test code here!
  test('U-7-1: testing Settings', () {
    Settings settings = new Settings();
    expect(settings.locationEnabled, false);
  });

  test('U-7-2: testing Notification', () {
    Notification notification = Notification('1', 'Notification1', true);
    expect(notification.notificationID, '1');
    expect(notification.name, 'Notification1');
    expect(notification.isDisplayed, true);
  });
}
