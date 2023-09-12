import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../routes/settings.dart';

final textFieldDirectionProvider = StateNotifierProvider<TextFieldDirectionNotifier, TextFieldDirection>((ref) {
  return TextFieldDirectionNotifier();
});

class TextFieldDirectionNotifier extends StateNotifier<TextFieldDirection> {
  TextFieldDirectionNotifier() : super(TextFieldDirection.vertical);

  set setTextFieldDirection(TextFieldDirection textFieldDirection) => state = textFieldDirection;
}
