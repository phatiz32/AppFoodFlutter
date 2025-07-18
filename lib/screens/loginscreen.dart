import 'package:flutter/material.dart';
import 'package:foodapp/models/logindto.dart';
import 'package:foodapp/services/loginservice.dart';
import 'package:foodapp/services/securestorageservice.dart';

import 'forgotpasswordscreen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading=false;
  void _login() async{
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final dto =LoginDto(
        username: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text.trim()
    );
    try{
      final result= await LoginService().loginUser(dto);
      final token=result['token'];
      await SecureStorageService().saveToken(token);
      if(context.mounted){
        Navigator.pop(context, true);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thành công. Token: ${result['token']}")),
      );
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }finally{
      setState(() => _isLoading = false);
    }
  }
  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameCtrl,
                decoration: InputDecoration(labelText: "Tên đăng nhập (email)"),
                validator: (value) => value!.isEmpty ? 'Nhập tên đăng nhập' : null,
              ),
              TextFormField(
                controller: _passwordCtrl,
                decoration: InputDecoration(labelText: "Mật khẩu"),
                obscureText: true,
                validator: (value) => value!.length < 8 ? 'Mật khẩu ít nhất 8 ký tự' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Đăng nhập"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPassWordScreen(),
                    ),
                  );
                },
                child: const Text("Quên mật khẩu?"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
