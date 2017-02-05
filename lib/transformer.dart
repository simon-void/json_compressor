import 'dart:async';
import 'dart:convert';
import 'package:barback/barback.dart';

class CompressJsonTransformer extends Transformer {
  String get allowedExtensions => ".json";
  bool _doCompress;
  JsonDecoder _jsonDecoder;
  JsonEncoder _jsonEncoder;

  CompressJsonTransformer.asPlugin(BarbackSettings settings) {
    final isDebugMode = settings.mode.name == 'debug';
    final validOptions = const['off', 'single_row', 'no_indent', 'indent1', 'indent2', 'indent4'];

    // get the configured mode
    var mode = isDebugMode ? settings.configuration['debugMode'] : settings.configuration['prodMode'];
    // fallback on default value
    mode ??= isDebugMode ? 'no_indent' : 'single_row';
    // if illegal mode was provided, disable compression
    if(!validOptions.contains(mode)) {
      mode = 'off';
    }

    String indent;
    switch(mode) {
      case 'single_row':
        _doCompress = true;
        indent = null;
        break;
      case 'no_indent':
        _doCompress = true;
        indent = '';
        break;
      case 'indent1':
        _doCompress = true;
        indent = ' ';
        break;
      case 'indent2':
        _doCompress = true;
        indent = '  ';
        break;
      case 'indent4':
        _doCompress = true;
        indent = '    ';
        break;
      default:
        _doCompress = false;
    }

    if(_doCompress) {
      _jsonDecoder = new JsonDecoder();
      _jsonEncoder = new JsonEncoder.withIndent(indent);
    }
  }

  Future apply(Transform transform) async {
    final id = transform.primaryInput.id;
    if(!_doCompress) {
      transform.logger.info("compressing json files is off", asset: id);
      return;
    }

    var content = await transform.primaryInput.readAsString();

    try {
      var newContent = _compressJson(content);
      transform.addOutput(new Asset.fromString(id, newContent));
      transform.logger.info("compressed json file", asset: id);
    } /*on FormatException*/ catch (e) {
      transform.logger.warning("couldn't compress json file (err: $e)", asset: id);
    }
  }

  String _compressJson(String jsonContent) {
    var obj = _jsonDecoder.convert(jsonContent);
    return _jsonEncoder.convert(obj);
  }
}