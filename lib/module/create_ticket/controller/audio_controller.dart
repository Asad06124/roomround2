import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  final PlayerController waveformController = PlayerController();
  RxInt? currentlyPlayingIndex = RxInt(-1);
  RxBool isPlaying = false.obs;
  RxBool isLoading = false.obs; // New loading state
  String? recordedFilePath;

  @override
  void onInit() {
    super.onInit();
    player.playerStateStream.listen((state) {
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
    isLoading.value = true; // Start loading

    try {
      await player.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
      isLoading.value = false; // Stop loading
      isPlaying.value = true;

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
      isLoading.value = false; // Stop loading on error
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

// class AudioController extends GetxController {
//   final AudioPlayer player = AudioPlayer();
//   final PlayerController waveformController = PlayerController();
//   RxInt? currentlyPlayingIndex = RxInt(-1);
//   RxBool isPlaying = false.obs;
//   String? recordedFilePath;

//   @override
//   void onInit() {
//     super.onInit();
//     player.playerStateStream.listen((state) {
//       // Synchronize waveform controller with audio player state
//       if (state.processingState == ProcessingState.completed) {
//         waveformController.stopPlayer();
//         currentlyPlayingIndex!.value = -1;
//         isPlaying.value = false;
//       }
//     });
//   }

//   @override
//   void dispose() {
//     player.dispose();
//     waveformController.dispose();
//     super.dispose();
//   }

//   Future<void> playAudio(String audioUrl, int index) async {
//     if (currentlyPlayingIndex!.value == index) {
//       await stopAudio();
//       return;
//     }

//     if (currentlyPlayingIndex!.value != -1) {
//       await stopAudio();
//     }

//     currentlyPlayingIndex!.value = index;
//     recordedFilePath = audioUrl;
//     isPlaying.value = true;

//     try {
//       await player.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
//       waveformController.startPlayer();
//       await player.play();

//       player.playerStateStream.listen((playerState) {
//         if (playerState.processingState == ProcessingState.completed) {
//           currentlyPlayingIndex!.value = -1;
//           isPlaying.value = false;
//           waveformController.stopPlayer();
//         }
//       });
//     } catch (e) {
//       debugPrint("Error playing audio: $e");
//     }
//   }

//   Future<void> stopAudio() async {
//     try {
//       await player.stop();
//       waveformController.stopPlayer();
//       currentlyPlayingIndex!.value = -1;
//       isPlaying.value = false;
//     } catch (e) {
//       debugPrint("Error stopping audio: $e");
//     }
//   }
// }
