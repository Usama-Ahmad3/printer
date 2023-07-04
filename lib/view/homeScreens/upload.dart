import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:printer/res/sessionManager.dart';
import 'package:printer/services/Services.dart';
import 'package:printer/view/homeScreens/download.dart';
import 'package:printer/view/utils/flushbar.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => UploadScreenState();
}

Color color = const Color.fromRGBO(56, 176, 204, 1.000);

class UploadScreenState extends State<UploadScreen> {
  static var delPath;
  String? filePath;
  static var nameId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: width,
              height: height,
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                  color: Color.fromRGBO(223, 252, 251, 1.000)),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(SessionController().userId)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      children: [
                        SizedBox(
                          height: height * 0.038,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                SizedBox(
                                  width: width * 0.018,
                                ),
                                const Text('flydrop',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 22)),
                                const Icon(
                                  Icons.send,
                                  color: Colors.indigo,
                                )
                              ]),
                              IconButton(
                                  onPressed: () async {
                                    await Utils.flushBar('Not Available yet',
                                        context, 'Information');
                                  },
                                  icon: const Badge(
                                      alignment: Alignment.topRight,
                                      child: Icon(Icons.notifications_none)))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.023,
                        ),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              height: height * 0.25,
                              width: width * 0.92,
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.deepPurple.shade50,
                                    radius: 28,
                                    child: const Icon(
                                      Icons.person,
                                      size: 40,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.035,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!
                                            .data()!['name']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        snapshot.data
                                            .data()!['userId']
                                            .toString()
                                            .substring(0, 6),
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: width * 0.42,
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('files')
                                        .doc(SessionController().userId)
                                        .snapshots(),
                                    builder: (context, snaps) {
                                      return InkWell(
                                        onTap: () async {
                                          List<dynamic> imageName = await snaps
                                              .data!
                                              .data()!['name']
                                              .toList();
                                          // ignore: use_build_context_synchronously
                                          Services().pickImageCamera(
                                              context, imageName);
                                        },
                                        child: Container(
                                          height: height * 0.05,
                                          width: width * 0.095,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.document_scanner_outlined,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: 20,
                                left: 12,
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('files')
                                      .doc(SessionController().userId)
                                      .snapshots(),
                                  builder: (context, snap) {
                                    return InkWell(
                                      onTap: () async {
                                        List<dynamic> imageName =
                                            snap.data!.data()!['name'].toList();
                                        Services()
                                            .pickAndUpload(context, imageName);
                                      },
                                      child: Container(
                                        height: height * 0.07,
                                        width: width * 0.84,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.indigo),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.send,
                                              size: 24,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: width * 0.03,
                                            ),
                                            const Text(
                                              'Upload',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ],
                        )
                      ],
                    );
                  }
                },
              )),

          /// Bottom Side
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: height * 0.44,
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Latest Activities',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Download(),
                                  ));
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(color: Colors.indigo),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('files')
                          .doc(SessionController().userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.data()!['name'].length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0, vertical: 8),
                                    child: Container(
                                      height: height * 0.083,
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
                                              CircleAvatar(
                                                backgroundColor: index ==
                                                        snapshot.data!
                                                                .data()!['name']
                                                                .length -
                                                            1
                                                    ? Colors.deepPurple.shade50
                                                    : Colors.grey,
                                                child: const Icon(
                                                    Icons.request_page_sharp,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                width: width * 0.03,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data!
                                                                .data()!['name']
                                                                    [index]
                                                                .toString()
                                                                .length >
                                                            18
                                                        ? snapshot.data!
                                                            .data()!['name']
                                                                [index]
                                                            .toString()
                                                            .substring(0, 18)
                                                        : snapshot.data!
                                                            .data()!['name']
                                                                [index]
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        color: index ==
                                                                snapshot.data!
                                                                        .data()![
                                                                            'name']
                                                                        .length -
                                                                    1
                                                            ? Colors.black
                                                            : Colors.grey),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        snapshot.data!
                                                            .data()!['fileId']
                                                                [index]
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.grey),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: width * 0.1,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 18.0),
                                            child: index ==
                                                    snapshot.data!
                                                            .data()!['name']
                                                            .length -
                                                        1
                                                ? InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              snapshot.data!
                                                                      .data()![
                                                                  'name'][index],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                            actions: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'files')
                                                                        .doc(SessionController()
                                                                            .userId)
                                                                        .update({
                                                                      'name': FieldValue
                                                                          .arrayRemove([
                                                                        snapshot
                                                                            .data!
                                                                            .data()!['name'][index]
                                                                      ])
                                                                    });
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'files')
                                                                        .doc(SessionController()
                                                                            .userId)
                                                                        .update({
                                                                      'url': FieldValue
                                                                          .arrayRemove([
                                                                        snapshot
                                                                            .data!
                                                                            .data()!['url'][index]
                                                                      ])
                                                                    });
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'files')
                                                                        .doc(SessionController()
                                                                            .userId)
                                                                        .update({
                                                                      'fileId':
                                                                          FieldValue
                                                                              .arrayRemove([
                                                                        snapshot
                                                                            .data!
                                                                            .data()!['fileId'][index]
                                                                      ])
                                                                    });
                                                                    firebase_storage
                                                                            .Reference
                                                                        ref =
                                                                        firebase_storage
                                                                            .FirebaseStorage
                                                                            .instance
                                                                            .ref()
                                                                            .child('/files/${snapshot.data!.data()!['name'][index]}');
                                                                    ref.delete();
                                                                    print(
                                                                        '${snapshot.data!.data()!['name'][index]}');
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .red)),
                                                              IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    FileDownloader
                                                                        .downloadFile(
                                                                            url: snapshot.data!.data()!['url'][
                                                                                index],
                                                                            name: snapshot.data!.data()!['name'][
                                                                                index],
                                                                            onDownloadCompleted:
                                                                                (filepath) {
                                                                              filePath = filepath.toString();
                                                                              Navigator.pop(context);
                                                                              //This will be the path of the downloaded file
                                                                            }).then((value) async => await Utils.flushBar(
                                                                        'File Saved: $filePath',
                                                                        context,
                                                                        'Information'));
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .download_rounded)),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(
                                                        Icons
                                                            .more_horiz_outlined,
                                                        color: index ==
                                                                snapshot.data!
                                                                        .data()![
                                                                            'name']
                                                                        .length -
                                                                    1
                                                            ? Colors.black
                                                            : Colors.grey))
                                                : InkWell(
                                                    onTap: () {
                                                      Utils.flushBar(
                                                          'Get Premium To Use This Feature',
                                                          context,
                                                          'Information');
                                                    },
                                                    child: Icon(
                                                        Icons
                                                            .more_horiz_outlined,
                                                        color: index > 0
                                                            ? Colors.grey
                                                            : Colors.black),
                                                  ),
                                          )
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          );
                        } else if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
