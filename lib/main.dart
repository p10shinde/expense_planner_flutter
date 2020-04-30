import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Montserrat',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              button: TextStyle(
                color: Colors.white,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'IndieFlower',
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: DateTime.now().toString(),
        title: 'New Shoes',
        amount: 600.50,
        date: DateTime.now()),
    Transaction(
        id: DateTime.now().toString(),
        title: 'Weekly Groceries',
        amount: 500.99,
        date: DateTime.now().subtract(Duration(days: 2))),
    Transaction(
        id: DateTime.now().toString(),
        title: 'New Shoes',
        amount: 600.50,
        date: DateTime.now()),
    Transaction(
        id: DateTime.now().toString(),
        title: 'Weekly Groceries',
        amount: 500.99,
        date: DateTime.now().subtract(Duration(days: 2))),
    Transaction(
        id: DateTime.now().toString(),
        title: 'New Shoes',
        amount: 600.50,
        date: DateTime.now()),
    Transaction(
        id: DateTime.now().toString(),
        title: 'Weekly Groceries',
        amount: 500.99,
        date: DateTime.now().subtract(Duration(days: 2))),
    Transaction(
        id: DateTime.now().toString(),
        title: 'New Shoes',
        amount: 600.50,
        date: DateTime.now()),
    Transaction(
        id: DateTime.now().toString(),
        title: 'Weekly Groceries',
        amount: 500.99,
        date: DateTime.now().subtract(Duration(days: 2))),
    Transaction(
        id: DateTime.now().toString(),
        title: 'New Shoes',
        amount: 600.50,
        date: DateTime.now()),
    Transaction(
        id: DateTime.now().toString(),
        title: 'Weekly Groceries',
        amount: 500.99,
        date: DateTime.now().subtract(Duration(days: 2)))
  ];

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
      id: DateTime.now().toString().toString(),
      title: title,
      amount: amount,
      date: date,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bctx) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where(
      (t) {
        return t.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, _txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Show Chart', style: Theme.of(context).textTheme.title),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  .7,
              width: double.infinity,
              child: Chart(_recentTransactions),
            )
          : _txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget _txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            .4,
        width: double.infinity,
        child: Chart(_recentTransactions),
      ),
      _txListWidget
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () {
                    _startAddNewTransaction(
                      context,
                    );
                  },
                )
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expenses',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                ),
                onPressed: () {
                  _startAddNewTransaction(
                    context,
                  );
                },
              )
            ],
          );
  }

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    // super.didChangeAppLifecycleState(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar();
    final _txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          .6,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (_isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, _txListWidget),
            if (!_isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, _txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(
                      Icons.add,
                    ),
                    mini: false,
                    clipBehavior: Clip.hardEdge,
                    onPressed: () {
                      _startAddNewTransaction(context);
                    },
                  ),
          );
  }
}
