import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import '../../custom_icons.dart';
import '../../../models/event.dart';
import '../../common_widgets.dart';

class EventAdminBody extends StatefulWidget {
  final String eventKey;
  final Event event;

  EventAdminBody([this.eventKey, this.event]);

  @override
  _EventAdminBodyState createState() => _EventAdminBodyState();
}

class _EventAdminBodyState extends State<EventAdminBody> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: EventStack(
              titleController: titleController,
              descriptionController: descriptionController,
            ),
          ),
          EventActions(
            titleController: titleController,
            descriptionController: descriptionController,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }
}

class EventStack extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String eventKey;
  final String image;

  EventStack({
    @required this.titleController,
    @required this.descriptionController,
    this.eventKey,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: <Widget>[
          BackgroundCard(
            colorA: 0xfffa6b40,
            colorB: 0xfffd1d1d,
            rotation: height > 400 ? 3.0 : 2.0,
          ),
          BackgroundCard(
            colorA: 0xff7474bf,
            colorB: 0xff348ac7,
            rotation: height > 400 ? -2.0 : -1.0,
          ),
          EventAdminCard(
            titleController: titleController,
            descriptionController: descriptionController,
            image: image,
          ),
        ],
      ),
    );
  }
}

class EventActions extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String eventKey;
  final String image;

  EventActions({
    @required this.titleController,
    @required this.descriptionController,
    this.eventKey,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 64.0,
            width: 64.0,
            child: FloatingActionButton(
              heroTag: null, // Fixes issue.
              backgroundColor: Colors.white,
              child: PaintGradient(
                child: Icon(CustomIcons.cancel_1),
                colorA: Color(0xfffa6b40),
                colorB: Color(0xfffd1d1d),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Container(
            height: 64.0,
            width: 64.0,
            child: FloatingActionButton(
              heroTag: null, // Fixes issue.
              backgroundColor: Colors.white,
              child: PaintGradient(
                child: Icon(CustomIcons.ok_1),
                colorA: Color(0xff7dd624),
                colorB: Color(0xff45b649),
              ),
              onPressed: () {
                // TODO: Create or update event.
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EventAdminCard extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final double height;
  final double width;
  final double rotation;
  final String image;

  EventAdminCard({
    @required this.titleController,
    @required this.descriptionController,
    this.height = double.maxFinite,
    this.width = double.maxFinite,
    this.rotation = 0.0,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double height = constraints.maxHeight;
          final double width = constraints.maxWidth;
          return Transform.rotate(
            angle: Angle.fromDegrees(rotation).radians,
            child: Container(
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
                        height: height > 300 ? height / 2 : height / 4,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                        image: AdvancedNetworkImage(
                          image ?? "",
                          useDiskCache: true,
                          timeoutDuration: Duration(seconds: 5),
                        ),
                        placeholder: Image.asset(
                          "assets/images/placeholder.jpg",
                          height: height > 300 ? height / 2 : height / 4,
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                        loadingWidget: Image.asset(
                          "assets/images/placeholder.jpg",
                          height: height > 300 ? height / 2 : height / 4,
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                      ),
                      titleWidget(titleController),
                      descriptionWidget(descriptionController),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget titleWidget(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          border: underlineInputBorder(),
          enabledBorder: underlineInputBorder(),
          focusedBorder: underlineInputBorder(Colors.red),
          fillColor: Colors.black54,
          hintText: "Beber cerveza, explorar la zona, visitar la catedral ... ",
          hintStyle: TextStyle(fontSize: 15.0),
          hintMaxLines: 1,
        ),
      ),
    );
  }

  Widget descriptionWidget(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLines: 5,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
          color: Colors.black54,
        ),
        decoration: InputDecoration(
          hintText: "¿Qué propones hacer? ¿Qué idioma hablas?, ¿Qué hora te viene mejor?, ...",
          hintStyle: TextStyle(
            fontSize: 15.0,
          ),
          hintMaxLines: 5,
          labelStyle: TextStyle(
            color: Colors.red,
          ),
          border: outlineInputBorder(),
          enabledBorder: outlineInputBorder(),
          focusedBorder: outlineInputBorder(Colors.red),
        ),
      ),
    );
  }

  UnderlineInputBorder underlineInputBorder([Color color = Colors.black54]) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 2.0,
      ),
    );
  }

  OutlineInputBorder outlineInputBorder([Color color = Colors.black54]) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(2.0),
    );
  }
}