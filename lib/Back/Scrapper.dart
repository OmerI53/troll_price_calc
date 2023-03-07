import 'dart:convert';
import 'dart:io';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

//https://ygoprodeck.com/api-guide/ yugioh api

class YGOCard {
  late String name;
  late String img;
  late String price;

  YGOCard(String name, String img, String price) {
    this.name = name;
    this.img = img;
    this.price = price;
  }

  showDetails() {
    print('name: ${this.name}, img: ${this.img}, price: ${this.price}');
  }
}

getCardDatabase() async {
  final file = File('db.json');

  var client = http.Client();
  var url = Uri.parse('https://db.ygoprodeck.com/api/v7/cardinfo.php');
  var response = await client.get(url);
  if (response.statusCode == 200) {
    file.writeAsStringSync(response.body);
    //WRITE ID-NAME PAIR
    var idname = {};
    var data = json.decode(response.body);
    List cardlist = data['data'];
    for (int i = 0; i < cardlist.length; i++) {
      //print('${cardlist[i]['id'].toString()}:${cardlist[i]['name']}');
      idname[cardlist[i]['id'].toString()] = cardlist[i]['name'].toString();
    }
    File idnamef = File('id-name.json');
    idnamef.writeAsString(jsonEncode(idname));
  } else {
    print("error from api");
  }
  client.close();
}

Future<List<List>> parseYDK(var path) async {
  File ydkfile = File(path);
  final contents = await ydkfile.readAsString();
  var lines = LineSplitter().convert(contents.split('#main')[1]);

  List<List> decklist = [];
  List maindeck = [];
  int ei = 0;
  List extradeck = [];
  int si = 0;
  List sidedeck = [];

  for (int i = 1; i < lines.length; i++) {
    if (!lines[i].contains('extra')) {
      if (lines[i].startsWith('0')) {
        lines[i] = lines[i].substring(1);
      }
      //print(lines[i]);
      maindeck.add(lines[i]);
    } else {
      ei = i + 1;
      break;
    }
  }
  for (ei; ei < lines.length; ei++) {
    if (!lines[ei].contains('!side')) {
      if (lines[ei].startsWith('0')) {
        lines[ei] = lines[ei].substring(1);
      }
      //print(lines[ei]);
      extradeck.add(lines[ei]);
    } else {
      si = ei + 1;
      break;
    }
  }
  for (si; si < lines.length; si++) {
    //print(lines[si]);
    if (lines[si].startsWith('0')) {
      lines[si] = lines[si].substring(1);
    }
    sidedeck.add(lines[si]);
  }

  decklist.add(maindeck);
  decklist.add(extradeck);
  decklist.add(sidedeck);
  return decklist;
}

convertYDK(List<List> decklist) {
  //String filePath =
  '/Users/omerislam/Desktop/Ömer/Flutter/troll_price_calc/lib/Back/id-name.json';
  String filePath = 'lib/Back/id-name.json';
  File file = File(filePath);
  var filecontent = file.readAsStringSync();
  Map idName = json.decode(filecontent);
  var decklistcopy = [...decklist];
  for (int i = 0; i < decklist.length; i++) {
    for (int j = 0; j < decklist[i].length; j++) {
      decklistcopy[i][j] = idName[decklist[i][j]];
      print(decklistcopy[i][j]);
    }
  }

  return decklistcopy;
}

Future<List<List<YGOCard>>> scrapsite(List<List> decklist) async {
  List<List<YGOCard>> deckClass = [];
  YGOCard c = YGOCard('ERROR',
      'https://images.ygoprodeck.com/images/cards_small/68638985.jpg', '0.00');
  var client = http.Client();
  for (int i = 0; i < decklist.length; i++) {
    List<YGOCard> deckparts = [];
    for (int j = 0; j < decklist[i].length; j++) {
      if (j != 0) {
        if (decklist[i][j - 1] == decklist[i][j]) {
          deckparts.add(deckparts.last);
          continue;
        }
      }
      print(decklist[i][j]);
      String cardname = decklist[i][j].replaceAll(' ', '+');
      //String cardname = 'Predaplant+Dragostapelia';
      //Low
      //String url =
      'https://www.trollandtoad.com/category.php?hide-oos=on&min-price=&max-price=&items-pp=60&item-condition=&search-words${cardname}&token=Oi4tdttdqkgSf6ritYdW0WBRCn5mPpL6WaorGmYYGcURXJmf0Mv0RCWMK5QDh%2BrMg1PmZou%2BHJLEkBwyD2d0qQ%3D%3D&selected-cat=4736&sort-order=L-H&page-no=1&view=list&subproduct=0';

      //Relevant
      String url =
          'https://www.trollandtoad.com/category.php?selected-cat=4736&search-words=${cardname}&token=GqLTI3x%2BHo6A8pQlcyMPjUfVvMvoAgUruTsRyC0ly97n0MezHAF59ObmcS6LlQ7Ye6jmThKEfBtV9HZmbiyUSA%3D%3D';
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var document = parser.parse(response.body);
        var listings = document.getElementsByClassName('product-col');
        if (listings.isNotEmpty) {
          int productIndex = -1;
          do {
            productIndex += 1;
            var imgHTML = listings[productIndex]
                .children[0]
                .children[0]
                .children[0]
                .children[0]
                .children[0];
            String? img = imgHTML.attributes['src'];
            var priceCol =
                listings[productIndex].children[0].children[0].children[3];
            if (priceCol.children.isNotEmpty) {
              var sellerRow = priceCol.children[0].children[1];
              var priceHTML = sellerRow.children[sellerRow.children.length - 2];
              c = YGOCard(imgHTML.attributes['alt'].toString(),
                  img!.replaceAll('small', 'pictures'), priceHTML.text.trim());
            }
          } while (c.name.contains('Field Center Card'));
          print(c.name);
        }
      } else {
        print('scrapper access denied');
      }
      deckparts.add(c);
      sleep(const Duration(seconds: 2));
    }
    deckClass.add(deckparts);
  }
  client.close();
  return deckClass;
}

List<double> priceCalc(List<List<YGOCard>> decklist) {
  List<double> priceArr = [];

  for (int i = 0; i < decklist.length; i++) {
    double cost = 0;
    for (int j = 0; j < decklist[i].length; j++) {
      cost += double.parse(decklist[i][j].price.substring(1));
    }
    priceArr.add(cost);
  }
  priceArr.add(priceArr[0] + priceArr[1] + priceArr[2]);
  return priceArr;
}

Future<void> main(List<String> args) async {
  //var ydkpath = '/Users/omerislam/desktop/xxx-Mathmech.ydk';

  var ydkpath = '/Users/omerislam/desktop/Branded Despia.ydk';
  List<List> deckparse = await parseYDK(ydkpath);
  List<List> deckconv = convertYDK(deckparse);
  /*
  deckconv.forEach((element) {
    print(element);
  });

  //List<List<YGOCard>> decklist = await scrapsite(deckconv);
  //print(decklist[0][0].price);
  */
}
