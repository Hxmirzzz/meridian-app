import 'package:audioplayers/audioplayers.dart';

class AlarmSoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playAlarm() async {
    await _player.setAudioContext(AudioContext(
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.alarm,
        audioFocus: AndroidAudioFocus.gain,
      ),
    ));

    // Reproduce en loop
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('sounds/alarm.mp3'));
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}