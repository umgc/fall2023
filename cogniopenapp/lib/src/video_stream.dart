import 'package:aws_kinesis_api/kinesis-2013-12-02.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VideoStreamer {
  //confidence setting for AWS Rekognition label detection service
  //(default is 50; the higher the more confident - and thus better and fewer results)
  //double confidence;
  Kinesis? service;
  int shardCount = 5;
  String streamName = "";
  //String jobId;

  Future<void> startService() async {
    await dotenv.load(fileName: ".env"); //load .env file variables
    streamName = dotenv.get('KinesisStreamName');
    service = Kinesis(
        region: dotenv.get('region'),
        credentials: AwsClientCredentials(
            accessKey: dotenv.get('accessKey'),
            secretKey: dotenv.get('secretKey')));
  }

  Future<ListStreamsOutput> checkForStream() {
    return service!.listStreams();
  }

  void listStreamsByName() {
    Future<ListStreamsOutput> streams = checkForStream();
    streams.then((value) {
      for (int i = 0; i < value.streamNames.length; i++) {
        print(value.streamNames[i].toString());
      }
    });
  }

  Future<void> createStream() async {
    Future<ListStreamsOutput> streamCheck = checkForStream();
    streamCheck.then((value) {
      if (value.streamNames.isEmpty) {
        print("Creating steam with name: $streamName.");
        service!.createStream(shardCount: shardCount, streamName: streamName);
      } else {
        print("Stream already exist!");
      }
      listStreamsByName();
    });
  }
}
