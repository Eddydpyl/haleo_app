import 'dart:ui' as ui;
import 'dart:io';

import 'package:angles/angles.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';
import 'package:haleo_app/utility.dart';
import 'package:location/location.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/state_provider.dart';
import '../../../providers/event_admin_provider.dart';
import '../../../blocs/state_bloc.dart';
import '../../../blocs/event_admin_bloc.dart';
import '../../../blocs/uploader_bloc.dart';
import '../../../models/event.dart';
import '../../../localization.dart';
import '../../custom_icons.dart';
import '../../common_widgets.dart';

class EventAdminBody extends StatefulWidget {
  final String eventKey;
  final Event event;

  EventAdminBody([this.eventKey, this.event]);

  @override
  _EventAdminBodyState createState() => _EventAdminBodyState();
}

class _EventAdminBodyState extends State<EventAdminBody> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Localization localization = ApplicationProvider.localization(context);
    final StateBloc stateBloc = StateProvider.stateBloc(context);
    final EventAdminBloc eventAdminBloc =
        EventAdminProvider.eventAdminBloc(context);
    final UploaderBloc uploaderBloc = EventAdminProvider.uploaderBloc(context);
    return StreamBuilder(
      stream: stateBloc.userKeyStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.data != null) {
          final String userKey = snapshot.data;
          return StreamBuilder(
            initialData: widget.event?.image ?? "",
            stream: uploaderBloc.pathStream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.data != null) {
                final String image = snapshot.data;
                return Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: EventStack(
                          uploaderBloc: uploaderBloc,
                          nameController: nameController,
                          descriptionController: descriptionController,
                          eventKey: widget.eventKey,
                          image: image,
                        ),
                      ),
                      EventActions(
                        localization: localization,
                        eventAdminBloc: eventAdminBloc,
                        nameController: nameController,
                        descriptionController: descriptionController,
                        userKey: userKey,
                        eventKey: widget.eventKey,
                        image: image,
                      ),
                    ],
                  ),
                );
              } else
                return Container();
            },
          );
        } else
          return Container();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }
}

class EventStack extends StatelessWidget {
  final UploaderBloc uploaderBloc;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String eventKey;
  final String image;

  EventStack({
    @required this.uploaderBloc,
    @required this.nameController,
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
          ColoredCard(
            colorA: 0xfffa6b40,
            colorB: 0xfffd1d1d,
            rotation: height > 400 ? 3.0 : 2.0,
          ),
          ColoredCard(
            colorA: 0xff7474bf,
            colorB: 0xff348ac7,
            rotation: height > 400 ? -2.0 : -1.0,
          ),
          EventAdminCard(
            uploaderBloc: uploaderBloc,
            nameController: nameController,
            descriptionController: descriptionController,
            image: image,
          ),
        ],
      ),
    );
  }
}

class EventActions extends StatelessWidget {
  final Localization localization;
  final EventAdminBloc eventAdminBloc;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String userKey;
  final String eventKey;
  final String image;

  EventActions({
    @required this.localization,
    @required this.eventAdminBloc,
    @required this.nameController,
    @required this.descriptionController,
    @required this.userKey,
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
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  try {
                    LocationData location = await Location().getLocation();
                    GeoFirePoint point =
                        GeoFirePoint(location.latitude, location.longitude);
                    Locale locale = ui.window.locale ?? Locale(Language.EN);
                    String date = DateUtility.currentDate();
                    eventAdminBloc.createSink.add(Event(
                      user: userKey,
                      name: nameController.text,
                      description: descriptionController.text,
                      image: image,
                      point: point.data,
                      open: true,
                      count: 0,
                      slots: 2, // TODO: Use actual event slots.
                      created: date,
                      lang: locale.languageCode,
                    ));
                    Navigator.of(context).pop();
                  } on PlatformException catch (e) {
                    if (e.code == 'PERMISSION_DENIED') {
                      Location().requestPermission();
                      SnackBarUtility.show(
                          context, localization.locationPermissionText());
                    } else {
                      SnackBarUtility.show(
                          context, localization.locationErrorText());
                    }
                  } catch (e) {
                    SnackBarUtility.show(
                        context, localization.locationErrorText());
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EventAdminCard extends StatelessWidget {
  final UploaderBloc uploaderBloc;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final double height;
  final double width;
  final double rotation;
  final String image;
  double slots = 2;

  EventAdminCard({
    @required this.uploaderBloc,
    @required this.nameController,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      imageWidget(height > 300 ? height / 2 : height / 4),
                      SizedBox(height: 16.0),
                      Text(
                        '¿Para cuanta gente?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                      Slider(
                        value: slots,
                        inactiveColor: Colors.black54,
                        activeColor: Colors.red,
                        onChanged: (slotsValue) {}, //TODO: implementar logica
                        divisions: 8,
                        label: "$slots",
                        min: 2,
                        max: 10,
                      ),
                      titleWidget(nameController),
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

  Widget imageWidget(double height) {
    return GestureDetector(
      child: CardImage(
        image: image,
        height: height,
      ),
      onTap: () async {
        File file = await ImagePicker.pickImage(
            source: ImageSource.gallery, maxHeight: 1500, maxWidth: 1500);
        if (file != null) uploaderBloc.fileSink.add(file.readAsBytesSync());
      },
    );
  }

  Widget titleWidget(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        maxLines: 1,
        controller: controller,
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
        textCapitalization: TextCapitalization.sentences,
        maxLines: 5,
        controller: controller,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
          color: Colors.black54,
        ),
        decoration: InputDecoration(
          hintText:
              "¿Qué propones hacer? ¿Qué idioma hablas?, ¿Qué hora te viene mejor?, ...",
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
