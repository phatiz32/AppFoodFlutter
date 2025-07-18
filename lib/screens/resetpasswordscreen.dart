import 'package:flutter/material.dart';
import 'package:foodapp/screens/loginscreen.dart';

import '../models/resetpasswordto.dart';
import '../services/accountservice.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  void _reset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final dto = ResetPasswordDto(
      email: _emailCtrl.text.trim(),
      token: _tokenCtrl.text.trim(),
      newPassword: _passwordCtrl.text,
    );

    try {
      await AccountService().resetPassword(dto);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đặt lại mật khẩu thành công")),
      );
      Navigator.pop(
          context,
        MaterialPageRoute(builder: (context)=>const LoginScreen())
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đặt lại mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                value!.contains('@') ? null : "Email không hợp lệ",
              ),
              TextFormField(
                controller: _tokenCtrl,
                decoration: const InputDecoration(labelText: "Token"),
                validator: (value) =>
                value!.isEmpty ? "Vui lòng nhập token" : null,
              ),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mật khẩu mới"),
                validator: (value) =>
                value!.length < 6 ? "Tối thiểu 6 ký tự" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _reset,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Đặt lại mật khẩu"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
