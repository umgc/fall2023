/// Importing required packages and screens.
import 'package:aws_s3_api/s3-2006-03-01.dart' as s3API;
import 'package:cogniopenapp/src/data_service.dart';
import 'package:cogniopenapp/src/s3_connection.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
/// FlutterSound provides functionality for recording and playing audio.
import 'package:flutter_sound/flutter_sound.dart';

/// Permission handler is used for handling permissions like microphone and storage access.
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
/// Path provider helps in getting system directory paths to store the recorded audio.
import 'package:path_provider/path_provider.dart';
/// Importing AWS Transcribe API and s3 bucket
import 'package:aws_transcribe_api/transcribe-2017-10-26.dart' as trans;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:dart_openai/dart_openai.dart';

// Record button glow effect
import 'package:avatar_glow/avatar_glow.dart';

/// Importing other application screens for navigation purposes.
import 'homeScreen.dart';
import 'assistantScreen.dart';
import 'searchScreen.dart';
import 'galleryScreen.dart';
import 'settingsScreen.dart';
const API_URL = 'https://api.openai.com/v1/completions';
final API_KEY = dotenv.env['OPEN_AI_API_KEY']; // Replace with your API key
/// AudioScreen widget provides the main interface for audio recording.
class AudioScreen extends StatefulWidget {
  @override
  _AudioScreenState createState() => _AudioScreenState();
}
class _AudioScreenState extends State<AudioScreen> {
  /// FlutterSoundRecorder is responsible for recording audio.
  FlutterSoundRecorder? _recorder;
  
  /// FlutterSoundPlayer is responsible for playing back the recorded audio.
  FlutterSoundPlayer? _player;

  /// Flags to track if recording or playback is currently in progress.
  bool _isRecording = false;
  bool _isPlaying = false;

  /// Variable to track the duration of the current recording.
  Duration _duration = const Duration(seconds: 0);

  /// This variable will store the path where the recorded audio will be saved.
  String? _pathToSaveRecording;

  /// Timer is used to update the duration of the recording in real-time.
  Timer? _timer;

    
  // variables from env for s3
  final _bucketName = dotenv.env['videoS3Bucket'];
  final service = trans.TranscribeService(
    region: dotenv.env['region']!,
    credentials: trans.AwsClientCredentials(
      accessKey: dotenv.env['accessKey']!,
      secretKey: dotenv.env['secretKey']!,
    ),
  );
  var key2 = '';

  S3Bucket s3Connection = S3Bucket();

  String transcription = '';
  String transcriptionSummary = '';
  
  @override
  void initState() {
    super.initState();

    /// Initializing recorder and player instances.
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();

    /// Setting up the recorder by checking permissions.
    _initializeRecorder();
    _startRecording();
  }

  /// This function initializes the recorder by checking necessary permissions.
  Future<void> _initializeRecorder() async {
    bool permissionsGranted = await _requestPermissions();
    
    if (!permissionsGranted) {
      return;
    }
    await _recorder!.openRecorder();
  }

  /// This function requests necessary permissions for audio recording and storage.
  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
      
    ].request();
    return statuses[Permission.microphone]!.isGranted &&
        statuses[Permission.storage]!.isGranted;
        
  }

  @override
  void dispose() {
    /// Cleanup operations: It's important to release resources to prevent memory leaks.
    _recorder!.closeRecorder();
    _player?.closePlayer();
    _timer?.cancel();
    super.dispose();
  }

  /// Function to handle the starting of audio recording.
  Future<void> _startRecording() async {
    bool permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) {
      return;
    }
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    key2 = DateTime.now().millisecondsSinceEpoch.toString();
    _pathToSaveRecording = '${appDocDirectory.path}/files/audios/$key2.wav'; // creates unique name
    debugPrint('initial app directory $appDocDirectory');

    await _recorder!.startRecorder(toFile: _pathToSaveRecording, codec: Codec.pcm16WAV);
    setState(() {
      _isRecording = true;
    });

    /// Timer to periodically update the duration of the audio recording in the UI.
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (_isRecording) {
        setState(() {
          _duration = _duration + Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _stopRecording() async {
    final path = await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    _timer?.cancel();
    final audioFile = File(_pathToSaveRecording!);
    print('Recorded audio: $audioFile');
    // Call Transcription after stopping the recording
    final s3UploadUrl = await s3Connection.addAudioToS3(key2, _pathToSaveRecording!) ;
    if (s3UploadUrl != null) {
      print(s3UploadUrl);
      _transcribeAudio(s3UploadUrl);
    }
  }

  /// Function to handle starting the playback of the recorded audio.
  Future<void> _startPlayback() async {
    debugPrint('$_pathToSaveRecording');
    await _player!.openPlayer();
    await _player!.startPlayer(

        fromURI: ('$_pathToSaveRecording'),
        whenFinished: () {
          setState(() {
            _isPlaying = false;


          });
          _player!.closePlayer();
        });
    setState(() {
      _isPlaying = true;
    });
  }

  /// Function to handle stopping the playback of the recorded audio.
  Future<void> _stopPlayback() async {
    await _player!.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
    _player!.closePlayer();
  }

  Future<void> _transcribeAudio(String s3Url) async {
    // Ensure AWS credentials are properly configured
    try {
      String s3Uri = "s3://$_bucketName/$s3Url";
      print(s3Uri);

      // Starting the transcription job
      final response = await service.startTranscriptionJob(
        transcriptionJobName: '${key2}transcript',
        media: trans.Media(mediaFileUri: s3Uri),
        mediaFormat: trans.MediaFormat.wav,
        languageCode: trans.LanguageCode.enUs,
        settings: trans.Settings(
          showSpeakerLabels: true,
          maxSpeakerLabels: 2, // specify the number of speakers you expect, adjust as needed
        ),
      );

      print('Transcription job started with status: ${response.transcriptionJob?.transcriptionJobStatus}');

      // Poll for the transcription job's status
      while (true) {
        final jobResponse = await service.getTranscriptionJob(
          transcriptionJobName: '${key2}transcript',
        );
        if (jobResponse.transcriptionJob?.transcriptionJobStatus.toString() == 'TranscriptionJobStatus.completed') {
          final transcriptUri = jobResponse.transcriptionJob?.transcript?.transcriptFileUri;
          if (transcriptUri != null) {
            final transcriptResponse = await http.get(Uri.parse(transcriptUri));
            if (transcriptResponse.statusCode == 200) {
              var jsonResponse = jsonDecode(transcriptResponse.body);
              var items = jsonResponse['results']['items'];

              // construct transcription text with speaker labels
              // Construct transcription text with speaker labels and start on a new line for each speaker
        var fullTranscription = '';
        String? currentSpeaker;

        for (var item in items) {
            // Check for speaker label
            if (item['type'] == 'pronunciation' && item.containsKey('speaker_label')) {
                String speakerLabel = _getCustomSpeakerLabel(item['speaker_label']);
                if (currentSpeaker != speakerLabel) {
                    fullTranscription += '\n$speakerLabel: ';
                    currentSpeaker = speakerLabel;
                }
                fullTranscription += item['alternatives'][0]['content'] + ' ';
            } else if (item['type'] == 'punctuation') {
                fullTranscription = fullTranscription.trim() + item['alternatives'][0]['content'] + ' ';
            }
          }
            setState(() {
              transcription = fullTranscription.trim();
            });
            } else {
              print('Failed to fetch transcript: ${transcriptResponse.statusCode}');
            }
            break;
          }
        } else if (jobResponse.transcriptionJob?.transcriptionJobStatus.toString() == 'TranscriptionJobStatus.failed') {
          print('Transcription job failed');
          break;
        }
        // Wait for a short interval before polling again
        await Future.delayed(Duration(seconds: 2));
      }
    } catch (e) {
      print('Error starting transcription: $e');
    }
    _saveTranscriptionToFile('${key2}transcript');
   
}

String _getCustomSpeakerLabel(String awsSpeakerLabel) {
  if (awsSpeakerLabel == 'spk_0') {
    return 'Speaker 1';
  } else if (awsSpeakerLabel == 'spk_1') {
    return 'Speaker 2';
  } else if (awsSpeakerLabel == 'spk_2') {
    return 'Speaker 3';
  } else if (awsSpeakerLabel == 'spk_3') {
    return 'Speaker 4';
  } else {
    return awsSpeakerLabel;
  }
}

Future _saveTranscriptionToFile(String transcriptionJobName) async {
  if (transcription.isEmpty) {
    print("Transcription is empty. Nothing to save.");
    return;
  }

  try {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDirectory.path}/files/audios/transcripts/$transcriptionJobName.txt';

    File file = File(filePath);
    await file.writeAsString(transcription);

    print("Transcription saved at $filePath");
    transcriptionSummary = await summarizeFileContent(transcriptionJobName);
    _saveTranscriptionSummaryToFile(transcriptionJobName);
  } catch (e) {
    print("Error saving transcription");
  }
}
// save transcription summary
Future<void> _saveTranscriptionSummaryToFile(String transcriptionSummaryName) async {
  if (transcriptionSummary.isEmpty) {
    print("Transcription summary is empty. Nothing to save");
    return;
  }

  try {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDirectory.path}/files/audios/transcripts/${transcriptionSummaryName}summary.txt';

    File file = File(filePath);
    await file.writeAsString(transcriptionSummary);
    
    print("Transcription Summary saved at $filePath");
    _sendToDatabase();  
  } catch (e) {
    print("Error saving transcription");
  }
}
// create a function to delete object
Future<void> _deleteAudioRecording() async {
  await s3Connection.deleteFileFromS3(key2);
  //await s3Connection.deleteFileFromS3('${key2}transcript');
  // delete file from device
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  await deleteFileFromDevice('${appDocDirectory.path}/files/audios/$key2.wav');
  await deleteFileFromDevice('${appDocDirectory.path}/files/audios/transcripts/${key2}transcript.txt');
}

Future<bool> deleteFileFromDevice(String path) async {
  try {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      return true;
    } else {
      print('File does not exist at path: $path');
      return false;
    }
  } catch (e) {
    print('Failed to delete the file from device: $e');
    return false;
  }
}

Future<String> summarizeFileContent(String fileName) async {
  try {
    // Read file content
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/files/audios/transcripts/$fileName.txt');
    String content = await file.readAsString();

    // Send to OpenAI for Summarization
    final response = await http.post(
      Uri.parse(API_URL),
      headers: {
        'Authorization': 'Bearer $API_KEY',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': 'Summarize: $content',
        'max_tokens': 150, // Adjust this as we need to
        'model': 'text-davinci-003',
      }),
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['choices'][0]['text'].trim());
      return jsonResponse['choices'][0]['text'].trim();
    } else {
      print('Failed to summarize. Response code: ${response.statusCode}');
      return '';
    }
  } catch (e) {
    print('Error during summarization: $e');
    return '';
  }
}

Future<void> _sendToDatabase() async {
   // call add method to db
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String audioFilePath = '${appDocDirectory.path}/files/audios/$key2.wav';
    String transcriptFilePath = '${appDocDirectory.path}/files/audios/transcripts/${key2}transcript.txt';
       await DataService.instance.addAudio(
          title: key2,
          description: "",
          tags: [],
          audioFile: File(audioFilePath),
          transcriptFile: File(transcriptFilePath),
          summary: transcriptionSummary);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color(0x440000),
        elevation: 0,
        centerTitle: true,

        leading: const BackButton(
            color: Colors.black54
        ),
        title: const Text('Audio Recording', style: TextStyle(color: Colors.black54)),
      ),
      body: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/background.jpg"),
        fit: BoxFit.cover,
          ),
        ),

        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    if (_isRecording)
              Column(
            children: [

            AvatarGlow(
            glowColor: Colors.red,
              endRadius: 100.0,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(     // Replace this child with your own
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  radius: 70.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(75.0),
                                )
                            )
                        ),
                        onPressed: () async {
                          await _stopRecording();
                        }, child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.stop, size: 65, color: Colors.red),
                          Text("Stop Audio Recording", textAlign: TextAlign.center,)
                        ],
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
              Text(
                _duration.toString().split('.').first.padLeft(8, "0"),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

                    ],
              )
                    else if (_pathToSaveRecording != null)
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed:
                            _isPlaying ? _stopPlayback : _startPlayback,
                            child: Text(
                                _isPlaying ? 'Stop Preview' : 'Play Preview'),
                          ),


                          ElevatedButton(
                            onPressed: () async {
                            await _deleteAudioRecording();
                              /// Notify user that the recording has been deleted
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Recording Deleted!')),
                              );
                            },

                            child: const Text('Delete'),
                          ),


                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _pathToSaveRecording = null;
                                _duration = const Duration(seconds: 0);
                                transcription = '';
                              });
                            },
                            child: const Text('Cancel'),
                          ),

                        ],
                      )
                    else
                      AvatarGlow(
                        glowColor: Colors.blue,
                        endRadius: 100.0,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child:Material(     // Replace this child with your own
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(

                            backgroundColor: const Color(0xFFFFFFFF),
                            radius: 70.0,
                            child: TextButton(
                              onPressed: _startRecording,
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(75.0),
                                      )
                                  )
                              ),

                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.mic, size: 60, color: Colors.green),
                                  Text("Start Audio Recording", textAlign: TextAlign.center,)
                                ],
                              ),
                            ),
                          ),
                        ),

                      ),
                    
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          transcription,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

        bottomNavigationBar: BottomNavigationBar(
            elevation: 0.0,

            items: const [
              BottomNavigationBarItem(
                backgroundColor: Color(0x00ffffff),
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.back_hand_rounded),
                label: 'Virtual Assistant',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo),
                label: 'Gallery',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            onTap: (int index) {
              // Handle navigation bar item taps
              if (index == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              } else if (index == 1) {
                // Navigate to Search screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AssistantScreen()));
              } else if (index == 2) {
                // Navigate to Gallery screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GalleryScreen()));
              } else if (index == 3) {
                // Navigate to Gallery screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              }
            }
        )
    );
  }
}