
import 'package:deriv_exercise/models/model_tick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tickProvider = StateProvider<AsyncValue<ModelTick>>((ref) {
  return const AsyncValue.loading();
});
