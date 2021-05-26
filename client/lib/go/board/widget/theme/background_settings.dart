import 'dart:io';

import 'package:flutter/cupertino.dart';

abstract class BackgroundSettings {
  Widget background();
}

class BaseBackgroundSettings extends BackgroundSettings {
  final String imageLocation;
  final LoadType loadType;

  BaseBackgroundSettings({String? imageLocation, LoadType? loadType})
      : imageLocation = imageLocation ?? "assets/textures/shinkaya.jpg",
        loadType = loadType ?? LoadType.asset;

  Widget background() {
    return Image(
        image: _loadImageProvider(),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.contain);
  }

  ImageProvider _loadImageProvider() {
    switch (this.loadType) {
      case LoadType.asset:
        return AssetImage(this.imageLocation);
      case LoadType.local:
        return FileImage(File(this.imageLocation));
      case LoadType.remote:
        return NetworkImage(this.imageLocation);
    }
  }
}

enum LoadType { asset, local, remote }
