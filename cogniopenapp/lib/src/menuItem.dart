import 'dart:math';
import 'package:flutter/material.dart';

import 'media.dart';

// Used to test the media class functionality
void testMedia() {
  Media med = Media();
  med.description = "WOW";
  print(med.description);

  List<String> tags = [];
  DateTime time = DateTime.now();
  Media med2 = Media.overloaded("Title", "Description", tags, time, 1, false);
  print(med2.description);
}

// Used to test the notification/notification menu class functionality
void testNotification() {
  List<Notification> fakeNotifications = [];

  final random = Random();

  Icon testIcon = Icon(Icons.star, size: 48.0, color: Colors.yellow);

  for (int i = 1; i <= 10; i++) {
    final notificationID = 'ID_$i';
    final name = 'Notification $i';
    final isDisplayed = random.nextBool();

    final notification = Notification(notificationID, name, isDisplayed);
    fakeNotifications.add(notification);
  }

  fakeNotifications.add(Notification("TEST1", "TESTING", false));

  // Print the fake notifications
  fakeNotifications.forEach((notification) => print(notification));
  NotificationMenu noteMenu = NotificationMenu(fakeNotifications, testIcon);
  noteMenu.toggleNotification("TEST1");
  fakeNotifications.forEach((notification) => print(notification));
}

// We will want to extend this from a UI elemment for a screen
class MenuItem {
  final String _menuName;
  final Icon _menuIcon;
  // Screen menuScreen
  MenuItem(this._menuName, this._menuIcon);

  String get menuName => _menuName;
  Icon get menuIcon => _menuIcon;
}

class SettingsMenu extends MenuItem {
  Settings settings;
  SettingsMenu(this.settings, Icon icon) : super("SettingsMenu", icon);
}

class Notification {
  String _notificationID;
  String _name;
  // Is public as per dart's suggest guidelines to eliminate redundant setters/getters
  bool isDisplayed;

  Notification(this._notificationID, this._name, this.isDisplayed);

  // Getter for _notificationID
  String get notificationID => _notificationID;

  // Getter for _name
  String get name => _name;

  @override
  String toString() {
    return 'Notification{_notificationID: $_notificationID, _name: $_name, isDisplayed: $isDisplayed}';
  }
}

class NotificationMenu extends MenuItem {
  final List<Notification> notifications;

  NotificationMenu(this.notifications, Icon icon)
      : super("NotificationMenu", icon);

  void toggleNotification(String targetID) {
    Notification note = notifications
        .firstWhere((notification) => notification.notificationID == targetID);

    if (note != null) {
      note.isDisplayed = !note.isDisplayed;
    } else {
      print('Notification with ID $targetID not found.');
    }
  }
}

class GalleryMenu extends MenuItem {
  List<Media> galleryMedia;

  GalleryMenu(this.galleryMedia, Icon icon) : super("GalleryMenu", icon);
}
