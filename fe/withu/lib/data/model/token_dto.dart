class TokenDto {
  final String token;

  TokenDto({required this.token});

  Map<String, dynamic> toJson(){
    return {
      'token': token
    };
  }

  factory TokenDto.fromJson(Map<String, dynamic> json){
    return TokenDto(token: json['token']);
  }
}
