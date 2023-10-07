class Prefecture {
  final String id;
  final String name;
  final String region;
  Prefecture(this.id, this.name, this.region);
  static List<Prefecture> get all => _prefectures;
  static Prefecture getById(id) =>
      _prefectures.singleWhere((element) => element.id == id);
}

final List<Prefecture> _prefectures = [
  Prefecture('01', '北海道', '010100'),
  Prefecture('02', '青森県', '010200'),
  Prefecture('03', '岩手県', '010200'),
  Prefecture('04', '宮城県', '010200'),
  Prefecture('05', '秋田県', '010200'),
  Prefecture('06', '山形県', '010200'),
  Prefecture('07', '福島県', '010200'),
  Prefecture('08', '茨城県', '010300'),
  Prefecture('09', '栃木県', '010300'),
  Prefecture('10', '群馬県', '010300'),
  Prefecture('11', '埼玉県', '010300'),
  Prefecture('12', '千葉県', '010300'),
  Prefecture('13', '東京都', '010300'),
  Prefecture('14', '神奈川県', '010300'),
  Prefecture('15', '新潟県', '010500'),
  Prefecture('16', '富山県', '010500'),
  Prefecture('17', '石川県', '010500'),
  Prefecture('18', '福井県', '010500'),
  Prefecture('19', '山梨県', '010300'),
  Prefecture('20', '長野県', '010300'),
  Prefecture('21', '岐阜県', '010400'),
  Prefecture('22', '静岡県', '010400'),
  Prefecture('23', '愛知県', '010400'),
  Prefecture('24', '三重県', '010400'),
  Prefecture('25', '滋賀県', '010600'),
  Prefecture('26', '京都府', '010600'),
  Prefecture('27', '大阪府', '010600'),
  Prefecture('28', '兵庫県', '010600'),
  Prefecture('29', '奈良県', '010600'),
  Prefecture('30', '和歌山県', '010600'),
  Prefecture('31', '鳥取県', '010700'),
  Prefecture('32', '島根県', '010700'),
  Prefecture('33', '岡山県', '010700'),
  Prefecture('34', '広島県', '010700'),
  Prefecture('35', '山口県', '010700'),
  Prefecture('36', '徳島県', '010800'),
  Prefecture('37', '香川県', '010800'),
  Prefecture('38', '愛媛県', '010800'),
  Prefecture('39', '高知県', '010800'),
  Prefecture('40', '福岡県', '010900'),
  Prefecture('41', '佐賀県', '010900'),
  Prefecture('42', '長崎県', '010900'),
  Prefecture('43', '熊本県', '010900'),
  Prefecture('44', '大分県', '010900'),
  Prefecture('45', '宮崎県', '011000'),
  Prefecture('46', '鹿児島県', '011000'),
  Prefecture('47', '沖縄県', '011100'),
];
