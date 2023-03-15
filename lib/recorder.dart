import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class Recorder {
  final recorder = FlutterSoundRecorder();
  final player = AudioPlayer();
  Future record() async {
    await recorder.startRecorder(toFile: "audio");
  }

  Future stop() async {
    final path = await recorder.stopRecorder();
    final audio = File(path!);
    await player.play(audio.path);
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'there is no mic';
    }
    await recorder.openRecorder();
  }
}
