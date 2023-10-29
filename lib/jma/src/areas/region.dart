class Region {
  final String id;
  final String name;
  const Region(this.id, this.name);
  static List<Region> get all => _regions;
  static Region getById(id) =>
      _regions.singleWhere((element) => element.id == id);
}

const List<Region> _regions = [
  Region('010100', '北海道地方'),
  Region('010200', '東北地方'),
  Region('010300', '関東甲信地方'),
  Region('010500', '北陸地方'),
  Region('010400', '東海地方'),
  Region('010600', '近畿地方'),
  Region('010700', '中国地方'),
  Region('010900', '九州北部'),
  Region('010800', '四国地方'),
  Region('011000', '九州南部'),
  Region('011100', '沖縄地方'),
];
