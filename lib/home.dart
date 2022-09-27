import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth_video/login.dart';
import 'package:phone_auth_video/record_video.dart';
import 'play_video.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var uid;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> _loadVideos() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "title": fileMeta.customMetadata?['title'] ?? 'No Title',
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Unknown',
        "discription":
            fileMeta.customMetadata?['discription'] ?? 'No discription',
        "category": fileMeta.customMetadata?['category'] ?? 'Not Defined',
        "location": fileMeta.customMetadata?['location'] ?? 'Unknown',
        "date": fileMeta.customMetadata?['date'] ?? 'Unknown',
      });
    });

    return files;
  }

  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: _refresh,
           child:Expanded(
              child: FutureBuilder(
                future: _loadVideos(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> video =
                            snapshot.data![index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            dense: false,
                            // leading: Video.network(video['url']),
                            title: Text(video['title']),
                            subtitle: Text(video['discription']),
                            onTap: () {
                              final route = MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => playVideo(
                                  filePath: video['url'],
                                  category: video['category'],
                                  creator: video['uploaded_by'],
                                  date: video['date'],
                                  discrition: video['discription'],
                                  location: video['location'],
                                  title: video['title'],
                                ),
                              );
                              Navigator.push(context, route);
                            },
                            trailing: IconButton(
                              onPressed: () => _delete(video['path']),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => const CameraPage()));
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }
}
