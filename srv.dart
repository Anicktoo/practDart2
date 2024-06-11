import 'dart:async';
import 'dart:io';

import 'package:mysql_client/mysql_client.dart';

var hostDockerInternalAddress;
final collation = "utf8mb4_unicode_ci";
// final codec = const Windows1252Codec(allowInvalid: true);

void main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8888);
  print('Listening for connections on http://host.docker.internal:8888/');
  hostDockerInternalAddress = await getHostDockerInternalAddress();

  await server.forEach((HttpRequest request) {
    switch (request.uri.path) {
      case "/":
        print(request.uri);
        var uri = Uri.parse(request.uri.toString());
        uri.queryParameters.forEach((k, v) {
          print('key: $k - value: $v');
        });
        print('Count: ' + uri.queryParameters.length.toString());
        if (uri.queryParameters.length > 0) {
          // Добавление одной строки в таблицу.
          rowInsert(uri.queryParameters);
        }
        break;
    }
    final res = request.response;
    ReadTpl(res);
  });
}

Future<String> getHostDockerInternalAddress() async {
  final addresses = await InternetAddress.lookup('host.docker.internal');
  return addresses.isNotEmpty ? addresses.first.address : '192.168.0.102';
}

void ReadTpl(res) async {
  res.headers.add(HttpHeaders.contentTypeHeader, "text/html; charset=utf-8");
  File file = File("select.html");
  var lines = await file.readAsLines();
  for (final line in lines) {
    if (line.contains("@tr")) {
      await viewSelect(res);
    } else if (line.contains("@ver")) {
      await viewVer(res);
    } else {
      res.write(line);
    }
  }
  res.close();
}

Future<void> viewSelect(res) async {
  try {
    final name1 = "Observation";
    final name2 = "Natural_objects";
    final conn = await MySQLConnection.createConnection(
      host: hostDockerInternalAddress,
      port: 3306,
      userName: "root",
      password: "qwerty",
      databaseName: "test",
      collation: collation,
    );
    await conn.connect();
    res.write('<table>');
    var table =
        await conn.execute("SELECT * FROM ${name1} NATURAL JOIN ${name2}");
    final numOfCols = table.numOfColumns;
    res.write('<tr>');
    for (var col in table.cols) {
      res.write('<td>${col.name}</td>');
    }
    res.write('</tr>');

    for (var row in table.rows) {
      res.write('<tr>');
      for (var i = 0; i < numOfCols; i++) {
        var val = row.colAt(i);
        res.write('<td>${val}</td>');
      }
      res.write('</tr>');
    }
    res.write('</table>');
    await conn.close();
  } on Exception catch (e) {
    res.write('WAITING FOR SQL SERVER TO SETUP');
    print('viewSelect: $e');
  }
}

Future<void> viewVer(res) async {
  try {
    final conn = await MySQLConnection.createConnection(
        host: hostDockerInternalAddress,
        port: 3306,
        userName: "root",
        password: "qwerty",
        databaseName: "test",
        collation: collation);
    await conn.connect();
    var vers = await conn.execute("SELECT VERSION() AS ver");
    for (var ver in vers.rows) {
      res.write('${ver.colAt(0)}');
    }
    await conn.close();
  } on Exception catch (e) {
    res.write('WAITING FOR SQL SERVER TO SETUP');
    print('viewVer: $e');
  }
}

var id = 7;
Future<void> rowInsert(mass) async {
  try {
    print('rowInsert');
    String sValue = '';
    int i = 0;
    mass.forEach((k, v) {
      if (i > 0) {
        sValue = sValue + ',';
      }
      sValue = sValue + "'$v'";
      i++;
    });
    sValue =
        'INSERT INTO Natural_objects (type, galaxy, accuracy, light_flux, associated_objects, notes) VALUES ($sValue)';
    String sValue2 =
        "INSERT INTO Observation (sector_id, object_id, natural_object_id, location_id, observer_notes, date_update) VALUES (1, NULL, ${id}, 1, 'Some notes', NOW())";
    id++;
    final conn = await MySQLConnection.createConnection(
        host: hostDockerInternalAddress,
        port: 3306,
        userName: "root",
        password: "qwerty",
        databaseName: "test",
        collation: collation);
    await conn.connect();
    await conn.execute(sValue);
    await Future.delayed(Duration(milliseconds: 500));
    await conn.execute(sValue2);
    await conn.close();
    print('Insert into table is good.');
  } on Exception catch (e) {
    print('rowInsert: $e');
  }
}
