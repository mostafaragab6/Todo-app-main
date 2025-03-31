import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/core/networking/dio_factory.dart';
import 'package:todo_app/features/create_task/data/models/create_task_request.dart';
import 'package:todo_app/features/create_task/data/repos/create_task_repo.dart';
import 'package:todo_app/features/create_task/logic/create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  final CreateTaskRepo _createTaskRepo;
  CreateTaskCubit(this._createTaskRepo)
      : super(const CreateTaskState.initial());

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  TextEditingController priorityController = TextEditingController(text: 'low');
  TextEditingController dateController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String? imageToBeSent;
  void createTask() async {
    emit(const CreateTaskState.loading());

    final response = await _createTaskRepo.createTask(
      CreateTaskRequest(
        desc: descController.text,
        dueDate: dateController.text,
        image: imageToBeSent ?? "image",
        priority: priorityController.text,
        title: titleController.text,
      ),
    );

    response.when(
      success: (data) {
        emit(CreateTaskState.success(data));
      },
      failure: (error) {
        emit(CreateTaskState.error(error));
      },
    );
  }

  Future<void> uploadImage() async {
    emit(const CreateTaskState.uploadedImageLoading());

    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image!.path,
        filename: fileName,
        contentType: MediaType('image', 'png'),
      ),
    });
    DioFactory.dio
        ?.post(
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
      'https://todo.iraqsapp.com/upload/image',
      data: formData,
    )
        .then((value) {
      imageToBeSent = value.data['image'];
      emit(CreateTaskState.uploadedImageSuccess(value.data['image']));
    }).catchError((error) {
      emit(CreateTaskState.uploadedImageError(error.toString()));
    });
  }

  File? image;
  String? fileName;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(String source) async {
    final dynamic pickedFile;
    if (source == 'camera') {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }
    if (pickedFile != null) {
      File originalImage = File(pickedFile.path);

      XFile? returedImage = await compressImage(originalImage);

      File compressedImage = File(returedImage!.path);
      image = compressedImage;
      fileName = image!.path.split('/').last;

      uploadImage();
    } else {
      print('No image selected.');
    }
  }

  Future<XFile?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    return await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, // Path of the original image
      targetPath, // Path to save the compressed image
      quality: 80, // Adjust quality (0-100)
      format: CompressFormat.jpeg, // Ensure JPEG format
    );
  }
}
