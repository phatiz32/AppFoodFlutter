import 'package:flutter/material.dart';
import 'package:foodapp/models/updateuserdto.dart';
import 'package:foodapp/models/userdto.dart';
import 'package:foodapp/services/userservice.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = await UserService().getMyInfo();
    if (user != null) {
      _usernameController.text = user.userName;
      _fullNameController.text = user.fullName ?? '';
      _emailController.text = user.email ?? '';
      _phoneNumberController.text = user.phoneNumber ?? '';
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final dto = UpdateUserDto(
      fullName: _fullNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneNumberController.text,
    );

    try {
      await UserService().UpdateMyInfo(dto);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin cá nhân')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
                readOnly: true,
              ),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Họ tên'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Lưu thay đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
