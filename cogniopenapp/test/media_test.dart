// TODO -- Fix Tests

/*
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


  test('testing getStorageSizeString KB', () {
    //KB
    //expect(testMedia[0].getStorageSizeString(), '1.00 KB');
  });

  test('testing getStorageSizeString Bytes', () {
    //Bytes
    //expect(testMedia[2].getStorageSizeString(), '512 Bytes');
  });

  test('testing getStorageSizeString MB', () {
    //MB
    testMedia[3].storageSize = 10000000;
    //expect(testMedia[3].getStorageSizeString(), '9.54 MB');
  });

  test('testing getStorageSizeString GB', () {
    //GB
    testMedia[3].storageSize = 10000000000;
    //expect(testMedia[3].getStorageSizeString(), '9.31 GB');
  });

  test('testing getDateTimeString valid DateTime', () {
    //regular datetime
    //expect(testMedia[6].getDateTimeString(), '2023-10-05 00:00:00');
  });

  test('testing getDateTimeString null DateTime', () {
    //null
    DateTime? originalDateTime = testMedia[6].timeStamp;
    testMedia[6].timeStamp = null;
    //expect(testMedia[6].getDateTimeString(), 'Date unknown');
    testMedia[6].timeStamp = originalDateTime;
  });

  test('testing formatDateTime, valid Date', () {
    //regular datetime
    //expect(testMedia[6].formatDateTime(testMedia[6].timeStamp),
    //    'October 5th, 2023');
  });

  test('testing formatDateTime, null date', () {
    //null
    //expect(testMedia[6].formatDateTime(null), 'N/A');
  });
}
*/

// COPIED BELOW FROM MEDIA CLASS -- TODO: UT TESTING SETUP FILES IN TESTS
/*
// |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// |||||||||||||||||||||||||||||||||||||||||||||||||||||||FOR TESTING ONLY||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// Images taken from: https://www.yttags.com/blog/image-url-for-testing/
List<Media> createTestMediaList() {
  return [
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/spunky-sam.png'),
      Media(
        title: 'Spunky Sam',
        description: 'Avatar of Spunky Sam',
        tags: ['avatar', 'spunky'],
        timeStamp: DateTime.now(),
        storageSize: 1024,
        isFavorited: false,
      ),
    ),
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/spunky-sam-green.png'),
      Media(
        title: 'Spunky Sam (Green)',
        description: 'Green version of Spunky Sam avatar',
        tags: ['avatar', 'spunky', 'green'],
        timeStamp: DateTime.now(),
        storageSize: 2048,
        isFavorited: true,
      ),
    ),
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/purple-pi.png'),
      Media(
        title: 'Purple Pi',
        description: 'Avatar of Purple Pi',
        tags: ['avatar', 'purple', 'pi'],
        timeStamp: DateTime.now(),
        storageSize: 512,
        isFavorited: false,
      ),
    ),
    // Add more test objects for other URLs as needed
    // Photo for 'https://www.kasandbox.org/programming-images/avatars/purple-pi-teal.png'
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/purple-pi-teal.png'),
      Media(
        title: 'Purple Pi (Teal)',
        description: 'Teal version of Purple Pi avatar',
        tags: ['avatar', 'purple', 'teal'],
        timeStamp: DateTime.now(),
        storageSize: 1536,
        isFavorited: true,
      ),
    ),
    // Photo for 'https://www.kasandbox.org/programming-images/avatars/purple-pi-pink.png'
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/purple-pi-pink.png'),
      Media(
        title: 'Purple Pi (Pink)',
        description: 'Pink version of Purple Pi avatar',
        tags: ['avatar', 'purple', 'pink'],
        timeStamp: DateTime.now(),
        storageSize: 768,
        isFavorited: false,
      ),
    ),
    // Add more test objects for other URLs as needed
    Video(
      '2:30', // Duration
      true, // Auto-delete
      [
        IdentifiedItem(
          'Item 1',
          DateTime.now(), // Time spotted
          Image.network(
            'https://www.example.com/item1.jpg', // Item image URL
          ),
        ),
        IdentifiedItem(
          'Item 2',
          DateTime.now()
              .subtract(Duration(days: 1)), // Time spotted (1 day ago)
          Image.network(
            'https://www.example.com/item2.jpg', // Item image URL
          ),
        ),
      ],
      Image.network(
          'https://cdn.fstoppers.com/styles/article_med/s3/media/2020/05/18/exploration_is_key_to_making_unique_landscape_photos_01.jpg'),
      Media(
        title: 'Test Video',
        description: 'This is a placeholder for a video',
        tags: ['video', 'test'],
        timeStamp: DateTime.now(),
        storageSize: 4096,
        isFavorited: false,
      ), // Associated media (in this case, a photo)
    ),
    Conversation(
        "A test conversation",
        Media(
          title: "Conversation",
          description: "This is a sample conversation",
          tags: ["sample", "conversation"],
          timeStamp: DateTime(2023, 10, 5),
          storageSize: 2048, // 2 KB
          isFavorited: true,
        )),
  ];
}
*/
