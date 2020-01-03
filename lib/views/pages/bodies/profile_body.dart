import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';

import '../../../providers/profile_provider.dart';
import '../../../blocs/user_events_bloc.dart';
import '../../../blocs/user_bloc.dart';
import '../../../models/event.dart';
import '../../../models/user.dart';
import '../../common_widgets.dart';

class ProfileBody extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final void Function(String) upload;
  final bool editing;
  final String path;

  ProfileBody({
    @required this.nameController,
    @required this.descriptionController,
    @required this.upload,
    @required this.editing,
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    final UserEventsBloc userEventsBloc = ProfileProvider.eventsBloc(context);
    final UserBloc userBloc = ProfileProvider.userBloc(context);
    return StreamBuilder(
      stream: userBloc.userStream,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<String, User>> snapshot) {
        if (snapshot.data != null) {
          final String uid = snapshot.data.key;
          final User user = snapshot.data.value;
          if (nameController.text?.isEmpty ?? true)
            nameController.text = user.name ?? "";
          if (descriptionController.text?.isEmpty ?? true)
            descriptionController.text = user.description ?? "";
          return StreamBuilder(
            stream: userEventsBloc.eventsStream,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, Event>> snapshot) {
              if (snapshot.data != null) {
                final Map<String, Event> events = snapshot.data;
                return StreamBuilder(
                  stream: userEventsBloc.usersStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, User>> snapshot) {
                    if (snapshot.data != null) {
                      final Map<String, User> users = snapshot.data;
                      return ProfileList(
                        nameController: nameController,
                        descriptionController: descriptionController,
                        editing: editing,
                        upload: upload,
                        path: path,
                        events: events,
                        users: users,
                        user: user,
                      );
                    } else {
                      return Center(
                        child: const CircularProgressIndicator(),
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }
            },
          );
        } else {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ProfileList extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final void Function(String) upload;
  final bool editing;
  final String path;

  final Map<String, Event> events;
  final Map<String, User> users;
  final User user;

  ProfileList({
    @required this.nameController,
    @required this.descriptionController,
    @required this.upload,
    @required this.editing,
    @required this.path,
    @required this.events,
    @required this.users,
    @required this.user,
  });

  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  StreamSubscription subscription;
  bool init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!init) {
      subscription = ProfileProvider.uploaderBloc(context)
          .pathStream.listen((String path) => widget.upload(path));
      init = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final List<String> sorted = List.from(widget.events.keys)
      ..sort((String a, String b) => widget.events[b].lastMessage
          ?.compareTo(widget.events[a].lastMessage ?? "") ?? -1);
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Center(child: profileImage(width / 6)),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: widget.editing
            ? TextFormField(
              controller: widget.nameController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              textAlign: TextAlign.center,
              maxLines: 1,
              inputFormatters: [LengthLimitingTextInputFormatter(25)],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF424242),
                fontSize: 20.0,
              ),
              decoration: InputDecoration(
                border: underlineInputBorder(),
                enabledBorder: underlineInputBorder(),
                focusedBorder: underlineInputBorder(Colors.redAccent),
              ),
            )
            : Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                widget.user.name ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242),
                  fontSize: 20.0,
                ),
              ),
            ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: widget.editing
            ? TextFormField(
              controller: widget.descriptionController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textAlign: TextAlign.center,
              maxLines: 2,
              maxLength: 70,
              inputFormatters: [LengthLimitingTextInputFormatter(70)],
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14.0,
              ),
              decoration: InputDecoration(
                border: underlineInputBorder(),
                enabledBorder: underlineInputBorder(),
                focusedBorder: underlineInputBorder(Colors.redAccent),
              ),
            )
            : Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                widget.user.description ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.0,
                ),
              ),
            ),
      ),
      sorted.isNotEmpty ? Expanded(
        child: ListView(children: sorted.map((String key) =>
            EventTile(users: widget.users, eventKey: key,
            event: widget.events[key])).toList()),
      ) : EmptyWidget(),
    ]);
  }

  Widget profileImage(double radius) {
    return GestureDetector(
      child: ((widget.path?.isNotEmpty ?? false)
          || (widget.user.image?.isNotEmpty ?? false))
          ? CircleAvatar(
            radius: radius,
            backgroundColor: Colors.white,
            child: TransitionToImage(
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(radius),
              placeholder: InitialsText(widget.user.name),
              loadingWidget: InitialsText(widget.user.name),
              image: AdvancedNetworkImage(
                widget.path ?? widget.user.image,
                useDiskCache: true,
                timeoutDuration: Duration(seconds: 5),
              ),
            ),
            )
          : CircleAvatar(
            radius: radius,
            backgroundColor: Colors.white,
            child: InitialsText(widget.user.name),
          ),
      onTap: () async {
        if (widget.editing) {
          File file = await ImagePicker.pickImage(
              source: ImageSource.gallery, maxHeight: 1500, maxWidth: 1500);
          if (file != null) ProfileProvider.uploaderBloc(context)
              .fileSink.add(file.readAsBytesSync());
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }
}

class EventTile extends StatelessWidget {
  final Map<String, User> users;
  final String eventKey;
  final Event event;

  EventTile({
    @required this.users,
    @required this.eventKey,
    @required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 4.0),
        ExpansionTile(
          backgroundColor: Colors.white,
          leading: CardImage(
            image: event.image,
            asset: randomImage(event.name),
            height: 64,
            width: 64,
          ),
          title: Text(
            event.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // TODO: align trailing to the right so that it has the same padding as profile icon in bar
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                event.count.toString() + " / " + event.slots.toString(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              FlatButton(
                shape: CircleBorder(),
                child: PaintGradient(
                  child: Icon(Icons.share),
                  colorA: Color(0xff7474bf),
                  colorB: Color(0xff348ac7),
                ),
                onPressed: () {
                  Share.share("¡Únete a este haleo! : *" +
                      event.name +
                      "* \n _" +
                      event.description +
                      "_  \n ¡Descarga ya la app en Google Play!"); // TODO: google play link
                },
              ),
            ],
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    event.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Color(0xFF424242),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      event.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]..addAll(event.attendees.map((String key) => userTile(users[key])))
           ..add(SizedBox(height: 16.0)),
        ),
        SizedBox(
          height: 4.0,
        ),
        Divider(),
      ],
    );
  }

  Widget userTile(User user) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24.0,
          backgroundColor: Colors.white,
          child: (user.image?.isNotEmpty ?? false)
              ? TransitionToImage(
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(24.0),
                  placeholder: InitialsText(user.name),
                  loadingWidget: InitialsText(user.name),
                  image: AdvancedNetworkImage(
                    user.image,
                    useDiskCache: true,
                    timeoutDuration: Duration(seconds: 5),
                  ),
                )
              : InitialsText(user.name),
        ),
        title: Text(user.name ?? ""),
        subtitle: Text(user.description ?? ""),
      ),
    );
  }

  String randomImage(String eventName) {
    int assetNumber = eventName.length % 6;
    String asset = 'assets/images/event_' + assetNumber.toString() + ".png";
    return asset;
  }
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/event_3.png'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '¡Ooops! \n Aun no te apuntaste a ningún evento. \n ¡Sigue haciendo swipe right!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

UnderlineInputBorder underlineInputBorder([Color color = Colors.grey]) {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: color,
      width: 2.0,
    ),
  );
}
