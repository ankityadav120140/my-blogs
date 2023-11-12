import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> saveImageLocally(int id, File image) async {
  try {
    final appDocDir = await getApplicationDocumentsDirectory();
    final localImagePath = '${appDocDir.path}/image_${id}.png';
    final File localImageFile = await image.copy(localImagePath);
    return localImageFile.path;
  } catch (e) {
    print('Error saving image locally: $e');
    return '';
  }
}
