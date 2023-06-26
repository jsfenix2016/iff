import '../../../Common/Constant.dart';
import 'package:http/http.dart' as http;

class LogActivityService {
  Future<void> saveData(String phone) async {

    try {
      var response = await http.put(
              Uri.parse("${Constant.baseApi}/v1/log/$phone"),
              headers: Constant.headers
          );

      var status = response.statusCode;

    } catch (e) {
      print(e);
    }
  }
}