extension StringExtension on String {
  // 매칭된 첫 번째 공백이 아닌 문자 뒤에 '\u200D(ZWJ)' 추가 후 반환
  // 공백을 제외한 글자와 글자 사이에 결속을 표시 해주는 작업
  String insertZwj() {
    return replaceAllMapped(RegExp(r'(\S)(?=\S)'), (str) => '${str[1]}\u200D');
  }
}