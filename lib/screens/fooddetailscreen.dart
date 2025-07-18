import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodapp/models/createfoodreviewdto.dart';
import 'package:foodapp/models/foodreviewinfodto.dart';
import 'package:foodapp/services/foodreviewservice.dart';
import 'package:foodapp/services/securestorageservice.dart';
class FoodDetailScreen extends StatefulWidget {
  final int foodItemId;
  const FoodDetailScreen({super.key,required this.foodItemId});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final TextEditingController _commentController=TextEditingController();
  int _rating=5;
  List<FoodReviewInfoDto> _reviews=[];
  int _currentPage = 1;
  final int _pageSize = 5;
  @override
  void initState(){
    super.initState();
    _loadReviews();
  }
  void _nextPage() {
    setState(() {
      _currentPage++;
    });
    _loadReviews();
  }

  void _prevPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _loadReviews();
    }
  }
  Future<void> _loadReviews() async {
    try{
      final reviews=await FoodReviewService().getReviews(widget.foodItemId,page:_currentPage,size: _pageSize);
      setState(() {
        _reviews=reviews;
      });

    }catch(e){
      print('Lỗi khi tải đánh giá: $e');
    }
  }
  Future<void> _submitReview() async{
    final comment= _commentController.text.trim();
    try{
      final token= await SecureStorageService().getToken();
      if(token==null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bạn cần đăng nhập để đánh giá.")));
        return;
      }
      final dto= CreateFoodReviewDto(
        foodItemId: widget.foodItemId,
        comment: comment,
        rating:_rating,
      );
      await FoodReviewService().createReview(dto, token);
      _commentController.clear();
      setState(() {
        _rating = 5;
      });
      await _loadReviews();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không thể gửi đánh giá.")),
      );
    }

  }
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết món')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text('Đánh giá người dùng', style: TextStyle(fontSize: 18)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Chọn số sao:'),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nhập bình luận...',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _submitReview,
                  child: const Text('Gửi đánh giá'),
                ),
              ],
            ),
          ),
          const Divider(),
          const Text('Các đánh giá khác:', style: TextStyle(fontSize: 18)),
          Expanded(
            child: ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return ListTile(
                  title: Text('${review.userName} - ${review.rating}⭐'),
                  subtitle: Text(review.comment),
                );
              },
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
                  onPressed: _reviews.length == _pageSize ? _nextPage : null,
                  child: const Text('Tiếp ➡'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
