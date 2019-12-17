import 'package:flutter/material.dart';
import '../../../models/event.dart';
import '../../common_widgets.dart';

class ChatBody extends StatefulWidget {
  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final Event event = Event(
    name: "Padel",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
        "Fusce condimentum augue vel vestibulum sodales. Donec consectetur, "
        "nisi a fringilla lobortis, arcu leo ultrices nunc, tincidunt "
        "interdum ex libero id diam.",
    image: "https://www.hotelbalnearivichycatalan.cat/uploads/galleries/que"
        "-fer/sense-sortir-del-balneari/padel/pista-padel-8.jpg",
  );
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.purpleAccent,
    );
  }
}
