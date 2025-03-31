import 'package:path_provider/path_provider.dart';

Future<String> generateVoiceFilePath() async {
  final dir = await getApplicationDocumentsDirectory();
  return '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
}
