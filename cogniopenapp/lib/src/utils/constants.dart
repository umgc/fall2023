// Colors:

// Strings:

// Directory Names:
const String filesDirName = "files";
const String photosDirName = "photos";
const String audiosDirName = "audios";
const String audioTranscriptsDirName = "transcripts";
const String videosDirName = "videos";
const String videoStillsDirName = "stills";
const String videoResponsesDirName = "responses";

// Directory Paths (relative to ApplicationDocumentsDirectory):
const String filesPath = "/$filesDirName";
const String photosPath = "$filesPath/$photosDirName";
const String audiosPath = "$filesPath/$audiosDirName";
const String audioTranscriptsPath = "$audiosPath/$audioTranscriptsDirName";
const String videosPath = "$filesPath/$videosDirName";
const String videoStillsPath = "$videosPath/$videoStillsDirName";
const String videoResponsesPath = "$videosPath/$videoResponsesDirName";