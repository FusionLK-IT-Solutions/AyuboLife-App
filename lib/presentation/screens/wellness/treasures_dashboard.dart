import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TreasuresDashboard extends StatelessWidget {
  final List<int> collectedTreasures;
  final Map<int, Map<String, dynamic>> treasures;

  const TreasuresDashboard({
    Key? key,
    required this.collectedTreasures,
    required this.treasures,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treasures & Gifts'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.blue[100]!],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Collected Treasures',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: treasures.length,
                  itemBuilder: (context, index) {
                    final steps = treasures.keys.elementAt(index);
                    final treasure = treasures[steps]!;
                    final isCollected = collectedTreasures.contains(steps);

                    return Card(
                      color: isCollected ? Colors.green[50] : Colors.grey[200],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isCollected ? Icons.check_circle : Icons.lock,
                              color: isCollected ? Colors.green : Colors.grey,
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              treasure['gift'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Text(
                              isCollected
                                  ? treasure['description']
                                  : '$steps steps required',
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Text(
                              isCollected ? 'Collected!' : 'Locked',
                              style: TextStyle(
                                color: isCollected ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}