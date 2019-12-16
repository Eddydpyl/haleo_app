1st. Generate intl_messages.arb using "flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localization.dart".

2nd. Copy the resulting file contents into intl_\*.arb (create one such file per locale).

3rd. Generate messages_\*.dart files using "flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n lib/localization.dart lib/l10n/intl_\*.arb".
     Replace the asterisks by the locale of the file, and simply type the location of all intl_\*.dart files one after another.