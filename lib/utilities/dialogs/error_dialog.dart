import 'package:flutter/material.dart';
import 'package:my_notes/extensions/build_context/loc.dart';
import 'package:my_notes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: context.loc.generic_error_prompt,
    content: text,
    options: {
      context.loc.ok: null,
    },
  );
}
