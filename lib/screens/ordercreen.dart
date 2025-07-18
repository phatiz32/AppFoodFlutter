import 'package:flutter/material.dart';
import 'package:foodapp/models/orderinfodto.dart';
import 'package:foodapp/services/orderservice.dart';

class Ordercreen extends StatefulWidget {
  const Ordercreen({super.key});

  @override
  State<Ordercreen> createState() => _OrdercreenState();
}

class _OrdercreenState extends State<Ordercreen> {
  late Future<List<OrderInfoDto>> _ordersFuture;
  int _currentPage = 1;
  final int _pageSize = 5;
  void _nextPage() {
    setState(() {
      _currentPage++;
    });
    loadOrder();
  }
  void _prevPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      loadOrder();
    }
  }
  void loadOrder(){
    _ordersFuture=OrderService().getUserOrder(page: _currentPage,size:_pageSize);
  }
  @override
  void initState(){
    super.initState();
    loadOrder();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lịch sử đơn hàng")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<OrderInfoDto>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Lỗi: ${snapshot.error}"));
                }
                final orders = snapshot.data!;
                if (orders.isEmpty) {
                  return const Center(child: Text("Chưa có đơn hàng nào."));
                }
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return ListTile(
                      title: Text("Ngày: ${order.createdAt.toLocal().toString()}"),
                      subtitle: Text("Tổng: ${order.totalAmount} VNĐ\nTrạng thái: ${order.paymentStatus}"),
                      isThreeLine: true,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 1 ? _prevPage : null,
                  child: const Text("Trang trước"),
                ),
                const SizedBox(width: 16),
                Text("Trang $_currentPage"),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _nextPage();
                  },
                  child: const Text("Trang sau"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
