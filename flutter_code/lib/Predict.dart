import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class Predict {
  Future<String> predictImage(File imageFile) async {
    var stream = http.ByteStream(imageFile.openRead());
    stream.cast();
    var length = await imageFile.length();
    print(length);
    var uri = Uri.parse(
        'YOUR API END POINT HERE');
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('file', stream, length,
        filename:
        imageFile.path);

    request.files.add(multipartFile);
    var response = await request.send();
    var result = await response.stream.bytesToString();

    final Map<String, dynamic> responseJson =
    json.decode(result.toString()) as Map<String, dynamic>;
    print(responseJson.toString());

    dynamic pre = responseJson["prediction"];
    print(pre);

    return pre;
  }
}
