import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'dt5wznqdc'; // Replace with your Cloudinary cloud name
  static const String apiKey = '875633287464195';       // Replace with your Cloudinary API key
  static const String apiSecret = 'eJn0qkhgbz8CM6YVFpeqm1oJMow'; // Replace with your Cloudinary API secret
  static const String uploadPreset = 'your-upload-preset'; // Optional, if using unsigned uploads

  static Future<String> uploadImage(File file) async {
    try {
      // Cloudinary API URL
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      // Prepare the request
      final request = http.MultipartRequest('POST', url)
       // ..fields['upload_preset'] = uploadPreset // Only required if using unsigned uploads
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request
      final response = await request.send();

      // Process the response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);

        // The `secure_url` contains the uploaded image's URL
        return responseData['secure_url'] as String;
      } else {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
      rethrow;
    }
  }
}