library yknetworking;

import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:yknetworking/yknetworkingconfig.dart';
import 'package:yknetworking/yknetworkingRequest.dart';
import 'package:yknetworking/yknetworkingResponse.dart';

class YKBaseNetworking {

  static Future<YKNetworkingResponse> request(YKNetworkingRequest request) async {

    // TODO: 改成ListView.builder

    Dio dio = Dio(BaseOptions(
        baseUrl: request.baseUrl,
        connectTimeout: Duration(seconds: YKNetworkingConfig.getInstance().timeOut),
        receiveTimeout: Duration(seconds: YKNetworkingConfig.getInstance().receiveTimeout)
    ));

    try {
      Response? response = null;
      if (request.method == YKNetworkingMethod.get) {
        response = await dio.get(
            request.path,
            queryParameters: request.params,
            options: Options(headers: request.commheader),
            onReceiveProgress: (count,total) {
              if (request.progressCallBack != null) {
                request.progressCallBack!(count,total);
              }
            }
        );
      } else if (request.method == YKNetworkingMethod.post) {
        response = await dio.post(
            request.path,
            queryParameters: request.params,
            options: Options(headers: request.commheader),
            onReceiveProgress: (count,total) {
              if (request.progressCallBack != null) {
                request.progressCallBack!(count,total);
              }
            }
        );
      } else if (request.method == YKNetworkingMethod.put) {
        response = await dio.put(
            request.path,
            queryParameters: request.params,
            options: Options(headers: request.commheader),
            onSendProgress: (count,total) {
              if (request.progressCallBack != null) {
                request.progressCallBack!(count,total);
              }
            }
        );
      }

      if (response == null) {
        throw Exception(["请求错误"]);
      }
      YKNetworkingResponse resp = YKNetworkingResponse(data: response.data);
      if (request.handleData != null) {
        var result = request.handleData!(request,resp);

        if (result != null) {
          throw result!;
        }
      }
      if (YKNetworkingConfig.getInstance().cacheRequest != null) {
        YKNetworkingConfig.getInstance().cacheRequest!(request,null);
      }
      return resp;
    } on Exception catch (e) {
      Exception newE = e;
      if (e is DioException) {
        newE = Exception([e.response]);
      }

      YKNetworkingResponse resp = YKNetworkingResponse(data: null, exception: newE);
      if (request.errorCallBack != null) {
        request.errorCallBack!(request, newE);
      }
      if (YKNetworkingConfig.getInstance().cacheRequest != null) {
        YKNetworkingConfig.getInstance().cacheRequest!(request,newE);
      }
      return resp;
    }
  }

  static Future<YKNetworkingResponse> upload(YKNetworkingRequest request) async {

    Dio dio = Dio(BaseOptions(
        baseUrl: request.baseUrl,
        connectTimeout: Duration(seconds: YKNetworkingConfig.getInstance().timeOut),
        receiveTimeout: Duration(seconds: YKNetworkingConfig.getInstance().receiveTimeout)
    ));

    try {

      Response? response = null;

      if (request.fileLocalPath != null) {
        response = await dio.post(
            request.path,
            data: FormData.fromMap({
              request.formName: await MultipartFile.fromFile(request.fileLocalPath!, filename: request.fileName)
            }),
            queryParameters: request.params,
            options: Options(headers: request.commheader),
            onSendProgress: (count, total) {
              if (request.progressCallBack != null) {
                request.progressCallBack!(count,total);
              }
            },
        );
      } else {
        throw Exception(["无上传数据"]);
      }

      if (response == null) {
        throw Exception(["请求错误"]);
      }
      YKNetworkingResponse resp = YKNetworkingResponse(data: response.data);
      if (request.handleData != null) {
        var result = request.handleData!(request,resp);

        if (result != null) {
          throw result!;
        }
      }
      if (YKNetworkingConfig.getInstance().cacheRequest != null) {
        YKNetworkingConfig.getInstance().cacheRequest!(request,null);
      }
      return resp;

    } on Exception catch (e) {
      Exception newE = e;
      if (e is DioException) {
        newE = Exception([e.response]);
      }
      YKNetworkingResponse resp = YKNetworkingResponse(data: null, exception: newE);
      if (request.errorCallBack != null) {
        request.errorCallBack!(request, newE);
      }
      if (YKNetworkingConfig.getInstance().cacheRequest != null) {
        YKNetworkingConfig.getInstance().cacheRequest!(request,newE);
      }
      return resp;
    }


  }
}