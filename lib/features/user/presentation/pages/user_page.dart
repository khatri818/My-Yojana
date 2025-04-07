import 'package:flutter/material.dart';
import 'package:my_yojana/core/enum/status.dart';
import 'package:provider/provider.dart';
import '../../../../common/app_colors.dart';
import '../../../../core/constant/app_styles.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../../core/utils/app_utils.dart';
import '../manager/user_manager.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<UserManager>(
        builder: (context, manager, child) {
          if (manager.userLoadingStatus == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = manager.user;
          if (manager.userLoadingStatus.failure || user == null) {
            return const Center(child: Text("Something went wrong!"));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.orange,
                              child: Text(
                                AppUtils.getInitials(user.name ?? ''),
                                style: AppTextStyle.title2.copyWith(
                                  color: AppColors.white,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   // MaterialPageRoute(
                                  //   //  // builder: (_) => const EditProfilePage(),
                                  //   // ),
                                  // );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.backgroundColor,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.name ?? '-',
                          style: AppTextStyle.title2.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildProfileCard('Date of Birth', user.dob),
                  _buildProfileCard('Gender', user.gender),
                  _buildProfileCard('Marital Status', user.maritalStatus),
                  _buildProfileCard('Education Level', user.educationLevel),
                  _buildProfileCard('Occupation', user.occupation),
                  _buildProfileCard('City', user.city),
                  _buildProfileCard('Residence Type', user.residenceType),
                  _buildProfileCard('Income', user.income?.toString()),
                  _buildProfileSwitch('Minority', user.minority ?? false),
                  _buildProfileSwitch('Differently Abled', user.differentlyAbled ?? false),
                  _buildProfileCard(
                    'Disability %',
                    user.disabilityPercentage != null
                        ? '${user.disabilityPercentage}%'
                        : null,
                  ),
                  _buildProfileSwitch('BPL Category', user.bplCategory ?? false)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(String label, String? value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: AppTextStyle.text.copyWith(fontWeight: FontWeight.w600)),
            ),
            Text(value ?? '-', style: AppTextStyle.text),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSwitch(String label, bool value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: AppTextStyle.text.copyWith(fontWeight: FontWeight.w600))),
            IgnorePointer(
              ignoring: true,
              child: Switch(
                value: value,
                onChanged: (_) {},
                activeColor: AppColors.backgroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
