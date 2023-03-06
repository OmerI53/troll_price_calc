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
  bool removeItems = false;
  List removedMain = [];
  List removedSide = [];
  List removedExtra = [];

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
                      return CardView(widget.decklist[0][index], index,
                          removeItems, removedMain);
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
                  child: GridView.count(
                    childAspectRatio: 0.3,
                    crossAxisSpacing: 7,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(4),
                    // ignore: sort_child_properties_last
                    children: List.generate(widget.decklist[2].length, (index) {
                      return CardView(widget.decklist[2][index], index,
                          removeItems, removedSide);
                    }),
                    // ignore: unnecessary_null_comparison
                    crossAxisCount: 15,
                  ),
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
                      return CardView(widget.decklist[1][index], index,
                          removeItems, removedExtra);
                    }),
                    crossAxisCount: 15,
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 32,
            ),
            Column(
              children: [
                const Padding(padding: EdgeInsets.all(5)),
                Container(
                  color: Colors.lightGreenAccent.withOpacity(0.4),
                  width: 200,
                  height: 530,
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
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 180,
                  width: 200,
                  color: Colors.redAccent.withOpacity(0.4),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      const Text(
                        'Remove Cards',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                          value: removeItems,
                          onChanged: (bool newBool) {
                            setState(() {
                              removeItems = newBool;
                            });
                          }),
                      Container(
                        width: 200,
                        height: 100,
                        padding: const EdgeInsets.all(5),
                        child: Visibility(
                            visible: removeItems,
                            child: Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey),
                                  onPressed: () {},
                                  child: const Text('Remove'),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      removeItems = false;
                                      for (var i in removedMain) {
                                        widget.decklist[0].removeAt(i);
                                      }
                                      for (var i in removedExtra) {
                                        widget.decklist[1].removeAt(i);
                                      }
                                      for (var i in removedSide) {
                                        widget.decklist[2].removeAt(i);
                                      }
                                    });
                                  },
                                  child: const Text('Confirm'),
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CardView extends StatefulWidget {
  CardView(this.card, this.index, this.remove, this.tobeRemoved, {super.key});
  final YGOCard card;
  List tobeRemoved;
  bool remove;
  int index;
  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  bool selected = false;
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
              widget.card.name,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            )),
        const SizedBox(
          height: 5,
        ),
        Image.network(
          widget.card.img,
          scale: 0.6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.card.price,
              style: const TextStyle(fontSize: 10),
            ),
            const SizedBox(
              width: 2,
            ),
            Visibility(
              visible: widget.remove,
              child: SizedBox(
                  width: 10,
                  height: 10,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selected ? Colors.red : Colors.green),
                      onPressed: () {
                        if (widget.tobeRemoved.contains(widget.index)) {
                          widget.tobeRemoved.remove(widget.index);
                          selected = false;
                        } else {
                          widget.tobeRemoved.add(widget.index);
                          selected = true;
                        }
                        setState(() {});
                      },
                      child: const Text('*'))),
            )
          ],
        )
      ]),
    );
  }
}
