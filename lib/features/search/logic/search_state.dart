import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_app/features/home/data/models/model.dart';

part 'search_state.freezed.dart';

@Freezed()
class SearchState<T> with _$SearchState<T> {
  const factory SearchState.initial() = _Initial;

  const factory SearchState.success(List<Data?>? data) = Success;
}
