
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';



//获取首页主题内容
Future getHomePageContent() async{
  try {
    print("开始获取数据.....");
    Response response;
    Dio dio =new Dio();
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    var formData = { 'lon': '115.02932', 'lat': '35.76189' };
    response =await dio.post( servicePath['homePageContent'], data: formData );
    if( response.statusCode == 200 ){
      return response.data;
    }else{
      throw Exception("端口异常.....");
    }
  } catch (e) {
    return print("------出错了------------>>>>>${e}");
  }
}


//获取火爆专区数据
Future getHomePageBeloCenten() async{
  try {
    print("开始获取数据.....");
    Response response;
    Dio dio =new Dio();
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    int page = 1;
    response =await dio.post( servicePath['homePageBelowContent'], data: page );
    if( response.statusCode == 200 ){
      return response.data;
    }else{
      throw Exception("端口异常.....");
    }
  } catch (e) {
    return print("------出错了------------>>>>>${e}");
  }
}


// 通用方法
Future request( url, { formData } ) async {
  try {
    print("开始获取数据.....");
    Response response;
    Dio dio = Dio();
    dio.options.contentType =ContentType.parse("application/x-www-form-urlencoded");
    if( formData == null ){
      response =await dio.post( servicePath[url] );
    }else{
      response =await dio.post( servicePath[url], data: formData );
    }
    if( response.statusCode == 200 ){
      return response.data;
    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }

  } catch (e) {
    return print("------出错了------------>>>>>${e}");
  }
}





