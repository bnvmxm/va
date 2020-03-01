import 'package:flutter/material.dart';

class PhraseExampleTextFormField extends StatefulWidget {
  const PhraseExampleTextFormField(
      {@required this.focusNode,
      @required this.onSaved,
      @required this.onValidate,
      this.labelText,
      this.maxLines,
      Key key})
      : super(key: key);

  final String labelText;
  final int maxLines;
  final FocusNode focusNode;
  final void Function(String value) onSaved;
  final String Function(String value) onValidate;

  @override
  State<PhraseExampleTextFormField> createState() => _PhraseExampleTextFormFieldState();
}

class _PhraseExampleTextFormFieldState extends State<PhraseExampleTextFormField> {
  final _exampleController = TextEditingController();

  @override
  Widget build(BuildContext context) => Stack(alignment: Alignment.topRight, children: [
        Padding(
            padding: EdgeInsets.only(right: _exampleController.text.isEmpty ? 0 : 64.0),
            child: TextFormField(
                controller: _exampleController,
                decoration: InputDecoration(labelText: widget.labelText ?? 'Add Example'),
                minLines: 1,
                maxLines: widget.maxLines ?? 3,
                validator: widget.onValidate,
                onChanged: (value) {
                  setState(() {});
                },
                focusNode: widget.focusNode)),
        if (_exampleController.text.isNotEmpty)
          IconButton(
              icon: Icon(Icons.add_circle_outline),
              iconSize: 32.0,
              color: Theme.of(context).accentColor,
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
