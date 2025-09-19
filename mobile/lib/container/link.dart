import 'package:flutter/material.dart';

@immutable
class Link {
  final Uri uri;
  final String title;

  const Link({required this.uri, required this.title});
}
