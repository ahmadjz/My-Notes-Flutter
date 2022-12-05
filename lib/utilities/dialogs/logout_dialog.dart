import 'package:flutter/material.dart';
import 'package:my_notes/extensions/build_context/loc.dart';
import 'package:my_notes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: context.loc.logout_button,
      content: context.loc.logout_dialog_prompt,
      options: {
        context.loc.cancel: false,
        context.loc.logout_button: true,
      }).then(
    (value) => value ?? false,
  );
}
