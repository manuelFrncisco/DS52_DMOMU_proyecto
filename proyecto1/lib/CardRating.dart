import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto1/LodgingPageid.dart';

class RatingPage extends StatefulWidget {
  final int reservationId;
  final int lodgingId;

  const RatingPage(
      {Key? key, required this.reservationId, required this.lodgingId})
      : super(key: key);

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int selectedRating = 0;

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> createRating(
      int number, int reservationId, int lodgingId) async {
    try {
      final String? token = await getToken();

      if (token != null) {
        final url = Uri.parse('https://amavizca.terrabyteco.com/api/rating/create');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'number': number,
            'lodging_id': lodgingId,
            'reservation_id': reservationId,
          }),
        );
        if (response.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyLodgingPageId(id: lodgingId, title: ''),
              settings: RouteSettings(
                  arguments: 'Calificación enviada correctamente'),
            ),
          );
        } else {
          final responseData = jsonDecode(response.body);
          if (responseData.containsKey('message') &&
              responseData['message'] == 'Ya has calificado este alojamiento') {
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyLodgingPageId(id: lodgingId, title: ''),
              settings: RouteSettings(
                  arguments: 'Ya has calificado este alojamiento'),
            ),
          );
          } else {
            print(
                'Failed to create rating. Status code: ${response.statusCode}');
            print('Response body: ${response.body}');
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyLodgingPageId(id: lodgingId, title: ''),
              settings: RouteSettings(
                  arguments: 'Error al enviar la calificación'),
            ),
          );
          }
        }
      } else {
        print('No se encontro el token');
      }
    } catch (e) {
      print('Ocurrio algo inesperado: $e');
      Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyLodgingPageId(id: lodgingId, title: ''),
              settings: RouteSettings(
                  arguments: 'Ocurrio algo inesperado'),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calificar reserva'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¿Cuántas estrellas le darías a esta reserva?'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 5; i++)
                  IconButton(
                    icon: Icon(Icons.star,
                        color:
                            selectedRating >= i ? Colors.yellow : Colors.grey),
                    onPressed: () {
                      setState(() {
                        selectedRating = i;
                      });
                    },
                  ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedRating > 0) {
                  print('Selected Rating: $selectedRating');
                  createRating(
                      selectedRating, widget.reservationId, widget.lodgingId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, selecciona una calificación'),
                    ),
                  );
                }
              },
              child: Text('Calificar'),
            ),
          ],
        ),
      ),
    );
  }
}
