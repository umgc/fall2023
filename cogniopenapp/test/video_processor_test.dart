/*import 'package:flutter_test/flutter_test.dart';
import 'package:aws_s3_api/s3-2006-03-01.dart' as AWSS3API;
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as AWSRekognitionAPI;
import 'package:cogniopenapp/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'video_processor_test.mocks.dart';
import 'package:cogniopenapp/src/video_processor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@GenerateMocks([AWSRekognitionAPI.Rekognition, AWSRekognitionAPI.S3Object, AWSRekognitionAPI.GetLabelDetectionResponse, AWSS3API.S3])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Tests the ability of CogniOpen to tag videos', () async {
    final clientRekognition = MockRekognition();
    final clientS3 = MockS3();
    final clientS3Object = MockS3Object();
    when(clientS3.putObject(bucket: "", key: ""));
    VideoProcessor vp = VideoProcessor();
//    await vp.sendRequestToProcessVideo("fire_extinguisher.mp4");
  });
}
*/