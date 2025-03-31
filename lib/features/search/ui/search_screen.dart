import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/core/widgets/app_text_form_field.dart';
import 'package:todo_app/features/search/logic/search_cubit.dart';
import 'package:todo_app/features/search/ui/widgets/search_bloc_builder.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsetsDirectional.only(
            start: 20.w,
            end: 20.w,
            bottom: 30.h,
            top: 50.h,
          ),
          child: Column(
            spacing: 25.w,
            children: [
              AppTextFormField(
                hintText: 'search',
                controller: context.read<SearchCubit>().searchController,
                validator: (value) {},
                onChanged: (value) {
                  context.read<SearchCubit>().search(value ?? '');
                },
              ),
              const SearchBlocBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}
