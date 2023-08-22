import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageProvider = StateNotifierProvider<PageNotifier, Set<String>>((ref) {
  return PageNotifier();
});

class PageNotifier extends StateNotifier<Set<String>> {
  PageNotifier() : super({});

  set setPage(Set<String> index) => state = index;
}
