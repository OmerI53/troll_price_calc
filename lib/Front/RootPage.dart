import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:troll_price_calc/Front/DecklistPage.dart';
import '../Back/Scrapper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart' as p;

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String ydkpath = '';
  String ydkfileName = '';
  bool isloading = false;
  late List<List<YGOCard>> decklist;

  @override
  Widget build(BuildContext context) => isloading
      ? const LoadingPage()
      : Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/MainBg.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 70,
                ),
                const Image(
                    image: AssetImage("images/ygoLogo.png"), width: 400),
                const SizedBox(
                  height: 200,
                ),
                SizedBox(
                    height: 120,
                    child: Visibility(
                        visible: ydkpath != '',
                        child: Icon(
                          Icons.folder,
                          color: Colors.amberAccent.withOpacity(0.8),
                          size: 150,
                        ))),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 20,
                    width: 150,
                    child: Text(
                      ydkfileName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                                color: Colors.black, width: 2)),
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();
                          if (result != null &&
                              result.files.single.path != null) {
                            PlatformFile file = result.files.first;
                            //print(file.path);
                            setState(() {
                              ydkpath = file.path!;
                              ydkfileName = p.basenameWithoutExtension(ydkpath);
                            });
                          } else {
                            // User canceled the picker
                          }
                        },
                        child: const Text(
                          'Choose File',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      width: 0,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(13),
                          shape: const CircleBorder(
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          ydkpath = '';
                          ydkfileName = '';
                          setState(() {});
                        },
                        child: const Icon(Icons.cancel)),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      side: const BorderSide(color: Colors.black, width: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    List<List> deckparse = await parseYDK(ydkpath);
                    List<List> deckconv = convertYDK(deckparse);
                    setState(() {
                      isloading = true;
                    });

                    decklist = await scrapsite(deckconv);
                    setState(() {
                      isloading = false;
                    });
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DecklistPage(decklist, ydkfileName)));
                    isloading = false;
                    setState(() {});
                  },
                  child: const Text(
                    'Start',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 1150,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                                color: Colors.black, width: 2)),
                        onPressed: () {},
                        child: const Text(
                          'Update DataBase',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                  ],
                )
              ],
            ),
          ),
        );
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/loading.jpeg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: SpinKitSpinningLines(
          duration: const Duration(seconds: 1),
          size: 140,
          color: Colors.deepPurple.withOpacity(0.6),
        )),
      ),
    );
  }
}
