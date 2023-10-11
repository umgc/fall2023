import 'package:cogniopenapp/src/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //test code here!
  test('testing Settings', () {
    Settings settings = new Settings();
    expect(settings.locationEnabled, false);
  });

  test('testing Notification', () {
    Notification notification = Notification('1', 'Notification1', true);
    expect(notification.notificationID, '1');
    expect(notification.name, 'Notification1');
    expect(notification.isDisplayed, true);
  });
}
