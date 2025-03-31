import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/features/login/logic/login_cubit.dart';

import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/widgets/app_text_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var countryController = TextEditingController();
  bool isPass = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<LoginCubit>().formKey,
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          SizedBox(
            width: 326.w,
            child: AppTextFormField(
              maxLines: 1,
              hintTextStyle: TextStyles.font14LightGreyWeight400(),
              hintText: 'email...',
              controller: context.read<LoginCubit>().emailController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'You must write your email';
                }
              },
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          SizedBox(
            width: 326.w,
            child: AppTextFormField(
              maxLines: 1,
              hintTextStyle: TextStyles.font14LightGreyWeight400(),
              hintText: 'Password...',
              isObscured: isPass,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isPass = !isPass;
                  });
                },
                icon: isPass
                    ? const Icon(
                        Icons.visibility_off,
                        color: ColorsManager.lightGrey,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: ColorsManager.lightGrey,
                      ),
              ),
              controller: context.read<LoginCubit>().passController,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'You must write your password';
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
