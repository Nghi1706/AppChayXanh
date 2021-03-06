// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'api.dart';

class CallAPI {
  Post(String url, params) async {
    var urls = api + url;
    var data = await http.post(Uri.parse(urls), body: params);
    if (data.statusCode == 200) {
      return data.body;
    } else {
      return '';
    }
  }

  Get(String url, params) async {
    var urls;
    if (params == '') {
      urls = Uri.parse(api + url);
    } else {
      urls = Uri.parse(api + url).replace(queryParameters: params);
    }
    var data = await http.get(urls);
    if (data.statusCode == 200) {
      return data.body;
    } else {
      return '';
    }
  }

  Put(url, params) async {
    var urls = api + url;
    var data = await http.put(Uri.parse(urls), body: params);
    if (data.statusCode == 200) {
      return data.body;
    } else {
      return '';
    }
  }

  Delete(url, params) async {
    var urls = api + url;
    var data = await http.delete(Uri.parse(urls), body: params);
    if (data.statusCode == 200) {
      return data.body;
    } else {
      return '';
    }
  }
}
