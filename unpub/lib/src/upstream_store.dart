import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class UpstreamStore {
  String baseDir;
  String upstream;
  String Function(String name, String version)? getFilePath;

  UpstreamStore(this.baseDir, this.upstream, {this.getFilePath});

  File _getTarballFile(String name, String version) {
    return File(path.join(baseDir, name, '$name-$version.tar.gz'));
  }

  FutureOr<Stream<List<int>>> download(String name, String version) async {
    var file = _getTarballFile(name, version);
    var file_exists = await file.exists();
    if (!file_exists) {
      Uri upstreamUri = Uri.parse(Uri.parse(upstream)
          .resolve('/packages/$name/versions/$version.tar.gz')
          .toString());
      http.Client client = new http.Client();
      var req = await client.get(upstreamUri);
      var content = req.bodyBytes;
      await file.create(recursive: true);
      await file.writeAsBytes(content);
    }
    return _getTarballFile(name, version).openRead();
  }
}
