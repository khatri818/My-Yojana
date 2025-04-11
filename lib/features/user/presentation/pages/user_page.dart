import 'package:flutter/material.dart';
import 'package:my_yojana/core/enum/status.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/app_utils.dart';
import '../manager/user_manager.dart';
import 'edit_profile_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
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
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/profile_background.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(28),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: topPadding + 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(28),
                            bottomRight: Radius.circular(28),
                          ),
                        ),
                        child: Align(
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
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3A5AFE),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                user.name ?? '-',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("Personal Information"),
                            _buildInfoCard([
                              _buildInfoRow(Icons.cake, 'Date of Birth', user.dob),
                              _buildInfoRow(Icons.wc, 'Gender', user.gender),
                              _buildInfoRow(Icons.favorite, 'Marital Status', user.maritalStatus),
                              _buildInfoRow(Icons.school, 'Education Level', user.educationLevel),
                              _buildInfoRow(Icons.work, 'Occupation', user.occupation),
                            ]),

                            _buildSectionTitle("Location & Housing"),
                            _buildInfoCard([
                              _buildInfoRow(Icons.location_city, 'City', user.city),
                              _buildInfoRow(Icons.home, 'Residence Type', user.residenceType),
                            ]),

                            _buildSectionTitle("Financial & Social Info"),
                            _buildInfoCard([
                              _buildSliderRow(context, user.disabilityPercentage),
                              _buildToggleTile(Icons.category, 'Minority', user.minority == true),
                              _buildToggleTile(Icons.accessibility_new, 'Differently Abled', user.differentlyAbled == true),
                              _buildToggleTile(Icons.family_restroom, 'BPL Category', user.bplCategory == true),
                              _buildInfoRow(Icons.currency_rupee, 'Annual Income', user.income?.toString()),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: topPadding + 10,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  top: 255,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF2575FC),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const EditProfilePage()),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1C1C1E),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> rows) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: rows,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2575FC), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data ?? '-',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow(BuildContext context, double? percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.percent, color: Color(0xFF2575FC), size: 22),
              SizedBox(width: 14),
              Text(
                'Disability Percentage',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF2575FC),
              inactiveTrackColor: Colors.grey[300],
              thumbShape: SliderComponentShape.noThumb,
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: (percentage ?? 0).toDouble(),
              min: 0,
              max: 100,
              onChanged: null,
            ),
          ),
          Text(
            '${percentage ?? 0}%',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2575FC), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}