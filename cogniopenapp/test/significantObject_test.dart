import 'package:cogniopenapp/src/significantObject.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  //test code here!
  test('testing deleteAlternateName', () {
    List<Image> images = [
      Image.asset('eyeglass-frame.jpg'),
      Image.asset('eyeglass-green.jpg')
    ];
    List<String> names = ['black glasses', 'green glasses'];
    SignificantObject so = SignificantObject('glasses', images, names);
    expect(so.alternateNames.length, 2);

    so.deleteAlternateName('black glasses');
    expect(so.alternateNames.length, 1);
  });

  test('testing addAlternateName', () {
    List<Image> images = [
      Image.asset('eyeglass-frame.jpg'),
      Image.asset('eyeglass-green.jpg')
    ];
    List<String> names = ['black glasses'];
    SignificantObject so = SignificantObject('glasses', images, names);
    expect(so.alternateNames.length, 1);

    so.addAlternateName('green glasses');
    expect(so.alternateNames.length, 2);
  });
}