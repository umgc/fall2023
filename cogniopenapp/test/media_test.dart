import 'package:cogniopenapp/src/media.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<Media> testMedia = createTestMediaList();

  //test code here!
  test('testing addTag', () {
    Media media = testMedia[0];
    //add an additional tag
    media.addTag('blue');

    //verify 3 tags, including blue
    expect(media.tags!.length, 3);
    expect(media.tags![0], "avatar");
    expect(media.tags![1], "spunky");
    expect(media.tags![2], "blue");
  });

  test('testing deleteTag', () {
    Media media = testMedia[0];
    //add an additional tag
    media.deleteTag('blue');

    //verify 2 tags
    expect(media.tags!.length, 2);
    expect(media.tags![0], "avatar");
    expect(media.tags![1], "spunky");
  });

  test('testing getStorageSizeString', () {
    //KB
    expect(testMedia[0].getStorageSizeString(), '1.00 KB');
    //Bytes
    expect(testMedia[2].getStorageSizeString(), '512 Bytes');
    //MB
    testMedia[3].storageSize = 10000000;
    expect(testMedia[3].getStorageSizeString(), '9.54 MB');
    //GB
    testMedia[3].storageSize = 10000000000;
    expect(testMedia[3].getStorageSizeString(), '9.31 GB');
  });

  test('testing getDateTimeString', () {
    //regular datetime
    expect(testMedia[6].getDateTimeString(), '2023-10-05 00:00:00');

    //null
    testMedia[6].timeStamp = null;
    expect(testMedia[6].getDateTimeString(), 'Date unknown');
  });

  test('testing formatDateTime', () {
    //regular datetime
    expect(testMedia[6].formatDateTime(testMedia[6].timeStamp),
        'October 5th, 2023');

    //null
    expect(testMedia[6].formatDateTime(null), 'N/A');
  });
}
