import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:withu/data/datasource/login_datasource.dart';
import 'package:withu/data/model/token_dto.dart';

class LoginRepository {
  late final LoginDataSource _loginDataSource;
  // final RemoteDataSource _remoteDataSource;
  // final LocalDataSource _localDataSource;

  LoginRepository() { _loginDataSource = LoginDataSource(); }

  Future<TokenDto?> getJwtToken(String accessToken, String type){
    return _loginDataSource.postTokenInfo(TokenDto(token: accessToken), type);
  }

}
