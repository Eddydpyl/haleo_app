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

  static m0(count) => "${Intl.plural(count, one: 'Se ha apuntado ${count}.', other: 'Se han apuntado ${count}.')}";

  static m1(spaces) => "${Intl.plural(spaces, one: '¡Solo queda ${spaces} sitio!', other: '¡Solo quedan ${spaces} sitios!')}";

  static m3(name, description) => "¡Únete a este haleo! : *${name}* \n _${description}_ \n ¡Descarga la app en Google Play! https://play.google.com/apps/testing/io.darter.haleo";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "_attendeesCountText" : m0,
    "_attendeesSpacesText" : m1,
    "accountNotFoundText" : MessageLookupByLibrary.simpleMessage("No existe una cuenta con el correo electrónico proporcionado."),
    "createText" : MessageLookupByLibrary.simpleMessage("Armar"),
    "disabledUserText" : MessageLookupByLibrary.simpleMessage("Tu usuario ha sido deshabilitado por un administrador."),
    "emptyProfile" : MessageLookupByLibrary.simpleMessage("¡Oops! \n ¡Estamos trabajando en algunas funcionalidades increibles para tu perfil! \n ¡Puntos, títulos y analíticas llegarán pronto!"),
    "errorSignInText" : MessageLookupByLibrary.simpleMessage("Hubo un problema y no se pudo iniciar sesión."),
    "errorSignUpText" : MessageLookupByLibrary.simpleMessage("Hubo un problema y no se pudo registrar."),
    "eventBodyHintText" : MessageLookupByLibrary.simpleMessage("Qué te apetece hacer? Qué lenguajes hablas? Cuándo te viene mejor quedar?"),
    "eventClosedText" : MessageLookupByLibrary.simpleMessage("¡Este evento ha sido cerrado!"),
    "eventCreatedText" : MessageLookupByLibrary.simpleMessage("¡Se ha creado tu evento! Ahora a esperar a que la gente se apunte."),
    "eventEmptyFilledText" : MessageLookupByLibrary.simpleMessage("¡Oops! \n Aún no te has unido a ningún evento. ¡Sigue haciendo swipe right!"),
    "eventEmptyReadText" : MessageLookupByLibrary.simpleMessage("No hay más eventos. \n ¿Por qué no creas el tuyo propio?"),
    "eventTitleHintText" : MessageLookupByLibrary.simpleMessage("Tomar una cerveza, darse un paseo, visitar la catedral ..."),
    "existingAccountText" : MessageLookupByLibrary.simpleMessage("Ya existe una cuenta usando este correo electrónico. Prueba a iniciar sesión con otro proveedor."),
    "exitNoText" : MessageLookupByLibrary.simpleMessage("NO"),
    "exitPromtText" : MessageLookupByLibrary.simpleMessage("¿Seguro que quieres salirte?"),
    "exitYesText" : MessageLookupByLibrary.simpleMessage("SI"),
    "haleoText" : MessageLookupByLibrary.simpleMessage("¡haleo!"),
    "invalidEmailText" : MessageLookupByLibrary.simpleMessage("La dirección de correo electrónico no es válida."),
    "invalidPasswordText" : MessageLookupByLibrary.simpleMessage("La contraseña debe de tener por lo menos 6 caracteres."),
    "invalidSignInText" : MessageLookupByLibrary.simpleMessage("La dirección de correo electrónico o la contraseña son incorrectas."),
    "locationErrorText" : MessageLookupByLibrary.simpleMessage("Hubo un error recuperando tu ubicación."),
    "locationPermissionText" : MessageLookupByLibrary.simpleMessage("Necesitamos tu ubicación para crear un evento."),
    "messageHintText" : MessageLookupByLibrary.simpleMessage("Escribe un mensaje"),
    "passwordSentText" : MessageLookupByLibrary.simpleMessage("Se ha enviado un enlace para restablecer tu contraseña a tu correo."),
    "profileText" : MessageLookupByLibrary.simpleMessage("Tu cara!"),
    "promoText" : MessageLookupByLibrary.simpleMessage("Encuentra eventos cerca de ti. \n ¡Estás a un click de distancia!"),
    "shareText" : m3,
    "signInText" : MessageLookupByLibrary.simpleMessage("Iniciar Sesión"),
    "slotsNumberText" : MessageLookupByLibrary.simpleMessage("¿Número mínimo de participantes?"),
    "uploadErrorText" : MessageLookupByLibrary.simpleMessage("Hubo un error inesperado y no se pudo subir el archivo."),
    "usedEmailText" : MessageLookupByLibrary.simpleMessage("La dirección de correo electrónico ya está en uso."),
    "userUpdatedText" : MessageLookupByLibrary.simpleMessage("Tu perfil ha sido actualizado."),
    "yourText" : MessageLookupByLibrary.simpleMessage("Tu")
  };
}
