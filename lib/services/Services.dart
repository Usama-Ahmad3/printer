import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printer/res/sessionManager.dart';
import 'package:printer/view/homeScreens/upload.dart';
import 'package:printer/view/utils/flushbar.dart';

class Services {
  Future<dynamic> pickAndUpload(
      BuildContext context, List<dynamic> fileNam) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    Random random = Random();
    int? id;
    if (result != null) {
      File filePath = File(result.files.single.path.toString());
      File fileName = File(result.files.single.name.toString());
      if (fileNam.contains(fileName)) {
        await Utils.flushBar('File Already Exits', context, 'Information');
      } else {
        id = random.nextInt(90000) + 100000;
        UploadScreenState.nameId = id.toString().substring(0, 3);
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref(
                '/files/${result.files.single.name.toString()}${UploadScreenState.nameId}');
        firebase_storage.UploadTask upload = ref.putFile(filePath);
        // ignore: use_build_context_synchronously
        await Utils.flushBar('File Picked', context, 'Information');
        await Future.value(upload).then((value) {
          Utils.flushBar('Uploaded', context, 'Information');
          id = random.nextInt(90000) + 100000;
        }).onError((error, stackTrace) {
          Utils.flushBar(error.toString(), context, 'Error');
        });
        var url = await ref.getDownloadURL();
        UploadScreenState.delPath = fileName.toString();
        FirebaseFirestore.instance
            .collection('files')
            .doc(SessionController().userId)
            .update({
          'name': FieldValue.arrayUnion([
            '${result.files.single.name.toString()}${UploadScreenState.nameId}'
          ])
        });
        FirebaseFirestore.instance
            .collection('files')
            .doc(SessionController().userId)
            .update({
          'nameId': FieldValue.arrayUnion(['${UploadScreenState.nameId}'])
        });
        FirebaseFirestore.instance
            .collection('files')
            .doc(SessionController().userId)
            .update({
          'url': FieldValue.arrayUnion([url.toString()])
        });
        FirebaseFirestore.instance
            .collection('files')
            .doc(SessionController().userId)
            .update({
          'fileId': FieldValue.arrayUnion([id.toString()])
        });
      }
    } else {
      // ignore: use_build_context_synchronously
      await Utils.flushBar('File Not Picked', context, 'Information');
    }
  }

  void pickImageCamera(BuildContext context, List<dynamic> imageName) async {
    File? image;
    final XFile? imagePicker =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (imagePicker != null) {
      image = File(imagePicker.path);
      String name = imagePicker.name.toString();
      if (imageName.contains(name)) {
        await Utils.flushBar('Image Already Exits', context, 'Information');
      } else {
        // ignore: use_build_context_synchronously
        uploadImage(name, image, context);
      }
    } else {
      await Utils.flushBar('Image Not Picked', context, 'Information');
    }
  }

  uploadImage(String name, File image, BuildContext context) async {
    Random random = Random();
    int? id;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('/files/${name.toString()}');
    firebase_storage.UploadTask upload = ref.putFile(image);
    // ignore: use_build_context_synchronously
    await Utils.flushBar('Image Picked', context, 'Information');
    await Future.value(upload).then((value) {
      Utils.flushBar('Uploaded', context, 'Information');
      id = random.nextInt(900000) + 100000;
    }).onError((error, stackTrace) {
      Utils.flushBar(error.toString(), context, 'Error');
    });
    var url = await ref.getDownloadURL();
    UploadScreenState.delPath = ref.fullPath;
    FirebaseFirestore.instance
        .collection('files')
        .doc(SessionController().userId)
        .update({
      'name': FieldValue.arrayUnion([name.toString()])
    });
    FirebaseFirestore.instance
        .collection('files')
        .doc(SessionController().userId)
        .update({
      'url': FieldValue.arrayUnion([url.toString()])
    });
    FirebaseFirestore.instance
        .collection('files')
        .doc(SessionController().userId)
        .update({
      'fileId': FieldValue.arrayUnion([id.toString()])
    });
  }
}
