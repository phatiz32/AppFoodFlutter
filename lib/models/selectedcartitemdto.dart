class SelectedCartItemDto{
  final List<int> cartItemIds;
  final bool isSelected;
  SelectedCartItemDto({required this.cartItemIds, required this.isSelected});
  Map<String, dynamic> toJson() => {
    'cartItemIds': cartItemIds,
    'isSelected': isSelected,
  };

}