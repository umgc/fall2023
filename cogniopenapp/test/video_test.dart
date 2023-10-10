import 'package:cogniopenapp/src/video.dart';
import 'package:cogniopenapp/src/media.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Video video = createTestMediaList()[5] as Video;
  List<IdentifiedItem> identifiedItems = video.identifiedItems;
  //test code here!
  test("create a video", () {
    expect(video.duration, '2:30');
    expect(video.autoDelete, true);

    expect(identifiedItems.length, 2);
    if (identifiedItems.length == 2) {
      expect(identifiedItems[0].itemName, "Item 1");
      expect(identifiedItems[1].itemName, "Item 2");
    }
  });

  test("IdentifiedItem", () {
    IdentifiedItem item = identifiedItems[0];

    expect(item.itemName, "Item 1");
    expect(item.timeSpotted.day, DateTime.now().day);
    expect(item.itemImage, isNot(null));
  });
}
