import '../../imports.dart';

Widget buildImage(ProfileInfo? user) {
  return SizedBox(
    width: 28,
    height: 28,
    child: user != null && user.photoURL != null
        ? ClipOval(
            child: CachedNetworkImage(
              imageUrl: user.photoURL!,
              placeholder: (context, url) => buildIcon,
              errorWidget: (context, url, error) => Icon(FontAwesomeIcons.personCircleQuestion, color: AppColor(theme).action),
            ),
          )
        : buildIcon,
  );
}

Widget get buildIcon => Icon(FontAwesomeIcons.personCircleExclamation, color: AppColor(theme).action);

String getFirstName(String? fullName) {
  if (fullName != null) {
    List<String> words = fullName.split(' ');
    if (words.isNotEmpty) {
      return words[0];
    } else {
      return ""; // Handle empty sentences gracefully
    }
  }

  return ', Try SignIn Again';
}

String trim(String input, [int length = 19]) {
  if (input.length <= length) {
    return input; // If the input is 10 characters or less, return the input as it is
  } else {
    return '${input.substring(0, length - 2)}...'; // Trim the input to the first 10 characters
  }
}
