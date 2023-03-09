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
  late String title = widget.title;

  bool removeItems = false;
  List removedMain = [];
  List removedSide = [];
  List removedExtra = [];

  late var main = Map.from(widget.decklist[0].asMap());
  late var extra = Map.from(widget.decklist[1].asMap());
  late var side = Map.from(widget.decklist[2].asMap());

  late int mainCost = priceCalc(main.values.toList());
  late int sideCost = priceCalc(side.values.toList());
  late int extraCost = priceCalc(extra.values.toList());

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
                  height: 15,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Colors.grey.withOpacity(0.4),
                      width: 1100,
                      height: 560,
                      //Main
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: GridView.count(
                          childAspectRatio: 0.48,
                          crossAxisSpacing: 7,
                          padding: const EdgeInsets.all(4),
                          // ignore: sort_child_properties_last
                          children: formList(
                              main.length, main, removeItems, removedMain),

                          crossAxisCount: 10,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -12,
                      right: -20,
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Colors.pink,
                        child: Text(
                          '${main.length}',
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                //side
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Colors.lightBlue.withOpacity(0.4),
                      width: 1100,
                      height: 154,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: GridView.count(
                          childAspectRatio: 0.3,
                          crossAxisSpacing: 7,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(4),
                          // ignore: sort_child_properties_last
                          children: formList(
                              side.length, side, removeItems, removedSide),

                          // ignore: unnecessary_null_comparison
                          crossAxisCount: 15,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -7,
                      right: -20,
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Colors.pink,
                        child: Text(
                          '${side.length}',
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                //extra
                Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: Colors.amber.withOpacity(0.4),
                        width: 1100,
                        height: 154,
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: GridView.count(
                            childAspectRatio: 0.3,
                            crossAxisSpacing: 7,
                            padding: const EdgeInsets.all(4),
                            physics: const NeverScrollableScrollPhysics(),
                            // ignore: sort_child_properties_last
                            children: formList(
                                extra.length, extra, removeItems, removedExtra),
                            crossAxisCount: 15,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -8,
                        right: -20,
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.pink,
                          child: Text(
                            '${extra.length}',
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ])
              ],
            ),
            const SizedBox(
              width: 32,
            ),
            Column(
              children: [
                const Padding(padding: EdgeInsets.all(10)),
                //Price Column
                Container(
                  color: Colors.lightGreenAccent.withOpacity(0.4),
                  width: 230,
                  height: 430,
                  child: Column(children: [
                    const Text(
                      'Main Deck Cost',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          color: Colors.white),
                      child: Text(
                        '\$$mainCost',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Side Deck Cost',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          color: Colors.white),
                      child: Text(
                        '\$$sideCost',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Extra Deck Cost',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          color: Colors.white),
                      child: Text(
                        '\$$extraCost',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 55,
                    ),
                    const Text(
                      'Total Deck Cost',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          color: Colors.white),
                      child: Text(
                        '\$${mainCost + sideCost + extraCost}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 45,
                ),
                //Remove Cards
                Container(
                  height: 180,
                  width: 200,
                  color: Colors.redAccent.withOpacity(0.4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      const SizedBox(
                        height: 6,
                      ),
                      Visibility(
                        maintainAnimation: true,
                        maintainState: true,
                        maintainSize: true,
                        visible: removeItems,
                        child: SizedBox(
                          height: 50,
                          width: 110,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                            onPressed: () {
                              setState(() {
                                for (var i in removedMain) {
                                  main.remove(i);
                                }
                                for (var i in removedExtra) {
                                  extra.remove(i);
                                }
                                for (var i in removedSide) {
                                  side.remove(i);
                                }
                                removeItems = false;
                                removedMain.clear();
                                removedExtra.clear();
                                removedSide.clear();
                                mainCost = priceCalc(main.values.toList());
                                sideCost = priceCalc(side.values.toList());
                                extraCost = priceCalc(extra.values.toList());
                              });
                            },
                            child: const Text(
                              'Confirm',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
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
        Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
          Image.network(
            widget.card.img,
            scale: 0.6,
          ),
          Positioned(
            top: -5,
            right: -5,
            child: Visibility(
              visible: widget.remove,
              child: SizedBox(
                  width: 16,
                  height: 16,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          backgroundColor:
                              widget.tobeRemoved.contains(widget.index)
                                  ? Colors.red
                                  : Colors.green),
                      onPressed: () {
                        setState(() {
                          if (widget.tobeRemoved.contains(widget.index)) {
                            widget.tobeRemoved.remove(widget.index);
                          } else {
                            widget.tobeRemoved.add(widget.index);
                          }
                        });
                      },
                      child: const Text(''))),
            ),
          )
        ]),
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
          ],
        )
      ]),
    );
  }
}

List<Widget> formList(int lenght, Map m, removeItems, removedlist) {
  List<Widget> listTile = [];
  for (var i in m.keys) {
    listTile.add(CardView(m[i], i, removeItems, removedlist));
  }

  return listTile;
}
