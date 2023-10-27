class Settings {
  late bool locationEnabled = false;
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
