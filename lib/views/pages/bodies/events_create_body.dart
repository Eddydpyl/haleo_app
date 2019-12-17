import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import '../../custom_icons.dart';
import '../../../models/event.dart';
import '../../common_widgets.dart';

class EventsCreateBody extends StatefulWidget {
  @override
  _EventsCreateBodyState createState() => _EventsCreateBodyState();
}

class _EventsCreateBodyState extends State<EventsCreateBody> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final offsetWidth = 32;
    final offsetHeight = 0.28 * height;

    return Padding(
        padding: new EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: <Widget>[
                  EventEditCard(
                    height: height - offsetHeight,
                    width: width - offsetWidth,
                  ),
                ],
              ),
            ),
            Expanded(child: EventActions()),
          ],
        ));
  }
}

class EventEditCard extends StatelessWidget {
  final double width, height;

  EventEditCard({
    @required this.width,
    @required this.height,
  });

  Widget _buildTitleTF() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
      child: TextField(
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          border: _underlineInputBorder(),
          enabledBorder: _underlineInputBorder(),
          focusedBorder: _underlineInputBorder(color: Colors.red),
          fillColor: Colors.black54,
          hintText: 'Beber cerveza, explorar la zona, visitar la catedral ... ',
          hintStyle: TextStyle(fontSize: 15.0),
          hintMaxLines: 1,
        ),
      ),
    );
  }

  Widget _buildDescriptionTF() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
        child: TextField(
          maxLines: 5,
          keyboardType: TextInputType.text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: Colors.black54,
          ),
          decoration: InputDecoration(
            hintText: 'Placeholder',
            hintStyle: TextStyle(
              fontSize: 15.0,
            ),
            hintMaxLines: 5,
            labelStyle: TextStyle(color: Colors.red),
            border: _outlineInputBorder(),
            enabledBorder: _outlineInputBorder(),
            focusedBorder: _outlineInputBorder(color: Colors.red),
          ),
        ),
      ),
    );
  }

  UnderlineInputBorder _underlineInputBorder({Color color = Colors.black54}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 2.0,
      ),
    );
  }

  OutlineInputBorder _outlineInputBorder({Color color = Colors.black54}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(2.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Card(
        shape: ContinuousRectangleBorder(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TransitionToImage(
                height: height > 400 ? height / 2 : height / 4,
                width: double.maxFinite,
                fit: BoxFit.cover,
                image: AdvancedNetworkImage(
                  'https://www.arbelecos.es/wp-content/uploads/2016/02/placeholder-9.jpg',
                  useDiskCache: true,
                  timeoutDuration: Duration(seconds: 5),
                ),
                placeholder: Container(),
              ),
              _buildTitleTF(),
              _buildDescriptionTF(),
            ],
          ),
        ),
      ),
    );
  }
}

class EventActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 50.0, // TODO: increase button size to 64 when we can do so in main screen too
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            child: PaintGradient(
              child: Icon(CustomIcons.cancel_1),
              colorA: Color(0xfffa6b40),
              colorB: Color(0xfffd1d1d),
            ),
            onPressed: () {
              // TODO: cancel event creation
            },
          ),
        ),
        Container(
          height: 50.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            child: PaintGradient(
              child: Icon(CustomIcons.ok_1),
              colorA: Color(0xff7dd624),
              colorB: Color(0xff45b649),
            ),
            onPressed: () {
              // TODO: create event
            },
          ),
        ),
      ],
    );
  }
}
