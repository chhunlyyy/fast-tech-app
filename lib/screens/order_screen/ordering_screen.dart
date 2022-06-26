import 'package:flutter/material.dart';

class OrderingScreen extends StatefulWidget {
  const OrderingScreen({Key? key}) : super(key: key);

  @override
  State<OrderingScreen> createState() => _OrderingScreenState();
}

class _OrderingScreenState extends State<OrderingScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
        title: const Text('Ordering'),
      )),
    );
  }
}
