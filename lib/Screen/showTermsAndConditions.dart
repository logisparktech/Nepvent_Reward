import 'package:flutter/material.dart';

void showTermsAndConditions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,  // Allows control over the height
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 600,  // Custom height for the bottom sheet
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color:Color(0xFFDD143D), size: 30),
                    onPressed: () {
                      Navigator.pop(context);  // Close the bottom sheet
                    },
                  ),
                ),
                // Title
                Center(
                  child: Text(
                    'Terms and Conditions',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDD143D),  // Title color
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Application Use Section
                _buildSectionTitle('Application Use'),
                _buildSectionContent(
                  'The primary purpose of this application is for e-commerce and loyalty programs. '
                      'There are usage restrictions, including a minimum age of 18 years old and geographical limitations in certain countries.',
                ),
                SizedBox(height: 16),
                // User Responsibilities Section
                _buildSectionTitle('User Responsibilities'),
                _buildSectionContent(
                  'Users must provide accurate information and refrain from engaging in harmful or illegal activities. '
                      'Users are also expected to respect the rights of others while using the application.',
                ),
                SizedBox(height: 16),
                // Prohibited Activities Section
                _buildSectionTitle('Prohibited Activities'),
                _buildSectionContent(
                  'Users must not share malicious content, spam, or misuse the application in any way. Any form of fraud, '
                      'harassment, or illegal activities is strictly prohibited.',
                ),
                SizedBox(height: 16),
                // Payments and Refunds Section
                _buildSectionTitle('Payments and Refunds'),
                _buildSectionContent(
                  'The application includes paid features or services. Refunds are provided only under specific circumstances, '
                      'such as failure of service. Payment disputes will be resolved based on our refund policy.',
                ),
                SizedBox(height: 16),
                // Account Management Section
                _buildSectionTitle('Account Management'),
                _buildSectionContent(
                  'Users are required to create an account to use certain features. Accounts may be suspended or terminated '
                      'if a user violates the terms of service or engages in prohibited activities.',
                ),
                SizedBox(height: 16),
                // Liability and Warranties Section
                _buildSectionTitle('Liability and Warranties'),
                _buildSectionContent(
                  'The app is not liable for data loss, service interruptions, or any damages resulting from the use of the app. '
                      'We do not provide warranties regarding uninterrupted or error-free service.',
                ),
                SizedBox(height: 16),
                // Dispute Resolution Section
                _buildSectionTitle('Dispute Resolution'),
                _buildSectionContent(
                  'Any disputes between users and the app will be resolved through arbitration in the jurisdiction of our headquarters.',
                ),
              ],
            ),
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
      color: Colors.black87,  // Section title color
    ),
  );
}

Widget _buildSectionContent(String content) {
  return Text(
    content,
    style: TextStyle(
      fontSize: 14,
      color: Colors.black87,  // Content text color
      height: 1.5,  // Line height for better readability
    ),
  );
}
