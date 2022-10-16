import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lang/core/api_url.dart';
import 'package:flutter_lang/utils/api_key.dart';
import 'package:flutter_lang/utils/directions_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DioService {
  getData({required LatLng origin, required LatLng destination}) async {
    try {
      Dio dio = Dio();
      Response response = await dio.get(ApiUrl.baseUrl, queryParameters: {
        "origin": "${origin.latitude},${origin.longitude}",
        "destination": "${destination.latitude},${destination.longitude}",
        "key": ApiKey.googleApiKey
      });

      if (response.statusCode == 200) {
        print(response.data);
        return DirectionsModel.fromMap(response.data);
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.data.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
