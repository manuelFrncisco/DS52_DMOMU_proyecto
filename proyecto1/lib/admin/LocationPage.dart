import 'package:flutter/material.dart';

class MyLocationPage extends StatefulWidget {
  const MyLocationPage({super.key, required this.title});
  final String title;

  @override
  State<MyLocationPage> createState() => _MyLocationPageState();
}

class _MyLocationPageState extends State<MyLocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(25),
                  padding: EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(224, 243, 227, 192),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(children: [
                    Image.asset(
                      'hotel.jpg',
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                      child: Row(
                        children: [
                          Icon(Icons.star),
                          Icon(Icons.star),
                          Icon(Icons.star),
                          Icon(Icons.star),
                          Icon(Icons.star)
                        ],
                      ),
                    ),
                    Container(
                      decoration: new BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      child: const Row(
                        children: [
                          Text(
                            '200,00',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: AutofillHints.countryName,
                                fontSize: 20,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: RichText(
                        text: const TextSpan(
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: AutofillHints.countryName,
                                fontSize: 20,
                                fontWeight: FontWeight.w100),
                            text:
                                'Avenida veracuz y Calle General Piña esquina, San Benito, 83190 Hermosillo, Son.'),
                      ),
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: const Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 0),
                                child: Text(
                                  'Hotel San Benito',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 137, 139),
                                      fontFamily: AutofillHints.countryName,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w100),
                                )),
                          ],
                        )),
                  ]),
                )
              ],
            ),
          ],
        ));
  }
}
