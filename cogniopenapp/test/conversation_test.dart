import 'package:cogniopenapp/src/media.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cogniopenapp/src/conversation.dart';

void main() {
  Conversation conversation = createTestMediaList()[6] as Conversation;
  //test code here!
  test("U-2-1: create a conversation", () {
    expect(conversation.summary, 'A test conversation');
  });
}
