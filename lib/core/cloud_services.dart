// import 'dart:io';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class CloudinaryService {
//   final String cloudName = 'dmhjjvk5p';
//   final String uploadPreset = 'posts_upload';

//   Future<String> uploadImage(File imageFile) async {
//     final url =
//         Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

//     final request = http.MultipartRequest('POST', url)
//       ..fields['upload_preset'] = uploadPreset
//       ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final resStream = await http.Response.fromStream(response);
//       final data = jsonDecode(resStream.body);
//       return data['secure_url'];
//     } else {
//       throw Exception('Failed to upload image: ${response.statusCode}');
//     }
//   }

// }
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = 'dmhjjvk5p';
  final String uploadPreset = 'posts_upload';

  Future<String> uploadFile(File file, {required String resourceType}) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStream = await http.Response.fromStream(response);
      final data = jsonDecode(resStream.body);
      return data['secure_url'];
    } else {
      throw Exception('Failed to upload $resourceType: ${response.statusCode}');
    }
  }

  Future<String> uploadImage(File imageFile) async {
    return await uploadFile(imageFile, resourceType: 'image');
  }

  Future<String> uploadVideo(File videoFile) async {
    return await uploadFile(videoFile, resourceType: 'video');
  }
}
