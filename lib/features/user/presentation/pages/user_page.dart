import 'package:flutter/material.dart';
import 'package:my_yojana/core/enum/status.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/app_utils.dart';
import '../manager/user_manager.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<UserManager>(
        builder: (context, manager, child) {
          if (manager.userLoadingStatus == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = manager.user;
          if (manager.userLoadingStatus.failure || user == null) {
            return const Center(child: Text("Something went wrong!"));
          }

          return SafeArea(
            top: false,
            child: Column(
              children: [
                // Header with image and curved corners
                Container(
                  padding: EdgeInsets.only(top: topPadding + 10),
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile_background.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.white,
                              child: Text(
                                AppUtils.getInitials(user.name ?? ''),
                                style: const TextStyle(
                                  color: Color(0xFF3A5AFE),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              user.name ?? '-',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // User Information Sections
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 16, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Personal Information"),
                        _buildInfoRow(Icons.cake, 'Date of Birth', user.dob),
                        _buildInfoRow(Icons.wc, 'Gender', user.gender),
                        _buildInfoRow(Icons.favorite, 'Marital Status', user.maritalStatus),
                        _buildInfoRow(Icons.school, 'Education Level', user.educationLevel),
                        _buildInfoRow(Icons.work, 'Occupation', user.occupation),

                        const Divider(height: 30, thickness: 1),

                        _buildSectionTitle("Location & Housing"),
                        _buildInfoRow(Icons.location_city, 'City', user.city),
                        _buildInfoRow(Icons.home, 'Residence Type', user.residenceType),

                        const Divider(height: 30, thickness: 1),

                        _buildSectionTitle("Financial & Social Info"),
                        _buildInfoRow(Icons.currency_rupee, 'Income', user.income?.toString()),
                        _buildInfoRow(
                          Icons.percent,
                          'Disability %',
                          user.disabilityPercentage != null ? '${user.disabilityPercentage}%' : null,
                        ),
                        _buildInfoRow(Icons.category, 'Minority', user.minority == true ? 'Yes' : 'No'),
                        _buildInfoRow(Icons.accessibility_new, 'Differently Abled',
                            user.differentlyAbled == true ? 'Yes' : 'No'),
                        _buildInfoRow(Icons.family_restroom, 'BPL Category',
                            user.bplCategory == true ? 'Yes' : 'No'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  data ?? '-',
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
