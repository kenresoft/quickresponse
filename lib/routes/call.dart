/*
import 'package:flutter/material.dart';

class Call extends StatefulWidget {
  const Call({super.key});

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  final ScrollController _scrollController = ScrollController();
  bool _bottomSheetVisible = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        setState(() {
          _bottomSheetVisible = true;
        });
      } else {
        setState(() {
          _bottomSheetVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: _scrollController,
        children: [
          ...List.generate(50, (index) => ListTile(title: Text('Item $index'))),
        ],
      ),
      bottomSheet: AnimatedContainer(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        height: _bottomSheetVisible ? 100 : 0,
        child: const Center(
          child: Text('This is the bottom sheet'),
        ),
      ),
    );
  }
}
*/
