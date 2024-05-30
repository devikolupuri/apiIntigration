import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Photos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyScreen(),
    );
  }
}

class Photo {
  final int id;
  final String title;
  final String imageUrl;

  Photo({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      title: json['title'],
      imageUrl: json['url'],
    );
  }
}

class PhotoListItem extends StatelessWidget {
  final Photo photo;

  const PhotoListItem({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Image.network(
          photo.imageUrl,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
            return const Text('loading');
          }
        ),
        title: Text(photo.title),
        subtitle: Text('ID: ${photo.id}'),
      ),
      );
  }
}

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  List<Photo> photos = [];

  @override
  void initState() {
    super.initState();

    fetchPhotos();
  }

  void fetchPhotos() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        photos = jsonData.map((data) => Photo.fromJson(data)).toList();
      });
    } 
    else {
      print('Error fetching photos: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Photos'),
      ),
      body: ListView.builder(
        itemCount: photos.length,
        itemBuilder: (BuildContext context, int index) {
          return PhotoListItem(photo: photos[index]);
        },
      ),
    );
  }
}