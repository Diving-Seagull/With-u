import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:withu/data/datasource/login_datasource.dart';
import 'package:withu/data/model/token_dto.dart';

class LoginRepository {
  late final LoginDataSource _loginDataSource;

  LoginRepository() { _loginDataSource = LoginDataSource(); }

  Future<TokenDto?> getNewToken(String socialToken, String? firebaseToken, String type) async {
    return await _loginDataSource.postTokenInfo(TokenDto(socialToken, firebaseToken), type);
  }

  Future<TokenDto?> getRecentToken(String socialToken, String type) async {
    return await _loginDataSource.postTokenInfo(TokenDto(socialToken), type);
  }

}
