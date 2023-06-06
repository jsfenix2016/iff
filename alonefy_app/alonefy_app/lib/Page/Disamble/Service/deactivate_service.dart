import 'package:http/http.dart' as http;
import 'package:ifeelefine/Common/Constant.dart';

class DeactivateService {

  Future<void> saveData(String phoneNumber, int time) async {

    final json = {
      "phoneNumber": phoneNumber,
      "time": time
    };

    await http.post(
        Uri.parse(
            "${Constant.baseApi}/v1/user/temporaryDeactivation"),
        body: json
    );

  }
}