import 'package:flutter/material.dart';

void showPrivacyPolicy(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white, // Background color for the bottom sheet
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0)), // Rounded corners at the top
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Color(0xFFDD143D),
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
              ),
              // Title
              Center(
                child: Text(
                  'Privacy Policy',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDD143D), // Title color
                      ),
                ),
              ),

              SizedBox(height: 16),
              // Data Collection Section
              _buildSectionTitle('Data Collection'),
              _buildSectionContent(
                'We collect personal information, location data, and analytics data to improve the user experience.',
              ),
              SizedBox(height: 16),
              // Data Usage Section
              _buildSectionTitle('Data Usage'),
              _buildSectionContent(
                'This data is used to personalize content and improve app performance. We do not share this data with third parties.',
              ),
              SizedBox(height: 16),
              // Data Storage & Security Section
              _buildSectionTitle('Data Storage & Security'),
              _buildSectionContent(
                'We store data securely using encryption and comply with GDPR standards.',
              ),
              SizedBox(height: 16),
              // User Rights Section
              _buildSectionTitle('User Rights'),
              _buildSectionContent(
                'You can access, update, or delete your data. You may also opt out of analytics or personalized ads.',
              ),
              SizedBox(height: 16),
              // Third-Party Services Section
              _buildSectionTitle('Third-Party Services'),
              _buildSectionContent(
                'We use Google Analytics for performance tracking and payment gateways for transactions.',
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87, // Section title color
    ),
  );
}

Widget _buildSectionContent(String content) {
  return Text(
    content,
    style: TextStyle(
      fontSize: 14,
      color: Colors.black87, // Content text color
      height: 1.5, // Line height for better readability
    ),
  );
}
