import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../i18n/strings.g.dart';

/// An image choose from dialog box or reset it.
class ImageChooser extends StatefulWidget {
  static const filterImageExtensions = [
    'jpeg',
    'jpg',
    'png',
    'gif',
    'webp',
    'bmp',
    'wbmp',
  ];

  final double width;
  final double height;
  final String asset;
  final Uint8List? bits;
  final String? uri;
  final BoxFit fit;
  final void Function(PlatformFile file) onUpload;
  final void Function() onReset;
  final void Function() onRevert;

  const ImageChooser({
    Key? key,
    required this.width,
    required this.height,
    required this.asset,
    this.bits,
    this.uri,
    this.fit = BoxFit.contain,
    required this.onUpload,
    required this.onReset,
    required this.onRevert,
  }) : super(key: key);

  @override
  _ImageChooserState createState() => _ImageChooserState();
}

class _ImageChooserState extends State<ImageChooser> {
  // image editing
  bool _edited = false;
  PlatformFile? _file;
  Uint8List? _bits;

  // ----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final tr = t.imageChooser;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // image
        _buildImage(context),

        // delimiter
        const Padding(padding: EdgeInsets.only(bottom: 8)),

        // buttons
        Row(
          children: [
            // upload button
            TextButton.icon(
              icon: const Icon(Icons.upload),
              label: Text(tr.upload),
              onPressed: () => upload(),
            ),

            // reset button
            TextButton.icon(
              icon: const Icon(Icons.restart_alt),
              label: Text(tr.reset),
              onPressed: () {
                setState(() {
                  _edited = true;
                  _file = null;
                  _bits = null;
                });
                widget.onReset.call();
              },
            ),

            // revert button
            TextButton.icon(
              icon: const Icon(Icons.restore),
              label: Text(tr.revert),
              onPressed: () {
                setState(() {
                  _edited = false;
                });
                widget.onRevert.call();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    if (_edited) {
      if (_bits != null) {
        return Image.memory(
          _bits!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      } else {
        return Image.asset(
          widget.asset,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      }
    } else {
      if (widget.uri != null) {
        return Image.network(
          widget.uri!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          loadingBuilder: (context, child, progress) {
            return progress == null ? child : const LinearProgressIndicator();
          },
        );
      }
      if (widget.bits != null) {
        return Image.memory(
          widget.bits!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      } else {
        return Image.asset(
          widget.asset,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      }
    }
  }

  // ----------------------------------------------------------------------

  Future<void> upload() async {
    // open file dialog
    final answer = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ImageChooser.filterImageExtensions,
      withData: true,
    );

    if (answer != null) {
      setState(() {
        _edited = true;
        _file = answer.files.first;
        _bits = _file!.bytes;
      });
      widget.onUpload.call(_file!);
    }
  }
}
