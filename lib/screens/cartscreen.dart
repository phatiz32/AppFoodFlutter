import 'package:flutter/material.dart';
import 'package:foodapp/models/cartitemdto.dart';
import 'package:foodapp/models/createorderdto.dart';
import 'package:foodapp/models/selectedcartitemdto.dart';
import 'package:foodapp/models/updatecartitemdto.dart';
import 'package:foodapp/services/cartservice.dart';
import 'package:foodapp/services/securestorageservice.dart';
import 'package:url_launcher/url_launcher.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItemDto> _items=[];
  bool _isLoading=true;
  double _selectedTotal=0;
  @override
  void initState() {
    super.initState();
    _loadCart();
  }
  Future<void> _loadCart() async{
    final token= await SecureStorageService().getToken();
    if(token==null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập để xem giỏ hàng')),
      );
      setState(() => _isLoading = false);
      return;
    }
    try{
      final items= await CartService().getCartItems(token);
      setState(() {
        _items=items;
        _isLoading=false;
      });
      await _loadTotal();
    }catch(e){
      print('Lỗi lấy giỏ hàng: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
      setState(() => _isLoading = false);
    }
  }
  Future<void> _updateQuantity(CartItemDto item, int newQuantity) async{
    if(newQuantity <1) return;
    final token= await SecureStorageService().getToken();
    if(token==null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để cập nhật giỏ hàng')),
      );
      return;
    }
    try{
      await CartService().updateQuantity(
          UpdateCartItemDto(
              cartItemId: item.cartItemId,
              quantity: newQuantity
          ),
          token,
      );
      setState(() {
        _isLoading=true;
      });
      await _loadCart();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi cập nhật: $e')),
      );
      setState(() {
        _isLoading=false;
      });
    }
  }
  Future<void> _loadTotal() async{
    final token= await SecureStorageService().getToken();
    if(token==null) return;
    try{
      final totalDto= await CartService().getCartTotal(token);
      setState(() {
        _selectedTotal=totalDto.total;
      });
    }catch(e){
      print("Lỗi lấy tổng tiền đã chọn: $e");
    }
  }
  Future<void> _toggleSelect(CartItemDto item) async{
    final token= await SecureStorageService().getToken();
    if(token==null) return;
    try{
      await CartService().selectCartItem(
        SelectedCartItemDto(
            cartItemIds:[item.cartItemId] ,
            isSelected:!item.isSelected ),
           token
      );
      await _loadCart();
      await _loadTotal();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi chọn món: $e")),
      );
    }
  }
  Future<void> _showAddressDialog() async{
    final addressController=TextEditingController();
    await showDialog(
        context: context,
        builder:(context)=>AlertDialog(
          title: const Text('Nhập địa chỉ giao hàng'),
          content: TextField(
            controller: addressController,
            decoration: const InputDecoration(hintText: 'VD: 123 đường ABC, Quận 1'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // đóng dialog
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _handleMomoPayment(addressController.text);
              },
              child: const Text('Xác nhận'),
            ),
          ],
        )
    );

  }
  Future<void> _handleMomoPayment(String address) async {
    final token= await SecureStorageService().getToken();
    if(token==null) return;
    try{
      final paymentUrl=await CartService().createMomoOrder(
          CreateOrderDto(shippingAddress: address),
          token
      );
      if(await canLaunchUrl(Uri.parse(paymentUrl))){
        await launchUrl(Uri.parse(paymentUrl), mode: LaunchMode.externalApplication);
      }else{
        throw Exception('Không thể mở liên kết');
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tạo thanh toán: $e')),
      );
    }
  }
  Future<void> _removeItem(CartItemDto item) async {
    final token = await SecureStorageService().getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chưa đăng nhập')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa món này khỏi giỏ hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await CartService().deleteCartItems(item.cartItemId, token);
        setState(() {
          _items.removeWhere((e) => e.cartItemId == item.cartItemId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa món khỏi giỏ hàng')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa món: $e')),
        );
      }
    }
  }

  Widget _buildCartItem(CartItemDto item){
    final imageUrl='http://10.0.2.2:5001/uploads/${item.imageUrl}';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Image.network(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image),
        ),
        title: Text(item.name),
        subtitle: Row(
          children: [
            IconButton(
                icon: Icon(Icons.remove,size: 18),
              onPressed:()=>_updateQuantity(item, item.quantity-1),

            ),
            Text('${item.quantity}'),
            IconButton(
              icon: const Icon(Icons.add, size: 18),
              onPressed: () => _updateQuantity(item, item.quantity + 1),
            ),
            const Spacer(),
            Text('${item.price * item.quantity}đ'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                item.isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: item.isSelected ? Colors.green : Colors.grey,
              ),
              onPressed: () => _toggleSelect(item),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeItem(item),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Xóa tất cả',
            onPressed: () async {
              final token = await SecureStorageService().getToken();
              if (token == null) return;
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Xác nhận'),
                  content: const Text('Bạn có chắc muốn xóa tất cả món trong giỏ?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
                  ],
                ),
              );
              if (confirm == true) {
                try {
                  await CartService().clearCart(token);
                  setState(() {
                    _items.clear();
                    _selectedTotal = 0;
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi xóa tất cả: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _items.isEmpty
            ? const Center(child: Text('Giỏ hàng trống'))
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) =>
                    _buildCartItem(_items[index]),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng đã chọn:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_selectedTotal.toStringAsFixed(0)} đ',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _selectedTotal > 0 ? _showAddressDialog : null,
                    child: const Text('Thanh toán MoMo'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
