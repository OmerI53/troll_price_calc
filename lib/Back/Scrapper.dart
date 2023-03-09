import 'dart:async';
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
  final file = File('lib/Back/db.json');
  //https://db.ygoprodeck.com/api/v7/cardinfo.php?name=Harpie%27s%20Feather%20Duster
  var client = http.Client();
  var url = Uri.parse('https://db.ygoprodeck.com/api/v7/cardinfo.php');
  var response = await client.get(url);
  if (response.statusCode == 200) {
    file.writeAsStringSync(response.body);
    //WRITE ID-NAME PAIR
    var idname = {};
    var data = json.decode(response.body);
    List cardlist = data['data'];
    for (var i in cardlist) {
      String name = i['name'];
      for (var j in i['card_images']) {
        idname[j['id'].toString()] = name;
      }
    }
    File idnamef = File('lib/Back/id-name.json');
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
      decklistcopy[i][j] ?? print('object');
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
      //Remove same cards
      if (j != 0) {
        if (decklist[i][j - 1] == decklist[i][j]) {
          deckparts.add(deckparts.last);
          continue;
        }
      }
      String cardname = decklist[i][j];
      //String cardname = 'Ash Blossom & Joyous Spring';
      //Relevant
      String url =
          'https://www.trollandtoad.com/yugioh/all-yu-gi-oh-singles/7087?hide-oos=on&search-words=${cardname.replaceAll(' ', '+')}&token=iIStBBEd1JKwBOxaU3pw%2FPJSqk6N8TtUlJzz3F4J8pu1LVQaGJuRhuTG6pdxFNKU59lXPwke76AvLOTWgSbTSA%3D%3D';
      final response = await client.get(Uri.parse(url));
      print(cardname);
      if (response.statusCode == 200) {
        var document = parser.parse(response.body);
        //listing of items
        var listings = document.getElementsByClassName('product-col');
        if (listings.isNotEmpty) {
          int productIndex = 0; //index of listed items
          var finalName;
          var finalImgHTML;
          String finalPrice = '0';

          //itterate over some of the lisings to get the min price

          do {
            if (productIndex >= listings.length) {
              //break if trying to access non existing listings
              break;
            }

            var priceCol =
                listings[productIndex].children[0].children.last.children[3];

            if (priceCol.children.isNotEmpty) {
              //check if there is price listings

              var sellerRow = priceCol.children[0].children[1];
              var priceHTML = sellerRow.children[sellerRow.children.length - 2];
              var itPrice =
                  priceHTML.text.trim().substring(1).replaceAll(',', '');

              var itImgHTML = listings[productIndex]
                  .children[0]
                  .children
                  .last
                  .children[0]
                  .children[0]
                  .children[0];
              var itName = itImgHTML.attributes['alt'].toString();

              if (finalPrice == '0') {
                //initial assign
                finalPrice = itPrice;
                finalName = itName;
                finalImgHTML = itImgHTML;
                continue;
              }

              if ((double.parse(itPrice) <= double.parse(finalPrice)) &&
                  itName.replaceAll(RegExp('[^A-Za-z0-9]'), '').contains(
                      cardname.replaceAll(RegExp('[^A-Za-z0-9]'), ''))) {
                finalPrice = itPrice;
                finalName = itName;
                finalImgHTML = itImgHTML;
              }
            }
            productIndex++;
          } while (productIndex < 11);

          String? img = finalImgHTML.attributes['src'];

          c = YGOCard(
              finalName, img!.replaceAll('small', 'pictures'), finalPrice);
          print(c.name);
        }
      } else {
        print('scrapper access denied');
      }
      deckparts.add(c);
      await Future.delayed(const Duration(seconds: 2));
    }
    deckClass.add(deckparts);
  }
  client.close();

  return deckClass;
}

int priceCalc(List cardlist) {
  double cost = 0;
  for (int i = 0; i < cardlist.length; i++) {
    cost += double.parse(cardlist[i].price);
  }
  return cost.round();
}

Future<void> main(List<String> args) async {
  //getCardDatabase();

  var ydkpath = '/Users/omerislam/desktop/Salvation Kashtira Tearlaments.ydk';
  List<List> deckparse = await parseYDK(ydkpath);
  List<List> deckconv = convertYDK(deckparse);

  List<List<YGOCard>> decklist = await scrapsite(deckconv);
}
