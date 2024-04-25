import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/KeyEvents/viewFIle.dart';
import 'package:web_appllication/screen_admin/KeyEvents/view_excel.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';

import '../../FirebaseApi/firebase_api_admin.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile file;
  final bool isFieldEditable;
  final String? role;

  const ImagePage(
      {Key? key, required this.file, required this.isFieldEditable, this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);
    final isPdf = ['.pdf'].any(file.name.contains);
    return Scaffold(
        appBar: AppBar(
          title: Text(file.name),
          backgroundColor: blue,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () async {
                await FirebaseApiAdmin.downloadFile(file.ref);

                final snackBar = SnackBar(
                  content: Text('Downloaded ${file.name}'),
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            const SizedBox(width: 12),
            (isFieldEditable && role == "projectManager")
                ? IconButton(
                    onPressed: () {
                      FirebaseStorage.instance
                          .ref()
                          .child(file.url)
                          .delete()
                          .then((value) {
                        print('Delete Successfull');
                        Navigator.pop(context);
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                    ),
                  )
                : Container(),
            const SizedBox(width: 12),
          ],
        ),
        body: isImage
            ? Center(
                child: Image.network(
                  file.url,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            : isPdf
                ? ViewFile(path: file.url)
                : ViewExcel(
                    path: file.ref,
                  )
        //  const Center(
        //     child: Text(
        //       'Cannot be displayed',
        //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //     ),
        //   ),
        );
  }
}
