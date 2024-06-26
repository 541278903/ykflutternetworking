library yknetworking;

import 'package:yknetworking/yknetworkingResponse.dart';

enum YKNetworkingMethod {
  get,
  post,
  put,
}


class YKNetworkingRequest {

  String baseUrl;
  String path;
  final YKNetworkingMethod method;

  //===upload
  String? fileLocalPath;
  String fileName = "";
  String fileMiniType = "";
  String formName = "";

  //===download
  String? downloadPath;

  String methodStr() {
    var methodStr = "GET";

    if (this.method == YKNetworkingMethod.get) {
      methodStr = "GET";
    } else if (this.method == YKNetworkingMethod.post) {
      methodStr = "POST";
    } else if (this.method == YKNetworkingMethod.put) {
      methodStr = "PUT";
    }
    return methodStr;
  }

  Map<String, dynamic>? commheader;
  Map<String, dynamic>? params;
  Exception? Function(YKNetworkingRequest request, YKNetworkingResponse response)? handleData;
  Function(YKNetworkingRequest request, Exception ex)? errorCallBack;
  Function(int count, int total)? progressCallBack;
  Function(bool show)? showloadingCallBack;
  bool showloading = false;

  YKNetworkingRequest({
    this.baseUrl = "",
    this.path = "",
    this.method = YKNetworkingMethod.get,
    this.commheader = null,
    this.params = null,
    this.handleData = null,
    this.errorCallBack = null,
    this.progressCallBack = null,
    this.showloading = false,
    this.showloadingCallBack = null,
  });

  upload(String? fileLocalPath,
      String fileName,
      String fileMiniType,
      String formName,) {
    this.fileLocalPath = fileLocalPath;
    this.fileName = fileName;
    this.fileMiniType = fileMiniType;
    this.formName = formName;
  }

  download(String? downoadPath) {
    this.downloadPath = downoadPath;
  }
}