import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:image_picker/image_picker.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../blocs/user_bloc.dart';
import '../../../models/user.dart';
import '../../common_widgets.dart';
import '../../../localization.dart';

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
          return ProfileList(
            nameController: nameController,
            descriptionController: descriptionController,
            editing: editing,
            upload: upload,
            path: path,
            user: user,
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
  final User user;

  ProfileList({
    @required this.nameController,
    @required this.descriptionController,
    @required this.upload,
    @required this.editing,
    @required this.path,
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
    final Localization localization = ApplicationProvider.localization(context);
    final double width = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
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
        EmptyWidget(localization),
      ],
    );
  }

  Widget profileImage(double radius) {
    return GestureDetector(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          ((widget.path?.isNotEmpty ?? false) ||
                  (widget.user.image?.isNotEmpty ?? false))
              ? CircleAvatar(
                  radius: radius,
                  backgroundColor: Colors.white,
                  child: TransitionToImage(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(radius),
                    placeholder: InitialsText(widget.user.name, radius / 2),
                    loadingWidget: InitialsText(widget.user.name, radius / 2),
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
                  child: InitialsText(widget.user.name, radius / 2),
                ),
          widget.editing
              ? Container(
                  width: radius * 2,
                  height: radius * 2,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: PaintGradient(
                    child: Icon(
                      Icons.photo,
                      size: 32.0,
                    ),
                    colorA: Color(0xfffa6b40),
                    colorB: Color(0xfffd1d1d),
                  ),
                )
              : Container(height: 0.0),
        ],
      ),
      onTap: () async {
        if (widget.editing) {
          File file = await ImagePicker
              .pickImage(source: ImageSource.gallery,
              maxHeight: 1500, maxWidth: 1500);
          if (file != null) {
            ProfileProvider.uploaderBloc(context)
                .fileSink.add(file.readAsBytesSync());
          }
        }
      },
    );
  }

  UnderlineInputBorder underlineInputBorder([Color color = Colors.grey]) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 2.0,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }
}

class EmptyWidget extends StatelessWidget {
  final Localization localization;

  EmptyWidget(this.localization);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Image.asset("assets/images/coding.png"),
            ),
            Padding(
              padding: const EdgeInsets
                  .symmetric(vertical: 16.0, horizontal: 32.0),
              child: Text(
                localization.emptyProfile(),
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
