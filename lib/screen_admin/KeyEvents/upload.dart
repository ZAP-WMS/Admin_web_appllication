import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_appllication/widgets/widgets_admin/admin_style.dart';
import 'package:web_appllication/widgets/widgets_admin/custom_appbar.dart';

class UploadDocumentAdmin extends StatefulWidget {
  String? title;
  String? cityName;
  String? depoName;
  String? activity;
  dynamic userId;
  UploadDocumentAdmin({
    super.key,
    required this.title,
    required this.activity,
    this.userId,
    this.cityName,
    this.depoName,
  });

  @override
  State<UploadDocumentAdmin> createState() => _UploadDocumentAdminState();
}

class _UploadDocumentAdminState extends State<UploadDocumentAdmin> {
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CustomAppBar(
              userId: widget.userId,
              depoName: widget.depoName,
              cityName: widget.cityName,
              text: 'Upload Checklist',
              haveSynced: false,
            )),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (result != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Selected file:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: result?.files.length ?? 0,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Text(result?.files[index].name ?? '',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            );
                          })
                    ],
                  ),
                ),
              ElevatedButton(
                  onPressed: () async {
                    result = await FilePicker.platform.pickFiles(
                        withData: true,
                        type: FileType.custom,
                        allowMultiple: false,
                        allowedExtensions: ['pdf']);
                    if (result == null) {
                      print("No file selected");
                    } else {
                      setState(() {});
                      result?.files.forEach((element) {
                        print(element.name);
                      });
                    }
                  },
                  child: const Text('Pick file')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                    if (result != null) {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          content: SizedBox(
                            height: 50,
                            width: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: blue,
                              ),
                            ),
                          ),
                        ),
                      );
                      Uint8List? fileBytes = result!.files.first.bytes;

                      // String? fileName = result!.files.first.name;

                      await FirebaseStorage.instance
                          .ref(
                            '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.activity!}/${result!.files.first.name}',
                          )
                          .putData(
                            fileBytes!,
                            // SettableMetadata(contentType: 'application/pdf')
                          )
                          .whenComplete(() =>
                              // setState(() => result == null)
                              // );
                              Navigator.pop(context));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Image is Uploaded')));
                    }
                  },
                  child: const Text('Upload file',),),
            ],
          ),
        ));
  }
}
