import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodapp/models/tofooditemdto.dart';
import 'package:foodapp/screens/fooddetailscreen.dart';
import 'package:foodapp/screens/ordercreen.dart';
import 'package:foodapp/screens/userprofilescreen.dart';
import 'package:foodapp/services/foodservices.dart';
import 'package:foodapp/services/securestorageservice.dart';

import '../models/addtocartdto.dart';
import '../services/cartservice.dart';
import 'cartscreen.dart';
import 'loginscreen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ToFoodItemDto> _foods=[];
  bool _isLoading=true;
  int _currentPage = 1;
  final int _pageSize = 5;
  String? _username;
  Future<void> _checkLogin() async{
    final token= await SecureStorageService().getToken();
    if(token!=null&& token.isNotEmpty){
      final parts=token.split('.');
      if(parts.length==3){
        final payload=utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
        final payloadMap=jsonDecode(payload);
        setState(() {
          _username=payloadMap['email']??'Người dùng';
        });
      }
    }
  }
  void _goToLogin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
    if (result == true) {
      _checkLogin(); // Cập nhật lại username sau khi đăng nhập
    }
  }
  void _nextPage() {
    setState(() {
      _currentPage++;
    });
    _fetchFood();
  }

  void _prevPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchFood();
    }
  }
  Future<void> _logout() async{
    SecureStorageService().deleteToken();
    setState(() {
      _username=null;
    });
    await _fetchFood();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã đăng xuất')),
    );
  }
  @override
  void initState(){
    super.initState();
    _fetchFood();
    _checkLogin();
  }
  Future<void> _fetchFood() async{
    try{
      final foods=await FoodService().getAllFoods(page: _currentPage,size: _pageSize);
      setState(() {
        _foods=foods;
        _isLoading=false;

      });
    }catch(e){
      print('Lỗi khi gọi API: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  Widget _buildFoodItem(ToFoodItemDto food) {
    final imageUrl = FoodService().getFullImageUrl(food.imageUrl);

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Image.network(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image),
        ),
        title: Text(food.name),
        subtitle: Text('${food.description}\n${food.price}đ - ${food.categoryName}'),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () async {
            final token = await SecureStorageService().getToken();
            if (token == null || token.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Vui lòng đăng nhập trước")),
              );
              return;
            }

            try {
              await CartService().addToCart(
                AddToCartDto(foodItemId: food.foodItemId, quantity: 1),
                token,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đã thêm vào giỏ hàng")),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Lỗi khi thêm vào giỏ: $e")),
              );
            }
          },
        ),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_)=>FoodDetailScreen(foodItemId: food.foodItemId)
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if(_username==null)
            TextButton(
              onPressed: _goToLogin,
              child: const Text("Đăng nhập", style: TextStyle(color: Colors.black)),
            )
          else...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text('👤 $_username', style: const TextStyle(color: Colors.black)),
              ),
            ),
            IconButton(
                onPressed: _logout,
                icon: Icon(Icons.logout),
              tooltip: 'Đăng xuất',
              color: Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.receipt_long),
              tooltip: 'Lịch sử đơn hàng',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Ordercreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                );
              },
            ),
          ]
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _foods.length,
              itemBuilder: (context, index) =>
                  _buildFoodItem(_foods[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 1 ? _prevPage : null,
                  child: const Text('⬅ Trước'),
                ),
                const SizedBox(width: 16),
                Text('Trang $_currentPage'),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _foods.length == _pageSize ? _nextPage : null,
                  child: const Text('Tiếp ➡'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
