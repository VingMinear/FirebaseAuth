import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/config/route.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhotoDetail extends StatelessWidget {
  const ViewPhotoDetail({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () => router.pop(),
        ),
      ),
      body: Container(
        child: PhotoView(
          minScale: PhotoViewComputedScale.covered * 0.65,
          imageProvider: NetworkImage(imageUrl),
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    );
  }
}
