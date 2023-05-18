import 'package:http/http.dart' as http;
import 'package:ifeelefine/Model/ApiRest/PremiumApi.dart';

import '../../../Common/Constant.dart';

class PremiumService {

  Future<void> saveData(PremiumApi premiumApi) async {

    final resp = await http.put(
        Uri.parse("${Constant.baseApi}/v1/user/premium"),
        body: premiumApi
    );
  }
}