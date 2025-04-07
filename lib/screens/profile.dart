import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/user_providers.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nama Pengguna: ${user.username}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showChangeUsernameDialog(context, user);
              },
              child: const Text('Ubah Nama Pengguna'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showChangeUsernameDialog(
      BuildContext context, UserProvider user) async {
    TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ubah Nama Pengguna'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Masukkan nama baru'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                user.changeUsername(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
