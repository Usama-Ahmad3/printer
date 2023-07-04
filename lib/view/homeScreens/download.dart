import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:printer/view/utils/flushbar.dart';
import 'package:printer/view/widgets/textFormField.dart';

class Download extends StatefulWidget {
  const Download({super.key});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  TextEditingController searchController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var filePath;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Download'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextFieldWidget(
                  type: TextInputType.number,
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: searchController,
                  hint: 'Search',
                  icon: Icons.search_outlined),
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('files').snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    List<DocumentSnapshot> docs = snapshot.data.docs;
                    return SingleChildScrollView(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = docs[index];
                          List<dynamic> id = doc.get('fileId');
                          List<dynamic> name = doc.get('name');
                          List<dynamic> url = doc.get('url');
                          return SingleChildScrollView(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: id.length,
                              itemBuilder: (context, index) {
                                if (id[index]
                                    .toString()
                                    .contains(searchController.text)) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0, vertical: 8),
                                    child: Container(
                                      height: height * 0.094,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: const Border.fromBorderSide(
                                              BorderSide(
                                                  color: Colors.grey,
                                                  strokeAlign: 1))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: width * 0.03,
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Container(
                                                    color: Colors
                                                        .deepPurple.shade50,
                                                    height: height * 0.07,
                                                    width: width * 0.14,
                                                    child: const Icon(
                                                        Icons.request_page)),
                                              ),
                                              SizedBox(
                                                width: width * 0.03,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    name[index]
                                                                .toString()
                                                                .length >
                                                            14
                                                        ? name[index]
                                                            .toString()
                                                            .substring(0, 14)
                                                        : name[index]
                                                            .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        id[index].toString(),
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: width * 0.06,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 18.0),
                                            child: InkWell(
                                                onTap: () async {
                                                  FileDownloader.downloadFile(
                                                          url: url[index],
                                                          name: name[index]
                                                              .toString(),
                                                          onDownloadCompleted:
                                                              (filepath) {
                                                            filePath = filepath
                                                                .toString();
                                                            //This will be the path of the downloaded file
                                                          })
                                                      .then((value) async =>
                                                          await Utils.flushBar(
                                                              'File Saved: $filePath',
                                                              context,
                                                              'Information'));
                                                },
                                                child:
                                                    const Icon(Icons.download)),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}
