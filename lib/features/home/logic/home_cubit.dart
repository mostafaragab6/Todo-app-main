import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/helpers/shared_pref_helpers.dart';
import 'package:todo_app/core/networking/dio_factory.dart';
import 'package:todo_app/features/home/data/models/model.dart';
import 'package:todo_app/features/home/data/repos/delete_task_repo.dart';
import 'package:todo_app/features/home/logic/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final DeleteTaskRepo _deleteTaskRepo;
  HomeCubit(this._deleteTaskRepo) : super(const HomeState.initial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Model? model;

  void getTasks() async {
    emit(const HomeState.loading());
    DioFactory.dio
        ?.get('https://todo.iraqsapp.com/todos?page=1')
        .then((onValue) {
      model = Model.fromJson(onValue.data);

      emit(HomeState.success(model!.list));
    }).catchError((error) {
      emit(const HomeState.error());
    });
  }

  Data? specificTask;
  void getSpecificTask(String id) async {
    emit(const HomeState.specificTaskLoading());

    DioFactory.dio?.get('https://todo.iraqsapp.com/todos/$id').then((onValue) {
      specificTask = Data.fromJson(onValue.data);

      emit(HomeState.specificTaskSuccess(specificTask));
    }).catchError((error) {
      emit(HomeState.specificTaskError(error.toString()));
    });
  }

  void logout() async {
    DioFactory.dio
        ?.post('https://todo.iraqsapp.com/auth/logout')
        .then((onValue) async {
      SharedPrefHelper.clearAllSecuredData();
      await _auth.signOut();
      emit(HomeState.logoutSuccess(onValue.toString()));
    }).catchError((error) {
      emit(HomeState.logoutError(error.toString()));
    });
  }

  void filter(String filter) {
    if (filter == "all") {
      emit(HomeState.success(List.from(model?.list ?? [])));
    } else {
      final filteredTasks = model?.list
              .where((element) =>
                  element.status?.toLowerCase() == filter.toLowerCase())
              .toList() ??
          [];
      emit(HomeState.success(filteredTasks));
    }
  }

  String? taskId;
  void deleteTask({String? fromHomeTaskId}) async {
    final response =
        await _deleteTaskRepo.deleteTask(fromHomeTaskId ?? taskId ?? '');

    response.when(
      success: (message) {
        emit(HomeState.deleteTaskSuccess(message));
      },
      failure: (error) {
        emit(HomeState.deleteTaskError(error.toString()));
      },
    );
  }
}
