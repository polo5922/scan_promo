import 'package:flutter/material.dart';
import 'package:scan_promo/home.dart';
import 'package:http/http.dart' as http;

Future<String> fetchData(qrResult, type, email) async {
  var queryParameters = {
    'qr_value': qrResult,
    'type': type,
    'email': email,
  };
  String url = 'tartapain.bzh';
  var uri = Uri.https(url, '/api/scan/set.php', queryParameters);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load the post');
  }
}

class QrResult extends StatefulWidget {
  final String qrValue;
  final String email;

  const QrResult({Key key, this.qrValue, this.email}) : super(key: key);

  @override
  _QrResult createState() => _QrResult();
}

class _QrResult extends State<QrResult> {
  Future<String> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData(widget.qrValue, 'add_user_qr', widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scan promo'),
        ),
        body: Column(
          children: [
            FutureBuilder(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text("Loading..."));
                  }
                  if (snapshot.hasData) {
                    return Text(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    );
                  } else {
                    return CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.black));
                  }
                }),
            FloatingActionButton.extended(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.black,
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              email: widget.email,
                            )))
              },
              icon: Icon(Icons.arrow_back),
              label: Text('Retour'),
            )
          ],
        ),
      ),
    );
  }
}