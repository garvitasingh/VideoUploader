import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Post extends StatefulWidget {
  final String filePath;

  const Post({Key? key, required this.filePath}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  FirebaseStorage storage = FirebaseStorage.instance;

  TextEditingController creatorController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  String location = 'Null';
  String Address = 'Search Location';
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')));
      // return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied.')));
        // return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  String? url;

  Future uploadToStorage() async {
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString());
      final String today = ('$month-$date');
      final String title = titleController.text;
      final String discription = discriptionController.text;
      final String category = categoryController.text;
      final String location = Address;
      final String creator = creatorController.text;

      final file = File(widget.filePath);
      UploadTask? uploadTask;

      final ref = FirebaseStorage.instance.ref().child(storageId);
      uploadTask = ref.putFile(
          file,
          SettableMetadata(contentType: 'video/mp4', customMetadata: {
            'uploaded_by': creator,
            'title': title,
            'discription': discription,
            'category': category,
            'location': location,
            'date': today,
          }));

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");
            Fluttertoast.showToast(
              msg: "Uploading..., $progress% completed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color.fromARGB(255, 70, 69, 69),
              textColor: Colors.white,
              fontSize: 16.0,
            );
            break;
          case TaskState.paused:
            print("Upload is paused.");
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Upload is paused')));
            break;
          case TaskState.canceled:
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Upload was canceled, please try again')));
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Video is uploaded, refresh page')));
            break;
        }
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete the detail')),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                  child: TextField(
                controller: creatorController,
                decoration: const InputDecoration(
                    labelText: 'Enter Your Name', border: OutlineInputBorder()),
              )),
              const SizedBox(height: 10),
              Container(
                  child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    labelText: 'Enter Title', border: OutlineInputBorder()),
              )),
              const SizedBox(height: 10),
              Container(
                child: TextField(
                  controller: discriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Enter Description',
                      border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child: TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                      labelText: 'Enter Catagory',
                      border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                    Position position = await _getGeoLocationPosition();
                    // location ='Lat: ${position.latitude} , Long: ${position.longitude}';
                    GetAddressFromLatLong(position);
                  },
                  child: Text('${Address}')),

              const SizedBox(
                height: 10,
              ),
              // Text(
              //   location,   //coordinate point
              //   style: TextStyle(color: Colors.black, fontSize: 16),
              // ),
              Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.purple.shade100;
                      return Theme.of(context).primaryColor;
                    })),
                    child: Text(
                      'Post',
                      style: GoogleFonts.roboto(fontSize: 18),
                    ),
                    onPressed: () {
                      const CircularProgressIndicator();
                      uploadToStorage();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                  ))
            ],
          )),
    );
  }
}
