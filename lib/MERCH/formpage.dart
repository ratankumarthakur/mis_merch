import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FS3 extends StatefulWidget {
  @override
  _FS3State createState() => _FS3State();
}

class _FS3State extends State<FS3> {
  final _formKey = GlobalKey<FormState>();

  // Variables to hold form values
  bool hide_submit_button = false;
  String name = '';
  String tShirtSize = 'L';
  String quantity = '1'; // Default value for dropdown
  File? paymentScreenshot; // Variable to hold the uploaded screenshot
  bool isUploading = false; // Variable to show upload progress

  // List of T-shirt sizes (for radio buttons)
  List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  // List of quantities (for dropdown)
  List<String> quantities = ['1', '2', '3', '4', '5'];

  // Image picker instance
  final ImagePicker _picker = ImagePicker();
  late String downloadURL = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text('Fill the Form'),
        backgroundColor: Colors.blue.shade200,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Name input field
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Enter the name you want on your merch'),
                  onSaved: (value) {
                    name = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                // T-shirt size multiple choice (Radio Buttons)
                SizedBox(height: 20),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'T-shirt Size',
                      style: TextStyle(fontSize: 20),
                    )),
                Column(
                  children: sizes.map((size) {
                    return RadioListTile(
                      title: Text(size),
                      value: size,
                      groupValue: tShirtSize,
                      onChanged: (value) {
                        setState(() {
                          tShirtSize = value!;
                        });
                      },
                    );
                  }).toList(),
                ),

                // Quantity Dropdown
                SizedBox(height: 20),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Quantity',
                      style: TextStyle(fontSize: 20),
                    )),
                SizedBox(
                  height: 5,
                ),
                DropdownButtonFormField(
                  value: quantity,
                  decoration: InputDecoration(labelText: 'Select Quantity'),
                  onChanged: (value) {
                    setState(() {
                      quantity = value!;
                    });
                  },
                  items: quantities.map((qty) {
                    return DropdownMenuItem(
                      value: qty,
                      child: Text(qty),
                    );
                  }).toList(),
                ),

                // Display QR Code for Payment
                SizedBox(height: 20),
                Text(
                  'Scan to make payment',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 5,
                ),
                Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/ecommerce-eb54d.appspot.com/o/payment_screenshots%2FScreenshot%202025-02-21%20213944.png?alt=media&token=dd86ef49-3c4a-403b-9a66-9bd17567d804',
                  height: 200,
                ),

                // Upload Screenshot Button
                SizedBox(height: 20),
                Text('Upload Payment Screenshot'),
                SizedBox(
                  height: 10,
                ),
                paymentScreenshot == null
                    ? ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Upload Screenshot'),
                      )
                    : Column(
                        children: [
                          Image.file(paymentScreenshot!,
                              height:
                                  200), // Show the uploaded screenshot if selected
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: Text(
                                'Change Screenshot'), // Change button label
                          ),
                        ],
                      ),

                SizedBox(
                  height: 20,
                ),

                // Show upload progress indicator
                //isUploading ? CircularProgressIndicator() : Text(''),

                SizedBox(height: 20),

                InkWell(
                  onTap: () {
                    //hide_submit_button=true;
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (paymentScreenshot != null) {
                        _uploadImageToFirebase(
                            name, tShirtSize, quantity, paymentScreenshot!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Please upload a payment screenshot')),
                        );
                      }
                    }
                  },
                  child: isUploading
                      ? CircularProgressIndicator()
                      : Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade200,
                              borderRadius: BorderRadius.circular(16)),
                          child: Center(child: Text('Submit'))),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Image Picker function
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        paymentScreenshot = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  // Upload image to Firebase and get the URL
  Future<void> _uploadImageToFirebase(
      String name, String tShirtSize, String quantity, File screenshot) async {
    setState(() {
      isUploading = true;
    });

    // Create a unique filename
    String fileName =
        'payment_screenshots/${DateTime.now().millisecondsSinceEpoch}.png';

    try {
      // Upload the image to Firebase Storage
      await FirebaseStorage.instance.ref(fileName).putFile(screenshot);

      // Get the download URL for the uploaded image
      downloadURL =
          await FirebaseStorage.instance.ref(fileName).getDownloadURL();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blue.shade200,
          content: Text('Screenshot uploaded successfully')));
      _submitToGoogleForm(name, tShirtSize, quantity, downloadURL);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to upload image')));
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  // Submit form data to Google Form
  Future<void> _submitToGoogleForm(
      String name, String tShirtSize, String quantity, String imageUrl) async {
    final String googleFormId = "1ZsebuYTlp_Qnvu_RruxvZFVEHpsnmlcmVwHafzBms4c";
    final String nameField = "entry.1827047945";
    final String sizeField = "entry.113003104";
    final String quantityField = "entry.705805320";
    final String screenshotField = "entry.1204853012";

    final Uri googleFormUrl = Uri.parse(
        'https://docs.google.com/forms/d/$googleFormId/formResponse?'
        '${Uri.encodeComponent(nameField)}=${Uri.encodeComponent(name)}&'
        '${Uri.encodeComponent(sizeField)}=${Uri.encodeComponent(tShirtSize)}&'
        '${Uri.encodeComponent(quantityField)}=${Uri.encodeComponent(quantity)}&'
        '${Uri.encodeComponent(screenshotField)}=${Uri.encodeComponent(imageUrl)}');

    try {
      await http.get(googleFormUrl);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blue.shade200,
          content: Text('Form submitted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text('Failed to submit form')));
    }
  }
}
