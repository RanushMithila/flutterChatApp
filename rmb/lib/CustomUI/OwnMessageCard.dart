import 'package:flutter/material.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({super.key, required this.message, required this.time});
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 1.0,
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          color: Colors.blue[100],
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  top: 5.0,
                  right: 60.0,
                  bottom: 20.0,
                ),
                child: Text(
                  message,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Positioned(
                bottom: 4.0,
                right: 10.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: TextStyle(fontSize: 13.0, color: Colors.black54),
                    ),
                    SizedBox(width: 5.0),
                    Icon(Icons.done_all, size: 20.0, color: Colors.black54),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
