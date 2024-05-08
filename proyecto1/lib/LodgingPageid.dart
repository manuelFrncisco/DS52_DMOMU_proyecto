import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:proyecto1/routes/api.dart';
import 'package:proyecto1/models/Lodging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto1/models/Comment.dart';
import 'dart:convert';
import 'package:proyecto1/CardRating.dart';

class MyLodgingPageId extends StatefulWidget {
  final int id;
  final String title;
  const MyLodgingPageId({Key? key, required this.id, required this.title})
      : super(key: key);

  @override
  State<MyLodgingPageId> createState() => _MyLodgingPageIdState();
}

class _MyLodgingPageIdState extends State<MyLodgingPageId> {
  String? message;
  late Future<Lodging> futureLodging;
  late Future<List<Comment>> fetchComments;
  late TextEditingController _commentMessage;

  @override
  void initState() {
    super.initState();
    _commentMessage = TextEditingController();
    futureLodging = fetchLodging(widget.id);
    fetchComments = fetchCommentsByLodging(widget.id);
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> createComment(String messaje) async {
    try {
      final String? token = await getToken();

      if (token != null) {
        final url =
            Uri.parse('https://amavizca.terrabyteco.com/api/comment/create');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'messaje': messaje,
            'lodging_id': widget.id,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Comentario enviado correctamente')),
          );
          setState(() {
            fetchComments = fetchCommentsByLodging(widget.id);
          });
        } else {
          print(
              'Failed to create comment. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al enviar el comentario')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró el token')),
        );
      }
    } catch (e) {
      print('Failed to create comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar el comentario')),
      );
    }
  }

  Future<void> createReservation(DateTime startDate, DateTime endDate) async {
    try {
      final String? token = await getToken();
      if (token != null) {
        final url =
            Uri.parse('https://amavizca.terrabyteco.com/api/reserva/create');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'lodging_id': widget.id,
            'start_date': startDate.toLocal().toString(),
            'end_date': endDate.toLocal().toString(),
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reserva exitosa')),
          );
        } else {
          final responseData = json.decode(response.body);
          if (responseData.containsKey('error') &&
              responseData['error'] ==
                  'Ya tienes una reserva para este lodging') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Ya tienes una reserva para este lodging')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al crear reserva')),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró el token')),
        );
      }
    } catch (e) {
      print('Failed to create reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al reservar')),
      );
    }
  }

  Future<int> getUserReservations() async {
    try {
      final String? token = await getToken();

      if (token != null) {
        final url = Uri.parse('https://amavizca.terrabyteco.com/api/profile');
        final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final List<dynamic> reservations =
              responseData['profile']['reservations'];
          final List<int> reservationIds = reservations
              .map<int>((reservation) => reservation['id'])
              .toList();
          final int reservationId = reservationIds.firstWhere((id) {
            final reservation = reservations
                .firstWhere((res) => res['id'] == id, orElse: () => null);
            return reservation != null &&
                reservation['lodging_id'] == widget.id;
          },
              orElse: () =>
                  throw Exception('No reservation found for this lodging'));

          return reservationId;
        } else {
          print(
              'Failed to fetch user reservations. Status code: ${response.statusCode}');
          throw Exception(
              'Failed to fetch user reservations. Status code: ${response.statusCode}');
        }
      } else {
        print('No se encontró el token');
        throw Exception('No token found');
      }
    } catch (e) {
      print('Error al obtener las reservas del usuario: $e');
      throw Exception('Error al obtener las reservas del usuario: $e');
    }
  }

  Widget buildStarRating(double averageRating) {
    int rating = averageRating.round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating) {
          return Icon(Icons.star, color: Colors.yellow);
        } else {
          return Icon(Icons.star_border, color: Colors.grey);
        }
      }),
    );
  }

  Future<double> fetchAverageRatingForLodging(int id) async {
    final String apiUrl =
        'https://amavizca.terrabyteco.com/api/rating/lodging/$id';
    final response = await http.get(Uri.parse(apiUrl));
    final Map<String, dynamic> data = json.decode(response.body);
    final double averageRating = data['average_rating'];
    print('Average Rating: $averageRating');

    if (response.statusCode == 200) {
      return averageRating;
    } else {
      throw Exception('Failed to load average rating');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      message = args;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) => ListView(
          children: [
            Builder(
              builder: (context) {
                if (message != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(message!),
                          behavior: SnackBarBehavior.fixed),
                    );
                  });
                }
                return SizedBox.shrink(); // No mostrar nada en la vista
              },
            ),
            FutureBuilder<Lodging>(
              future: futureLodging,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    alignment: AlignmentDirectional.bottomStart,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.network(
                          snapshot.data!.image,
                          width: 400,
                          height: 300,
                          fit: BoxFit.fill,
                        ),
                        Container(
                          alignment: AlignmentDirectional.topStart,
                          padding: const EdgeInsets.only(left: 45, top: 10),
                          child: Text(
                            snapshot.data!.name,
                            style: const TextStyle(fontSize: 50),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 45),
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            'Ubicación: ${snapshot.data!.location.streep}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 40, top: 20),
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            ' ${snapshot.data!.description}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 45, top: 15),
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            'Baños: ${snapshot.data!.backroom.toString()}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 45),
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                              'Fecha de Inicio: ${snapshot.data!.startRange.toString()}',
                              style: TextStyle(fontSize: 20)),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 45),
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            'Fecha Final: ${snapshot.data!.endRange.toString()}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 40, top: 20),
                          alignment: AlignmentDirectional.bottomStart,
                          child: ElevatedButton(
                            onPressed: () async {
                              final startDate =
                                  snapshot.data!.startRange.toLocal();
                              final endDate = snapshot.data!.endRange.toLocal();
                              await createReservation(startDate, endDate);
                            },
                            child: Text('Reservar'),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('auxilia ' + '${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(30),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentMessage,
                          decoration: InputDecoration(
                            hintText: 'Enter your comment here',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String messaje = _commentMessage.text;
                          if (messaje.isNotEmpty) {
                            await createComment(messaje);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('El mensaje no puede estar vacío'),
                              ),
                            );
                          }
                        },
                        child: const Text('Enviar'),
                      ),
                    ],
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () async {},
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(10),
                    child: FutureBuilder<List<Comment>>(
                      future: fetchComments,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No hay comentarios'));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data![index].messaje),
                                subtitle: Text(
                                  'Usuario: ${snapshot.data![index].user.name}',
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final int reservationId = await getUserReservations();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RatingPage(
                  reservationId: reservationId,
                  lodgingId: widget.id,
                ),
              ),
            );
          } catch (e) {
            print('Salio el siguiente error: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Para calificar necesitas reservar'),
              ),
            );
          }
        },
        child: Icon(Icons.star),
        tooltip: 'Calificar reserva',
      ),
    );
  }
}
