import 'package:flutter/material.dart';
import 'package:map_app/map_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200,
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Placeholder(
                        fallbackHeight: 150,
                        fallbackWidth: 150,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          const Text(
                            'Burj Khalifa',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Expanded(
                            child: Text(
                                'The Burj Khalifa, known as the Burj Dubai prior to its inauguration in 2010, is a skyscraper in Dubai, United Arab Emirates.'),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                MapUtils.openMap(25.197525, 55.274288);
                              },
                              child: const Text('view Direction'))
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200,
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Placeholder(
                        fallbackHeight: 150,
                        fallbackWidth: 150,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          const Text(
                            'Dubai International Stadium',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Expanded(
                            child: Text(
                              'The Dubai International Stadium, formerly known as the Dubai Sports City Cricket Stadium, is a multi-purpose stadium in Dubai, United Arab Emirates. It is mainly used for cricket and is one of three stadiums in the country, the other two being Sharjah Cricket Stadium and Zayed Cricket Stadium in Abu Dhabi.',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                MapUtils.openMap(25.0460, 55.2184);
                              },
                              child: const Text('view Direction'))
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
