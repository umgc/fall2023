// ignore_for_file: avoid_print

import 'package:cogniopenapp/src/database/model/video_response.dart';
import 'package:cogniopenapp/src/data_service.dart';
import 'package:flutter/material.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'dart:core';

class ResponseParser {
  static VideoResponse? getRequestedResponse(String searchTitle) {
    for (int i = DataService.instance.responseList.length - 1; i >= 0; i--) {
      if (DataService.instance.responseList[i].title == searchTitle) {
        return DataService.instance.responseList[i];
      }
    }
    return null;
  }

  static List<VideoResponse> getListOfResponses() {
    List<String> trackedTitles = [];
    List<VideoResponse> responses = [];
    for (int i = DataService.instance.responseList.length - 1; i >= 0; i--) {
      String title = DataService.instance.responseList[i].title;
      if (!trackedTitles.contains(title)) {
        trackedTitles.add(title);
        responses.add(DataService.instance.responseList[i]);
      }
    }
    print(responses);
    return responses;
  }

  static Future<Image> getThumbnail(VideoResponse response) async {
    String fullPath =
        "${DirectoryManager.instance.videosDirectory.path}/${response.referenceVideoFilePath}";
    print("${fullPath}");
    return await FileManager.getThumbnail(fullPath, response.timestamp);
  }
}
