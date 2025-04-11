import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../user/presentation/manager/user_manager.dart';
import '../../../../core/model/form/user_session.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _confirmDeleteUser(BuildContext context, String firebaseId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to delete your account? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final result = await context.read<UserManager>().deleteUser(firebaseId);
              if (result) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Failed to delete user. Please try again."),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userSession = ModalRoute.of(context)?.settings.arguments as UserSession?;
    final firebaseId = userSession?.token ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Account Settings"),
            const SizedBox(height: 16),
            ListTile(
              tileColor: Colors.grey.withOpacity(0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
              title: const Text("Delete Account", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              subtitle: const Text("This will permanently delete your account."),
              onTap: () => _confirmDeleteUser(context, firebaseId),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "App Version 1.0.0",
                style: AppTextStyle.text2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}