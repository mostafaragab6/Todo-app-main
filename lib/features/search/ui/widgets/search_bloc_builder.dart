import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/features/search/logic/search_cubit.dart';
import 'package:todo_app/features/search/logic/search_state.dart';

import '../../../../core/theming/styles.dart';
import '../../../home/ui/widgets/home/list_view_item.dart';

class SearchBlocBuilder extends StatelessWidget {
  const SearchBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
        buildWhen: (previous, current) =>
            current is Success || current is Error,
        builder: (context, state) {
          return state.maybeWhen(
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
                            'No Search Result!!',
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
                            isInSearch: true,
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
            orElse: () {
              return const SizedBox.shrink();
            },
          );
        });
  }
}
