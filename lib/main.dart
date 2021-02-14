import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Box Image",
      home: Home(),
      theme: ThemeData(primaryColor: Colors.amber, accentColor: Colors.green),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _picker = ImagePicker();
  String choosenValue;
  List listitems = ['cover', 'fill', 'contain', 'fitHeight', 'fitWidth'];

  File _image;
  double height = 200.0;
  double width = 200.0;

  _imgFromCamera() async {
    final pickedimage =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    File image = File(pickedimage.path);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    final pickedimage =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    File image = File(pickedimage.path);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Box Image'),
      ),
      body: Column(
        children: [
          Center(
            child: ListTile(
              title: Text('Box Fit'),
              subtitle: Text('Select the type on config you want'),
              trailing: DropdownButton(
                hint: Text("Box Type Config"),
                focusColor: Colors.yellow,
                value: choosenValue,
                items: listitems
                    .map(
                      (valueItem) => DropdownMenuItem(
                        child: Text(valueItem),
                        value: valueItem,
                      ),
                    )
                    .toList(),
                onChanged: (newValue) {
                  setState(
                    () {
                      choosenValue = newValue;
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            height: 320,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 40.0, top: 20.0),
                      decoration: BoxDecoration(color: Colors.amber),
                      width: width,
                      height: height,
                      child: _image != null
                          ? Image.file(
                              _image,
                              width: 100,
                              height: 100,
                              fit: choosenValue == 'cover'
                                  ? BoxFit.cover
                                  : choosenValue == 'fill'
                                      ? BoxFit.fill
                                      : choosenValue == 'contain'
                                          ? BoxFit.contain
                                          : choosenValue == 'fitHeight'
                                              ? BoxFit.fitHeight
                                              : BoxFit.fitWidth,
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                    Flexible(child: Container()),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        value: height,
                        onChanged: (newheight) {
                          setState(() {
                            height = newheight;
                          });
                        },
                        min: 100,
                        max: 300,
                        divisions: 20,
                        label: "$height",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Slider(
            value: width,
            onChanged: (newwidth) {
              setState(() {
                width = newwidth;
              });
            },
            min: 100,
            max: 300,
            divisions: 20,
            label: "$width",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  _showPicker(context);
                },
                child: Text('Upload Image'),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _image = null;
                  });
                },
                child: Text(
                  'Remove Image',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Current Height: $height\n Current Width: $width '),
          )
        ],
      ),
    );
  }
}
