import 'package:flutter/material.dart';
import 'formpage.dart';

class merch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: const Text('Buy Merchandise'),
      ),
      body: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          contain("Front",
              'https://firebasestorage.googleapis.com/v0/b/ecommerce-eb54d.appspot.com/o/payment_screenshots%2Fimage-removebg-preview%20(9).png?alt=media&token=c1affa18-fba1-430e-bb9b-cf0e0c168c55'),
          contain("Back",
              'https://firebasestorage.googleapis.com/v0/b/ecommerce-eb54d.appspot.com/o/payment_screenshots%2Fimage-removebg-preview%20(8).png?alt=media&token=dcf61c5e-6d24-4720-959a-3751b61ab201'),
          InkWell(
            onTap: () {
              // Navigate to FS3 page when the container is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FS3()),
              );
            },
            child: Container(
              width: 250,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade400,
                borderRadius: BorderRadius.circular(16), // Curved corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "Buy now at : 449",
                  style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget contain(String t, String img) {
    return Container(
      width: 200,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Curved corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Product image
          //SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 182,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  img,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          // Price at the bottom
          Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16))),
            child: Center(
              child: Text(
                t,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
