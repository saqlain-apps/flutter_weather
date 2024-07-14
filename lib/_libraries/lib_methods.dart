import 'dart:convert';
import 'dart:math' as math;

class LibMethods {
  const LibMethods();

  String generateRandomKey({
    bool letter = true,
    bool isNumber = true,
    int length = 8,
  }) {
    const letterLowerCase = 'abcdefghijklmnopqrstuvwxyz';
    const letterUpperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const number = '0123456789';

    var chars = '';
    if (letter) chars += '$letterLowerCase$letterUpperCase';
    if (isNumber) chars += number;

    return List.generate(length, (index) {
      final indexRandom = math.Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }

  String prettifyMap(dynamic input) {
    try {
      var encoder = JsonEncoder.withIndent('  ', (obj) => obj.toString());
      var prettyprint = encoder.convert(input);
      return prettyprint;
    } catch (e) {
      return input.toString();
    }
  }

  void printWrapped(String text, void Function(dynamic object) print) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
