import 'package:flutter/material.dart';
import '../Back/Scrapper.dart';

class DecklistPage extends StatefulWidget {
  DecklistPage(this.decklist, this.title, {super.key});
  List<List<YGOCard>> decklist;
  String title;
  @override
  State<DecklistPage> createState() => _DecklistPageState();
}

class _DecklistPageState extends State<DecklistPage> {
  late List<double> priceArr = priceCalc(widget.decklist);
  late double sidelenght = widget.decklist[2].length as double;
  late String title = widget.title;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/decklistBg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(title),
        ),
        body: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(5),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Container(
                  color: Colors.grey.withOpacity(0.4),
                  width: 1100,
                  height: 560,
                  //Main
                  child: GridView.count(
                    childAspectRatio: 0.5,
                    crossAxisSpacing: 7,
                    padding: const EdgeInsets.all(4),
                    // ignore: sort_child_properties_last
                    children: List.generate(widget.decklist[0].length, (index) {
                      return CardView(widget.decklist[0][index]);
                    }),
                    crossAxisCount: 10,
                  ),
                  //CardView(widget.decklist[0][0]),
                ),
                const SizedBox(
                  height: 7,
                ),
                //side
                Container(
                  color: Colors.lightBlue.withOpacity(0.4),
                  width: 1100,
                  height: 154,
                  /*
                  child: GridView.count(
                    childAspectRatio: 0.3,
                    crossAxisSpacing: 7,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(4),
                    // ignore: sort_child_properties_last
                    children: List.generate(widget.decklist[2].length, (index) {
                      return CardView(widget.decklist[2][index]);
                    }),
                    crossAxisCount: widget.decklist[2].length,
                  ),
                  */
                ),
                const SizedBox(
                  height: 5,
                ),
                //extra
                Container(
                  color: Colors.amber.withOpacity(0.4),
                  width: 1100,
                  height: 154,
                  child: GridView.count(
                    childAspectRatio: 0.3,
                    crossAxisSpacing: 7,
                    padding: const EdgeInsets.all(4),
                    physics: const NeverScrollableScrollPhysics(),
                    // ignore: sort_child_properties_last
                    children: List.generate(widget.decklist[1].length, (index) {
                      return CardView(widget.decklist[1][index]);
                    }),
                    crossAxisCount: widget.decklist[1].length,
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                const Padding(padding: EdgeInsets.all(5)),
                Container(
                  color: Colors.lightGreenAccent.withOpacity(0.4),
                  width: 200,
                  height: 600,
                  child: Column(children: [
                    const Text(
                      'Main Deck Cost',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${priceArr[0].round()}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    const Text(
                      'Side Deck Cost',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${priceArr[2].round()}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    const Text(
                      'Extra Deck Cost',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${priceArr[1].round()}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    const Text(
                      'Total Deck Cost',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${priceArr[3].round()}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CardView extends StatelessWidget {
  const CardView(this.card, {super.key});
  final YGOCard card;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 20,
      child: Column(children: [
        SizedBox(
            width: 100,
            height: 35,
            child: Text(
              card.name,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            )),
        const SizedBox(
          height: 5,
        ),
        Image.network(
          card.img,
          scale: 0.6,
        ),
        Text(
          card.price,
          style: const TextStyle(fontSize: 10),
        )
      ]),
    );
  }
}
