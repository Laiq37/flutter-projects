import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

const pathToSaveAudio = "audio_example.aac";

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialized = false;

  bool get isRecording => _audioRecorder!.isRecording;

  Future init()async{
    _audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw RecordingPermissionException("Microphone permission not granted");
    }

    await _audioRecorder!.openRecorder();
    _isRecorderInitialized = true;
  }

  void dispose(){
    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    _isRecorderInitialized = false;
  }

  Future _record() async {
    if(!_isRecorderInitialized) return;
    await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

  Future<String?> _stop() async {
    if(!_isRecorderInitialized) return null;
    final path = await _audioRecorder!.stopRecorder();
    return path;
  }

  Future<String?> toggleRecording() async {
    // print("AudioRecorder $_audioRecorder");
    if (_audioRecorder!.isStopped) {
      await _record();
      return null;
    } else {
      final String? stopRes = await _stop();
      return stopRes;
    }
  }
}