import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ShowCapturedWidget extends StatefulWidget {
  final List<File> files;
  const ShowCapturedWidget({Key? key, required this.files}) : super(key: key);
  @override
  State<ShowCapturedWidget> createState() => _ShowCapturedWidgetState();
}

class _ShowCapturedWidgetState extends State<ShowCapturedWidget> {
  //List<File> files = [];
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.0);
  _ShowCapturedWidgetState() {
    // files = widget.files;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Captured Widget'),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            alignment: Alignment.center,
            height: 250,
            //width: double.infinity,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                //thickness: ,
                child: ListView.separated(
                  controller: _scrollController,
                  itemCount: widget.files.length,
                  //physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.down,
                      onDismissed: (_) async {
                        try {
                          if (await widget.files[index].exists()) {
                            await widget.files[index].delete();
                          }
                        } catch (e) {
                          // Error in getting access to the file.
                        }
                        setState(() {
                          //print(files.length);
                          widget.files.removeAt(index);
                          print('a file removed');
                          //print(files.length);

                          //len -= 1;
                        });
                      },
                      child:
                          buildListItem(widget.files[index]), //% files.length
                      background: Container(
                        color: Colors.red[300],
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Icon(Icons.delete,
                            color: Colors.black87, size: 48),
                      ),
                    );
                  },
                  separatorBuilder: ((context, index) =>
                      const SizedBox(width: 10)),

                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ),
        ));
  }

  Widget buildListItem(File imageFile) {
    return SizedBox(
        height: 250,
        child: Image.file(
          imageFile,
          fit: BoxFit.contain,
        ));

    //return const Text('');
  }
}
