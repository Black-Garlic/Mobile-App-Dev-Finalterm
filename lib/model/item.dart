class Item {
  const Item({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.image,
    required this.uid,
    required this.regDate,
    required this.modDate,
  });

  final String id;
  final String name;
  final String desc;
  final int price;
  final String image;
  final String uid;
  final DateTime regDate;
  final DateTime modDate;

}
