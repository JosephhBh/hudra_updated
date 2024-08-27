import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchField extends StatefulWidget {
  Function(String) changeLast10Search;
  TextEditingController textEditingController;

  SearchField({
    Key? key,
    required this.textEditingController,
    required this.changeLast10Search,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  String _lastSubmittedValue = '';
  bool _submitted = true;
  Timer? _debounce;
  static const int _debounceTime = 500;

  int _k = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          onSubmitted: (value) => _onSearchChanged(),
          onChanged: (value) {
            if (widget.textEditingController.text != _lastSubmittedValue) {
              setState(() {
                _submitted = false;
              });
            }
            if (widget.textEditingController.text == _lastSubmittedValue) {
              setState(() {
                _submitted = true;
              });
            }
          },
          controller: widget.textEditingController,
          autofocus: false,
          autocorrect: false,
          style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 15,
              decoration: TextDecoration.none),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            hintText: 'Search',
            hintStyle:
                TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                bottom: 15.0,
                right: 12.0,
                left: 15.0,
              ),
              child: SvgPicture.asset(
                'Assets/Icons/search-normal.svg',
                height: 23,
                width: 23,
                color: Colors.transparent,
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minHeight: 23, minWidth: 23),
            filled: true,
            fillColor: Colors.white12,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .color!
                      .withOpacity(0.7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .color!
                      .withOpacity(0.7)),
            ),
          ),
        ),
        Positioned(
          top: 15,
          left: 15,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              _onSearchChanged();
            },
            child: SvgPicture.asset(
              /// key: ValueKey(_k),
              'Assets/Icons/search-normal.svg',
              height: 23,
              width: 23,
              color: !_submitted ||
                      widget.textEditingController.text != _lastSubmittedValue
                  ? Theme.of(context).textTheme.bodySmall?.color
                  : Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }

  void _onSearchChanged() {
    widget.textEditingController.text =
        widget.textEditingController.text.trim();
    if (widget.textEditingController.text == '') {
      return;
    }
    if (_submitted == false ||
        widget.textEditingController.text != _lastSubmittedValue) {
      setState(() {
        _submitted = true;
        _k++;
      });
      _lastSubmittedValue = widget.textEditingController.text;
      widget.changeLast10Search(widget.textEditingController.text);
      debugPrint('=============================');

      debugPrint('=============================');
      // if (_debounce?.isActive ?? false) _debounce?.cancel();
      // _debounce = Timer(const Duration(milliseconds: _debounceTime), () {
      //   if (textEditingController.text != "") {
      //   }
      // });
    }
  }
}
