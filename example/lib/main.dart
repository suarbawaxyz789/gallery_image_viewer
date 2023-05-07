import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GalleryImageViewer Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GalleryImageViewer Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ImageProvider> _imageProviders = [
    Image.network("https://picsum.photos/id/237/200/300").image,
    Image.network("https://picsum.photos/seed/picsum/200/300").image,
    Image.network("https://picsum.photos/200/300?grayscale").image,
    Image.network("https://picsum.photos/200/300").image,
    Image.network("https://picsum.photos/200/300?grayscale").image
  ];

  GalleryImageController? controller;

  @override
  void initState() {
    controller = GalleryImageController(
        onImageDeleted: (ImageProvider<Object> imageProvider) {
      setState(() {
        _imageProviders..removeWhere((element) => element == imageProvider);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                child: const Text("Show Single Image"),
                onPressed: () {
                  showImageViewer(
                      context,
                      Image.network("https://picsum.photos/id/237/200/300")
                          .image,
                      swipeDismissible: true);
                }),
            ElevatedButton(
                child: const Text("Show Multiple Images (Simple)"),
                onPressed: () {
                  MultiImageProvider multiImageProvider =
                      MultiImageProvider(_imageProviders);
                  showImageViewerPager(context, multiImageProvider,
                      swipeDismissible: true);
                }),
            const Text("<<<< Gallery type 1 >>>>"),
            // GalleryImageView(
            //   listImage: _imageProviders,
            //   width: 200,
            //   height: 200,
            //   imageDecoration:
            //       BoxDecoration(border: Border.all(color: Colors.white)),
            //   galleryType: 1,
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            const Text("<<<< Gallery type 2 >>>>"),
            GalleryImageView(
              listImage: _imageProviders,
              width: 200,
              height: 200,
              imageDecoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              galleryType: 2,
              controller: controller,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("<<<< Gallery type 3 >>>>"),
            // GalleryImageView(
            //   listImage: _imageProviders,
            //   width: 200,
            //   height: 200,
            //   imageDecoration:
            //       BoxDecoration(border: Border.all(color: Colors.white)),
            //   galleryType: 3,
            // )
          ],
        )),
      ),
    );
  }
}

class CustomImageProvider extends EasyImageProvider {
  @override
  final int initialIndex;
  final List<String> imageUrls;

  CustomImageProvider({required this.imageUrls, this.initialIndex = 0})
      : super();

  @override
  ImageProvider<Object> imageBuilder(BuildContext context, int index) {
    return NetworkImage(imageUrls[index]);
  }

  @override
  int get imageCount => imageUrls.length;
}
