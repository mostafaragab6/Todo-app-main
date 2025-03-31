import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/core/networking/dio_factory.dart';
import 'package:todo_app/core/routing/routes.dart';
import 'package:todo_app/core/theming/colors_manager.dart';
import 'package:todo_app/features/home/logic/home_cubit.dart';
import 'package:todo_app/features/home/logic/home_state.dart';

import '../../../../../core/theming/styles.dart';
import 'list_view_item.dart';

class HomeBlocBuilder extends StatelessWidget {
  const HomeBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) =>
            current is Loading ||
            current is Success ||
            current is Error ||
            current is LogoutError ||
            current is LogoutSuccess,
        builder: (context, state) {
          return state.maybeWhen(
            loading: () {
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.mainPurpule,
                ),
              );
            },
            logoutSuccess: (message) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginScreen,
                  (Route<dynamic> route) => false,
                );
              });

              return const SizedBox.shrink();
            },
            logoutError: (error) {
              print(error);
              if (error!.contains('status code of 401')) {
                print('here');
                DioFactory.refreshToken();
                context.read<HomeCubit>().logout();
              }
              return const SizedBox.shrink();
            },
            success: (tasksData) {
              return tasksData!.isEmpty
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(bottom: 50.0.h),
                            child: Center(
                              child: Image.asset(
                                'assets/imgs/empty-box.png',
                                width: 200.w,
                                height: 200.h,
                              ),
                            ),
                          ),
                          Text(
                            'No Tasks Yet!!',
                            style: TextStyles.font16DarkPurpleWeight700(),
                          )
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return ListViewItem(
                            index: index,
                            length: tasksData.length,
                            data: tasksData[index],
                            isInSearch: false,
                          );
                        },
                        itemCount: tasksData.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                          height: 30.h,
                        ),
                      ),
                    );
            },
            error: () {
              DioFactory.refreshToken();
              context.read<HomeCubit>().getTasks();
              return const SizedBox.shrink();
            },
            orElse: () {
              return const SizedBox.shrink();
            },
          );
        });
  }
}
