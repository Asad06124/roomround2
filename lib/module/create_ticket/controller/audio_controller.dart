import 'package:just_audio/just_audio.dart';
import 'package:roomrounds/core/constants/imports.dart';

class AudioController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  RxInt? currentlyPlayingIndex = RxInt(-1);
  RxBool isPlaying = false.obs;
  String? recordedFilePath;

  @override
  void onInit() {
    player.setFilePath(recordedFilePath.toString());
    super.onInit();
  }

  @override
  void dispose() {
    player.dispose();
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
      await player.play();

      player.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          currentlyPlayingIndex!.value = -1;
          isPlaying.value = false;
        }
      });
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  Future<void> stopAudio() async {
    try {
      await player.stop();
      currentlyPlayingIndex!.value = -1;
      isPlaying.value = false;
    } catch (e) {
      debugPrint("Error stopping audio: $e");
    }
  }
}
