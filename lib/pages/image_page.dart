import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePage extends StatelessWidget {
  static const String routeName = 'ImagePage';
  const ImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context)!.settings.arguments as String;
    final Image cover = Image.network(url);
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            expandedHeight: 100,
            backgroundColor: Colors.black,
            flexibleSpace: TopWigdet(title: 'Portada', showBack: true),
          ),
          SliverFillRemaining(
            child: PhotoView(imageProvider: cover.image),
          ),
        ],
      ),
    );
  }
}
