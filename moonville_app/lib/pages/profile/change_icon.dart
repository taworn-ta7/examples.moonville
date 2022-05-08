import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:moonville_client_dart/moonville_client_dart.dart';
import 'package:file_picker/file_picker.dart';
import '../../i18n/strings.g.dart';
import '../../widgets/image_chooser.dart';
import '../../widgets/service_runner.dart';
import '../../loggings.dart';
import '../../styles.dart';
import '../../app_shared.dart';
import '../../pages.dart';
import '../../ui/custom_app_bar.dart';

/// ChangeIconPage class.
class ChangeIconPage extends StatefulWidget {
  const ChangeIconPage({Key? key}) : super(key: key);

  @override
  _ChangeIconState createState() => _ChangeIconState();
}

/// _ChangeIconState internal class.
class _ChangeIconState extends State<ChangeIconPage> {
  static final log = Logger('ChangeIconPage');
  static final shared = AppShared.instance();

  // widgets
  final _formKey = GlobalKey<FormState>();
  late bool _imageEditing;
  late PlatformFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _imageEditing = false;
    _imageFile = null;
    log.fine('$this initState()');
  }

  @override
  void dispose() {
    log.fine('$this dispose()');
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.changeIconPage;
    return WillPopScope(
      child: Scaffold(
        appBar: CustomAppBar(
          title: tr.title,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Styles.around(
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // icon
                  Text(
                    tr.icon,
                    style: Styles.titleTextStyle(),
                  ),
                  ImageChooser(
                    width: 128,
                    height: 128,
                    asset: 'assets/default-profile-icon.png',
                    bits: shared.client.user?.icon,
                    onUpload: (file) {
                      _imageEditing = true;
                      _imageFile = file;
                    },
                    onReset: () {
                      _imageEditing = true;
                      _imageFile = null;
                    },
                    onRevert: () {
                      _imageEditing = false;
                    },
                  ),
                  Styles.betweenVertical(),

                  // ok
                  ElevatedButton.icon(
                    icon: const Icon(Icons.update),
                    label: Styles.buttonPadding(Text(tr.ok)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _save();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: _beforeBack,
    );
  }

  // ----------------------------------------------------------------------

  /// Before leave page.
  Future<bool> _beforeBack() async {
    final isChanged = _imageEditing;
    return Pages.beforeBack(context, isChanged);
  }

  // ----------------------------------------------------------------------

  /// Save data.
  Future<void> _save() async {
    final shared = AppShared.instance();
    final client = shared.client;

    // call REST
    if (_imageEditing) {
      if (_imageFile != null) {
        log.finest('image upload');
        final RestResult? rest = await ServiceRunner.execute(
          context,
          () async {
            try {
              // prepare upload file
              final path = _imageFile!.name;
              final mime = lookupMimeType(path, headerBytes: _imageFile!.bytes);
              final file = http.MultipartFile.fromBytes(
                'image',
                _imageFile!.bytes!,
                filename: _imageFile!.name,
                contentType: MediaType.parse(mime ?? ''),
              );

              // send request and receive response
              final req = http.MultipartRequest(
                'POST',
                client.getUri('profile/icon'),
              );
              req.headers.addAll({
                'Content-Type': 'multipart/form-data',
                'Authorization': 'Bearer ' + client.token,
              });
              req.files.add(file);
              final res = await req.send();
              return RestResult(await http.Response.fromStream(res));
            } catch (ex) {
              return RestResult.error(ex.toString());
            }
          },
        );
        if (rest == null) return;
        client.user?.icon = _imageFile!.bytes!;
      } else {
        log.finest('image reset');
        final RestResult? rest = await ServiceRunner.execute(
          context,
          () async {
            try {
              return RestResult(
                await http.delete(
                  client.getUri('profile/icon'),
                  headers: client.headers,
                ),
              );
            } catch (ex) {
              return RestResult.error(ex.toString());
            }
          },
        );
        if (rest == null) return;
        client.user?.icon = null;
      }
    }

    // go back
    Navigator.pop(context, true);
  }
}
