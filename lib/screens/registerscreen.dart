// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import '../models/registerdto.dart';
import '../services/registeruser.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _isLoading = false;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final dto = RegisterDto(
      fullname: _fullnameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phonenumber: _phoneCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
    final service = RegisterUser();
    try {
      final result = await service.registerUser(dto);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng ký thành công"))
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }
    finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _fullnameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng ký")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullnameCtrl,
                decoration: InputDecoration(labelText: "Họ tên"),
                validator: (value) => value!.isEmpty ? 'Nhập họ tên' : null,
              ),
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => !value!.contains('@') ? 'Email không hợp lệ' : null,
              ),
              TextFormField(
                controller: _phoneCtrl,
                decoration: InputDecoration(labelText: "Số điện thoại"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.length < 10 ? 'Số điện thoại không hợp lệ' : null,
              ),
              TextFormField(
                controller: _passwordCtrl,
                decoration: InputDecoration(labelText: "Mật khẩu"),
                obscureText: true,
                validator: (value) => value!.length < 8? 'Tối thiểu 8 ký tự' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Đăng ký"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
