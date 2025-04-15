import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  // Function to open the phone dialer
  _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not make a phone call to $phoneNumber';
    }
  }

  // Function to send an email
  _sendEmail(String email) async {
    final Uri _url = Uri(scheme: 'mailto', path: email);
    if (await canLaunch(_url.toString())) {
      await launch(_url.toString());
    } else {
      throw 'Could not send an email to $email';
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Color(0xFF2575FC)),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image above buttons
              Image.asset('assets/images/bannerLogo.png'),

              const SizedBox(height: 50),
              // Icons and buttons (Call Us, Email Us) in white containers
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildContactButton(
                      Icons.call,
                      "Call Us",
                      Colors.orange,
                          () => _makePhoneCall('9152262781'),
                    ),
                    _buildContactButton(
                      Icons.email,
                      "Email Us",
                      Colors.green,
                          () => _sendEmail('mohammedhkaradia@gmail.com'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Quick Contact Form with no side padding and white background
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // Adjusted padding
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Quick Contact",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField("Name", "Enter Full Name Here", true),
                        _buildTextField("Email", "Enter Email Address", true),
                        _buildTextField("Message", "Enter Message", true, maxLines: 4),
                        const SizedBox(height: 16),
                        // Send Button in the center
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Handle the send action
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Form Submitted')),
                                );
                              }
                            },
                            icon: const Icon(Icons.arrow_forward, color: Colors.white),
                            label: const Text(
                              "Send",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              minimumSize: const Size(120, 50), // Smaller width for button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create contact buttons inside white containers with icons
  Widget _buildContactButton(IconData icon, String label, Color color, Function() onPressed) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color,
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create text fields for the contact form
  Widget _buildTextField(String label, String hint, bool isRequired, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          labelStyle: const TextStyle(color: Colors.black),
        ),
        style: const TextStyle(color: Colors.black),
        validator: isRequired
            ? (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        }
            : null,
      ),
    );
  }
}
