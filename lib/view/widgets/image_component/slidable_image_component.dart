import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SlidableImageComponent(),
    );
  }
}

class SlidableImageComponent extends StatefulWidget {
  @override
  _SlidableImageComponentState createState() => _SlidableImageComponentState();
}

class _SlidableImageComponentState extends State<SlidableImageComponent> {
  List<String> images = [
    'https://example.com/image1.jpg',
    'https://example.com/image2.jpg',
    'https://example.com/image3.jpg',
    // Add more image URLs here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horizontal Slidable Images'),
      ),
      body:
      PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(images[index]),
          );
        },
      ),
    );
  }
}
