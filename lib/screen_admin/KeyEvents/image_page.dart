import 'package:flutter/material.dart';
import 'package:web_appllication/screen_admin/KeyEvents/viewFIle.dart';
import 'package:web_appllication/screen_admin/KeyEvents/view_excel.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';

import '../../FirebaseApi/firebase_api_admin.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile file;

  const ImagePage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);
    final isPdf = ['.pdf'].any(file.name.contains);
    print('fileurl' + file.url);
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
