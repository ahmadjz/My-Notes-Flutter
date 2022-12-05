import 'package:flutter/material.dart';
import 'package:my_notes/extensions/build_context/loc.dart';
import 'package:my_notes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: context.loc.password_reset,
    content: context.loc.password_reset_dialog_prompt,
    options: {
      context.loc.ok: null,
    },
  );
}
