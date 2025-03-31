import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/home/data/models/model.dart';
import 'package:todo_app/features/search/logic/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.tasks) : super(const SearchState.initial());

  TextEditingController searchController = TextEditingController();

  List<Data> tasks;
  List<Data> searchedTasks = [];

  void search(String taskName) {
    if (taskName.isEmpty) {
      searchedTasks = [];
      emit(SearchState.success(searchedTasks));
    } else {
      searchedTasks = tasks
          .where((element) =>
              element.title!.toLowerCase().contains(taskName.toLowerCase()))
          .toList();

      emit(SearchState.success(searchedTasks));
    }
  }
}
