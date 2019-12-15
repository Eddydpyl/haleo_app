// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'es';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "accountNotFoundText" : MessageLookupByLibrary.simpleMessage("No existe una cuenta con el correo electrónico proporcionado."),
    "disabledUserText" : MessageLookupByLibrary.simpleMessage("Tu usuario ha sido deshabilitado por un administrador."),
    "errorSignInText" : MessageLookupByLibrary.simpleMessage("Hubo un problema y no se pudo iniciar sesión."),
    "errorSignUpText" : MessageLookupByLibrary.simpleMessage("Hubo un problema y no se pudo registrar."),
    "invalidEmailText" : MessageLookupByLibrary.simpleMessage("La dirección de correo electrónico no es válida."),
    "invalidPasswordText" : MessageLookupByLibrary.simpleMessage("La contraseña debe de tener por lo menos 6 caracteres."),
    "invalidSignInText" : MessageLookupByLibrary.simpleMessage("La dirección de correo electrónico o la contraseña son incorrectas."),
    "passwordSentText" : MessageLookupByLibrary.simpleMessage("Se ha enviado un enlace para restablecer tu contraseña a tu correo."),
    "usedEmailText" : MessageLookupByLibrary.simpleMessage("La dirección de correo electrónico ya está en uso.")
  };
}
