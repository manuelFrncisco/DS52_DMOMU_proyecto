import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto1/LodgingPageid.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto1/models/Reservation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  List<Reservation>? reservations;
  String? token;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    token = await getToken();

    final String url = 'https://amavizca.terrabyteco.com/api/profile';
    final Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final http.Response response =
          await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          userData = responseData['profile'];
          List<dynamic>? reservationsData = userData!['reservations'];
          if (reservationsData != null) {
            reservations = reservationsData.map((reservationData) {
              return Reservation.fromJson(reservationData);
            }).toList();
          }
        });
      } else {
        print('Error al cargar los datos del usuario: ${response.body}');
      }
    } catch (e) {
      print('Error de conexión: $e');
    }
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Perfil de usuario'),
      ),
      body: Builder(
        builder: (context) => Center(
          child: userData != null
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: AlignmentDirectional.topStart,
                        padding:
                            const EdgeInsets.only(top: 5, left: 20, bottom: 5),
                        child: Image.network(
                          userData!['image'],
                          width: 300,
                          height: 300,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        alignment: AlignmentDirectional.topStart,
                        child: Column(
                          children: [
                            Container(
                              alignment: AlignmentDirectional.topStart,
                              padding: const EdgeInsets.only(
                                  top: 5, left: 20, bottom: 5),
                              child: Text(
                                'Nombre: ${userData!['name']}',
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Container(
                              alignment: AlignmentDirectional.topStart,
                              padding: const EdgeInsets.only(
                                  top: 5, left: 20, bottom: 5),
                              child: Text(
                                'SurName: ${userData!['surname']}',
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Container(
                              alignment: AlignmentDirectional.topStart,
                              padding: const EdgeInsets.only(
                                  top: 5, left: 20, bottom: 5),
                              child: Text(
                                'Email: ${userData!['email']}',
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Container(
                              alignment: AlignmentDirectional.topStart,
                              padding: const EdgeInsets.only(
                                  top: 5, left: 20, bottom: 5),
                              child: Text(
                                'Phone: ${userData!['phone']}',
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Container(
                              alignment: AlignmentDirectional.topStart,
                              padding: const EdgeInsets.only(
                                  top: 5, left: 20, bottom: 5),
                              child: Text(
                                'Token: $token',
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (reservations != null)
                        ...reservations!.asMap().entries.map((entry) {
                          final index = entry.key;
                          final reservation = entry.value;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyLodgingPageId(
                                    id: reservation.lodgingId,
                                    title: '',
                                  ), // Pasa el lodgingId al constructor
                                ),
                              );
                            },
                            child: Container(
                              color: Color.fromARGB(224, 243, 227, 192),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        'Nombre Hotel: ${reservation.name}'),
                                    subtitle: Text(
                                        'Fecha inicio: ${reservation.startDate}'),
                                  ),
                                  if (index != reservations!.length - 1)
                                    Container(
                                      height: 1,
                                      color: Colors.grey.withOpacity(0.5),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
