import 'package:flutter/cupertino.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapViewState();
}

class _MapViewState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      fit: BoxFit.cover,
      height: double.infinity,
        width: double.infinity,

        "assets/images/map_img.png"
    );
  }
}
