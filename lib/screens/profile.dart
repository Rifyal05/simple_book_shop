import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce/Authentication/auth_screen.dart';

import '../Providers/user_providers.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  Future<void> _showChangeUsernameDialog(
      BuildContext context, UserProvider user) async {
    TextEditingController controller =
        TextEditingController(text: user.username);
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ubah Nama Pengguna'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Masukkan nama baru',
                icon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                if (value.length < 3) {
                  return 'Nama minimal 3 karakter';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  user.changeUsername(controller.text.trim());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nama pengguna berhasil diperbarui!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah kamu yakin ingin keluar dari akun ini?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Logout',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (Route<dynamic> route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Anda telah logout.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, user, child) {
        String initials = user.username.isNotEmpty
            ? user.username
                .trim()
                .split(' ')
                .map((l) => l[0])
                .take(2)
                .join()
                .toUpperCase()
            : "U";

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Saya'),
            elevation: 1.0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.username,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'user.email@example.com',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      _buildProfileMenuItem(
                        context: context,
                        icon: Icons.person_outline,
                        title: 'Edit Profil',
                        subtitle: 'Ubah nama pengguna, foto, dll.',
                        onTap: () {
                          _showChangeUsernameDialog(context, user);
                        },
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _buildProfileMenuItem(
                        context: context,
                        icon: Icons.receipt_long_outlined,
                        title: 'Riwayat Pesanan',
                        subtitle: 'Lihat pesanan Anda sebelumnya',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Halaman Riwayat Pesanan belum ada')),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _buildProfileMenuItem(
                        context: context,
                        icon: Icons.settings_outlined,
                        title: 'Pengaturan',
                        subtitle: 'Notifikasi, privasi, tema',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Halaman Pengaturan belum ada')),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _buildProfileMenuItem(
                        context: context,
                        icon: Icons.help_outline,
                        title: 'Bantuan & Dukungan',
                        subtitle: 'FAQ, hubungi kami',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Halaman Bantuan belum ada')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: Icon(Icons.logout,
                        color: Theme.of(context).colorScheme.error),
                    title: Text(
                      'Logout',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    onTap: () {
                      _showLogoutConfirmationDialog(context);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Versi Aplikasi 1.0.0',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle, style: Theme.of(context).textTheme.bodySmall)
          : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
