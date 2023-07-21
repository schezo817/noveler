import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../function/Func.dart';
import '../page/posting_button_link_change.dart';

class UnlinkedHpDialog extends ConsumerStatefulWidget {
  String errorText;

  UnlinkedHpDialog({
    required this.errorText,
  });

  @override
  ConsumerState createState() => _UnlinkedHpDialogState();
}

class _UnlinkedHpDialogState extends ConsumerState<UnlinkedHpDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("URLが正しくありません。"),
      content: Text(widget.errorText),
      actions: [
        TextButton(
          onPressed: () {
            Func.movePage(context, PostingButtonLinkChange());
          },
          child: const Text('修正する'),
        )
      ],
    );
  }
}
