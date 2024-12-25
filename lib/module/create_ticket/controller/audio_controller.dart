import 'package:just_audio/just_audio.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AudioController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  final PlayerController waveformController = PlayerController();
  RxInt? currentlyPlayingIndex = RxInt(-1);
  RxBool isPlaying = false.obs;
  String? recordedFilePath;

  @override
  void onInit() {
    super.onInit();
    player.playerStateStream.listen((state) {
      // Synchronize waveform controller with audio player state
      if (state.processingState == ProcessingState.completed) {
        waveformController.stopPlayer();
        currentlyPlayingIndex!.value = -1;
        isPlaying.value = false;
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    waveformController.dispose();
    super.dispose();
  }

  Future<void> playAudio(String audioUrl, int index) async {
    if (currentlyPlayingIndex!.value == index) {
      await stopAudio();
      return;
    }

    if (currentlyPlayingIndex!.value != -1) {
      await stopAudio();
    }

    currentlyPlayingIndex!.value = index;
    recordedFilePath = audioUrl;
    isPlaying.value = true;

    try {
      await player.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
      waveformController.startPlayer();
      await player.play();

      player.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          currentlyPlayingIndex!.value = -1;
          isPlaying.value = false;
          waveformController.stopPlayer();
        }
      });
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  Future<void> stopAudio() async {
    try {
      await player.stop();
      waveformController.stopPlayer();
      currentlyPlayingIndex!.value = -1;
      isPlaying.value = false;
    } catch (e) {
      debugPrint("Error stopping audio: $e");
    }
  }
}
