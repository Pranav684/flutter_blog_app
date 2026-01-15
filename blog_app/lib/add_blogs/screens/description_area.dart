import 'package:blog_app/utility/theme/colors.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

class DescriptionArea extends StatefulWidget {
  const DescriptionArea({super.key});

  @override
  State<DescriptionArea> createState() => _DescriptionAreaState();
}

class _DescriptionAreaState extends State<DescriptionArea> {
  late FleatherController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FleatherController();
  }

  dynamic postDocument() {
    final jsonData = _controller.document.toDelta().toJson();
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox()
    );
  }
}
