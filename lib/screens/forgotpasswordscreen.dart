import 'package:flutter/material.dart';
import 'package:foodapp/models/forgotpassworddto.dart';
import 'package:foodapp/screens/resetpasswordscreen.dart';
import 'package:foodapp/services/accountservice.dart';
class ForgotPassWordScreen extends StatefulWidget {
  const ForgotPassWordScreen({super.key});

  @override
  State<ForgotPassWordScreen> createState() => _ForgotPassWordScreenState();
}

class _ForgotPassWordScreenState extends State<ForgotPassWordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  void _submit() async{
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final dto=ForgotPasswordDto(email: _emailCtrl.text.trim());
    try{
      await AccountService().sendForgotPasswordEmail(dto);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(" Đã gửi email đặt lại mật khẩu")),
      );
      Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quên mật khẩu")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                value!.contains('@') ? null : "Email không hợp lệ",
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Gửi email"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
