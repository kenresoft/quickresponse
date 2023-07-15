import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkCommon {
  static final NetworkCommon _singleton = NetworkCommon._internal();

  factory NetworkCommon() {
    return _singleton;
  }

  NetworkCommon._internal();

  final JsonDecoder _decoder = const JsonDecoder();

  dynamic decodeResp(d) {
    // ignore: cast_to_non_type
    if (d is Response) {
      final dynamic jsonBody = d.data;
      final statusCode = d.statusCode;

      if (statusCode! < 200 || statusCode >= 300 || jsonBody == null) {
        throw Exception("statusCode: $statusCode");
      }

      if (jsonBody is String) {
        return _decoder.convert(jsonBody);
      } else {
        return jsonBody;
      }
    } else {
      throw d;
    }
  }

  Dio get dio {
    Dio dio = Dio();
    // Set default configs
    dio.options.baseUrl = 'http://192.168.1.186:5000/';
    dio.options.connectTimeout = const Duration(milliseconds: 50000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
      /// Do something before request is sent
      /// set the token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      }

      debugPrint("Pre request:${options.method},${options.baseUrl}${options.path}");
      debugPrint("Pre request:${options.headers.toString()}");

      return handler.next(options); //continue
    }, onResponse: (Response response, handler) async {
      // Do something with response data
      final int? statusCode = response.statusCode;
      if (statusCode == 200) {
        if (response.requestOptions.path == "login/") {
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          /// login complete, save the token
          /// response data:
          /// {
          ///   "code": 0,
          ///   "data": Object,
          ///   "msg": "OK"
          ///  }
          final String jsonBody = response.data;
          const JsonDecoder decoder = JsonDecoder();
          final resultContainer = decoder.convert(jsonBody);
          final int code = resultContainer['code'];
          if (code == 0) {
            final Map results = resultContainer['data'];
            prefs.setString("token", results["token"]);
            prefs.setInt("expired", results["expired"]);
          }
        }
      } else if (statusCode == 401) {
        /// token expired, re-login or refresh token
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var username = prefs.getString("username");
        var password = prefs.getString("password");
        FormData formData = FormData.fromMap({
          "username": username,
          "password": password,
        });
        Dio().post("login/", data: formData).then((resp) {
          final String jsonBody = response.data;
          const JsonDecoder decoder = JsonDecoder();
          final resultContainer = decoder.convert(jsonBody);
          final int code = resultContainer['code'];
          if (code == 0) {
            final Map results = resultContainer['data'];
            prefs.setString("token", results["token"]);
            prefs.setInt("expired", results["expired"]);

            RequestOptions ro = response.requestOptions;
            ro.headers["Authorization"] = "Bearer ${prefs.getString('token')}";
            return ro;
          } else {
            throw Exception("Exception in re-login");
          }
        });
      }

      debugPrint("Response From:${response.requestOptions.method},${response.requestOptions.baseUrl}${response.requestOptions.path}");
      debugPrint("Response From:${response.toString()}");
      return handler.next(response); // continue
    }, onError: (DioException e, handler) {
      // Do something with response error
      return handler.next(e); //continue
    }));
    return dio;
  }
}
