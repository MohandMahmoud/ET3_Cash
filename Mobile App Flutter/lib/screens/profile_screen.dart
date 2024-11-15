import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to Edit Profile screen
              Navigator.pushNamed(context, '/edit_profile');
            },
          ),
          ClipOval(
            child: Image.asset(
              'assets/images/1724928422745.jpeg',
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Circle avatar for user image
              _buildUserAvatar(),
              const SizedBox(height: 20),
              // User Name
              const Text(
                'Mohand Mahmoud',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              // Phone Number
              _buildContactRow(Icons.phone, '+20 1124762559'), // Replace with actual phone number
              const SizedBox(height: 30),
              // User details section
              _buildProfileDetail(context, 'Email', 'mohand@gmail.com'),
              _buildProfileDetail(context, 'Location', 'Cairo, Egypt'),
              _buildProfileDetail(context, 'Account Type', 'Premium'),
              const SizedBox(height: 30),
              // Action buttons
              _buildActionButtons(context),
              const SizedBox(height: 30),
              // Log out button
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // User avatar builder
  Widget _buildUserAvatar() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            child: ClipOval(
              child: Image.asset(
                'assets/images/FB_IMG_1698781339946.jpg', // Ensure the image path is correct
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.blueAccent),
            onPressed: () {
              // Implement image change logic
            },
          ),
        ],
      ),
    );
  }

  // Contact row builder
  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blueAccent, size: 18),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // Profile detail builder
  Widget _buildProfileDetail(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Action buttons builder
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(context, 'Change Password', Icons.lock, '/change_password'),
        _buildActionButton(context, 'MY History', Icons.history, '/clear_transactions'),
      ],
    );
  }

  // Action button builder
  Widget _buildActionButton(BuildContext context, String label, IconData icon, String route) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Logout button builder
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          // Log out logic here
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        },
        child: const Text(
          'Logout',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
