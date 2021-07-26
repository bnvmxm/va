import 'package:flutter/material.dart';
import 'package:vocabulary_advancer/app/i18n/strings.g.dart';
import 'package:vocabulary_advancer/app/themes/va_theme.dart';

class PhraseExampleTextFormField extends StatefulWidget {
  const PhraseExampleTextFormField(
      {required this.onSaved,
      required this.onValidate,
      required this.focusNode,
      this.labelText,
      this.maxLines = 3,
      this.iconSize = 32,
      Key? key})
      : super(key: key);

  final String? labelText;
  final FocusNode focusNode;
  final int maxLines;
  final double iconSize;

  final void Function(String value) onSaved;
  final String? Function(String? value) onValidate;

  @override
  State<PhraseExampleTextFormField> createState() =>
      _PhraseExampleTextFormFieldState();
}

class _PhraseExampleTextFormFieldState
    extends State<PhraseExampleTextFormField> {
  final _exampleController = TextEditingController();

  @override
  Widget build(BuildContext context) =>
      Stack(alignment: Alignment.topRight, children: [
        Padding(
            padding: EdgeInsets.only(
                right: _exampleController.text.isEmpty ? 0 : 64.0),
            child: TextFormField(
                controller: _exampleController,
                decoration: InputDecoration(
                    labelText: widget.labelText ??
                        Translations.of(context).labels.AddExample),
                minLines: 1,
                maxLines: widget.maxLines,
                validator: widget.onValidate,
                onChanged: (value) {
                  setState(() {});
                },
                focusNode: widget.focusNode,
                style: VATheme.of(context).textBodyText1)),
        if (_exampleController.text.isNotEmpty)
          IconButton(
              icon: Icon(Icons.add_circle_outline),
              iconSize: widget.iconSize,
              color: VATheme.of(context).colorBackgroundIconSelected,
              padding: const EdgeInsets.all(16.0),
              onPressed: () {
                widget.onSaved(_exampleController.text);
                _exampleController.text = '';
                if (widget.focusNode.hasFocus) {
                  widget.focusNode.unfocus();
                }
              })
      ]);

  @override
  void dispose() {
    _exampleController.dispose();
    super.dispose();
  }
}
