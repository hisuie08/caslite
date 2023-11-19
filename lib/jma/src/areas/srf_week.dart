class Week {
  // 週間天気予報。
  final String srf;
  final String week;
  final String amedas;
  const Week({required this.srf, required this.week, required this.amedas});
  static List<Week> getWeeks(String srf) =>
      _weeks.where((w) => w.srf == srf).toList();
}

const _weeks = [
  Week(srf: "120020", week: "120000", amedas: "45147"),
  Week(srf: "220010", week: "220000", amedas: "50331"),
  Week(srf: "210010", week: "210000", amedas: "52586"),
  Week(srf: "210010", week: "210010", amedas: "52586"),
  Week(srf: "210020", week: "210020", amedas: "52146"),
  Week(srf: "230010", week: "230000", amedas: "51106"),
  Week(srf: "240010", week: "240000", amedas: "53133"),
  Week(srf: "150010", week: "150000", amedas: "54232"),
  Week(srf: "160010", week: "160000", amedas: "55102"),
  Week(srf: "170010", week: "170000", amedas: "56227"),
  Week(srf: "180010", week: "180000", amedas: "57066"),
  Week(srf: "250020", week: "250000", amedas: "60131"),
  Week(srf: "250020", week: "250020", amedas: "60131"),
  Week(srf: "250010", week: "250010", amedas: "60216"),
  Week(srf: "260010", week: "260000", amedas: "61286"),
  Week(srf: "260020", week: "260020", amedas: "61111"),
  Week(srf: "260010", week: "260010", amedas: "61286"),
  Week(srf: "290010", week: "290000", amedas: "64036"),
  Week(srf: "270000", week: "270000", amedas: "62078"),
  Week(srf: "280010", week: "280000", amedas: "63518"),
  Week(srf: "280020", week: "280020", amedas: "63051"),
  Week(srf: "280010", week: "280010", amedas: "63518"),
  Week(srf: "300010", week: "300000", amedas: "65042"),
  Week(srf: "320010", week: "320000", amedas: "68132"),
  Week(srf: "310010", week: "310000", amedas: "69122"),
  Week(srf: "330010", week: "330000", amedas: "66408"),
  Week(srf: "330020", week: "330020", amedas: "66186"),
  Week(srf: "330010", week: "330010", amedas: "66408"),
  Week(srf: "340010", week: "340000", amedas: "67437"),
  Week(srf: "340020", week: "340020", amedas: "67116"),
  Week(srf: "340010", week: "340010", amedas: "67437"),
  Week(srf: "370000", week: "370000", amedas: "72086"),
  Week(srf: "360010", week: "360000", amedas: "71106"),
  Week(srf: "380010", week: "380000", amedas: "73166"),
  Week(srf: "390010", week: "390000", amedas: "74182"),
  Week(srf: "390010", week: "390000", amedas: "74181"),
  Week(srf: "350010", week: "350000", amedas: "81428"),
  Week(srf: "400010", week: "400000", amedas: "82182"),
  Week(srf: "440010", week: "440000", amedas: "83216"),
  Week(srf: "410010", week: "410000", amedas: "85142"),
  Week(srf: "430010", week: "430000", amedas: "86141"),
  Week(srf: "420010", week: "420000", amedas: "84496"),
  Week(srf: "420030", week: "420030", amedas: "84072"),
  Week(srf: "420010", week: "420100", amedas: "84496"),
  Week(srf: "450010", week: "450000", amedas: "87376"),
  Week(srf: "460010", week: "460100", amedas: "88317"),
  Week(srf: "460040", week: "460040", amedas: "88836"),
  Week(srf: "471010", week: "471000", amedas: "91197"),
  Week(srf: "472000", week: "472000", amedas: "92011"),
  Week(srf: "473000", week: "473000", amedas: "93041"),
  Week(srf: "474010", week: "474000", amedas: "94081"),
  Week(srf: "011000", week: "011000", amedas: "11016"),
  Week(srf: "012010", week: "012000", amedas: "12442"),
  Week(srf: "013010", week: "013000", amedas: "17341"),
  Week(srf: "014020", week: "014000", amedas: "19432"),
  Week(srf: "014020", week: "014100", amedas: "19432"),
  Week(srf: "014030", week: "014000", amedas: "19432"),
  Week(srf: "014030", week: "014030", amedas: "20432"),
  Week(srf: "015010", week: "015000", amedas: "21323"),
  Week(srf: "016010", week: "016000", amedas: "14163"),
  Week(srf: "017010", week: "017000", amedas: "23232"),
  Week(srf: "020010", week: "020010", amedas: "31312"),
  Week(srf: "020030", week: "020200", amedas: "31602"),
  Week(srf: "020010", week: "020100", amedas: "31312"),
  Week(srf: "020030", week: "020030", amedas: "31602"),
  Week(srf: "050010", week: "050000", amedas: "32402"),
  Week(srf: "030010", week: "030000", amedas: "33431"),
  Week(srf: "030010", week: "030010", amedas: "33431"),
  Week(srf: "030020", week: "030100", amedas: "33472"),
  Week(srf: "060010", week: "060000", amedas: "35426"),
  Week(srf: "040010", week: "040000", amedas: "34392"),
  Week(srf: "040010", week: "040010", amedas: "34392"),
  Week(srf: "040020", week: "040020", amedas: "34461"),
  Week(srf: "070010", week: "070100", amedas: "36127"),
  Week(srf: "070030", week: "070030", amedas: "36361"),
  Week(srf: "200010", week: "200000", amedas: "48156"),
  Week(srf: "200010", week: "200010", amedas: "48156"),
  Week(srf: "200020", week: "200100", amedas: "48361"),
  Week(srf: "190010", week: "190000", amedas: "49142"),
  Week(srf: "100010", week: "100000", amedas: "42251"),
  Week(srf: "100020", week: "100020", amedas: "42091"),
  Week(srf: "100010", week: "100010", amedas: "42251"),
  Week(srf: "090010", week: "090000", amedas: "41277"),
  Week(srf: "080010", week: "080000", amedas: "40201"),
  Week(srf: "110020", week: "110000", amedas: "43056"),
  Week(srf: "130010", week: "130010", amedas: "44132"),
  Week(srf: "130030", week: "130100", amedas: "44263"),
  Week(srf: "130020", week: "130020", amedas: "44172"),
  Week(srf: "130030", week: "130030", amedas: "44263"),
  Week(srf: "130040", week: "130040", amedas: "44301"),
  Week(srf: "140010", week: "140000", amedas: "46106")
];
