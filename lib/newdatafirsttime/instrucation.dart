import 'package:flutter/material.dart';
import 'package:lineder/animation/splashicon.dart';
import 'package:lineder/helpers/locale.dart';

class Instration extends StatefulWidget {
  final chooce;

  const Instration({Key key, this.chooce}) : super(key: key);
  @override
  _InstrationState createState() => _InstrationState();
}

class _InstrationState extends State<Instration> {
  PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(int delta) {
    _pageController.animateToPage(_currentIndex + delta,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  _buildclient(index, title, desc) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: Colors.cyan,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage(images[index]))),
          ),
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(boxShadow: <BoxShadow>[
              BoxShadow(
                color: blueAccent,
                offset: Offset(1.0, 6.0),
                blurRadius: raduis,
              ),
              BoxShadow(
                color: lightBlueAccent,
                offset: Offset(1.0, 6.0),
                blurRadius: raduis,
              ),
            ], gradient: LinearGradient(colors: [cyan, grey])),
            child:
                Text(title[index], textAlign: TextAlign.center, style: style),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  desc[index],
                  style: styl,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  final _pages = <int, Widget>{};

  List images = [
    "images/lineder.png",
    "images/lineder.png",
    "images/lineder.png",
    "images/lineder.png",
    "images/lineder.png",
    "images/lineder.png",
    "images/lineder.png",
    "images/lineder.png",
  ];

  var style = TextStyle(
    fontSize: 34,
  );
  var styl = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  Color blueAccent = Colors.blueAccent;
  Color lightBlueAccent = Colors.lightBlueAccent;
  Color cyan = Colors.cyan[100];
  Color grey = Colors.grey[100];
  var raduis = 30.0;
  @override
  Widget build(BuildContext context) {
    List title = [
      "${DemoLocalizations.of(context).search}",
      "${DemoLocalizations.of(context).trialwatchbusines}",
      "${DemoLocalizations.of(context).trialmakeappoint}",
      "${DemoLocalizations.of(context).trialrequestline}",
    ];
    List desc = [
      "${DemoLocalizations.of(context).trialsearch}",
      "${DemoLocalizations.of(context).trialwatchbusiness}",
      "${DemoLocalizations.of(context).trialmakeappoints}",
      "${DemoLocalizations.of(context).trialrequestlines}",
    ];
    List titlebusiness = [
      "${DemoLocalizations.of(context).trialaddworker}",
      "${DemoLocalizations.of(context).trialaddkind}",
      "${DemoLocalizations.of(context).addlines}",
      "${DemoLocalizations.of(context).trialallline}",
      "${DemoLocalizations.of(context).requestclientsrelly}",
      "${DemoLocalizations.of(context).requestlines}",
      "${DemoLocalizations.of(context).addlines}",
      "${DemoLocalizations.of(context).updatelines}",
    ];
    List descbusiness = [
      "${DemoLocalizations.of(context).trialaddworkers}",
      "${DemoLocalizations.of(context).trialaddkinds}",
      "${DemoLocalizations.of(context).trialaddlines}",
      "${DemoLocalizations.of(context).trialalllines}",
      "${DemoLocalizations.of(context).trialrequests}",
      "${DemoLocalizations.of(context).trialrequests}",
      "${DemoLocalizations.of(context).trialaddlineclient}",
      "${DemoLocalizations.of(context).trialupdatelines}",
    ];
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _handlePageChanged,
      itemCount: widget.chooce == "8" ? 8 : 4,
      itemBuilder: (BuildContext context, int index) {
        return _pages.putIfAbsent(
          index,
          () {
            print('index: $index');
            return Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.white,
                title: Text(
                  "${widget.chooce == "8" ? 8 : 4}/ ${index + 1}".toString(),
                  style: TextStyle(color: Colors.black),
                ),
                leading: PuleAnimation(
                  child: FlatButton(
                    child: Text(
                      "${DemoLocalizations.of(context).skip}",
                      style: TextStyle(color: Colors.orange[700]),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.navigate_next,
                      color: Colors.black,
                    ),
                    tooltip: 'Next Page',
                    onPressed: () {
                      _nextPage(1);
                    },
                  ),
                ],
              ),
              body: widget.chooce == 'client'
                  ? _buildclient(index, title, desc)
                  : _buildclient(index, titlebusiness, descbusiness),
            );
          },
        );
      },
    );
  }
}

class ChooceInstrucation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("הדרכה"),
          backgroundColor: Colors.cyan,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          )),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.cyan,
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: AssetImage("images/lineder.png"))),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.only(left: 60, right: 60),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Instration(
                                chooce: "8",
                              );
                            });
                      },
                      child: Text(
                        "${DemoLocalizations.of(context).businessowner}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.only(left: 70, right: 70),
                      onPressed: () {
                        try {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Instration(
                                  chooce: "client",
                                );
                              });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text("${DemoLocalizations.of(context).client}"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
