import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PinCode auth+pin set',
      theme: ThemeData(),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: NumtoPinBtn(),
    ));
  }
}

String alertDialogSuccess = 'Success';
String alertDialogSuccessAuth = 'SuccessAuth';
String alertDialogErrorAuth = 'Pin is wrong';
String alertDialogError = 'Re-enter is wrong';
String alertDialog = 'Template';

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
      // ЗАКИНУТЬ СЮДА ЗАПУСК ЭКРАНА АВТОРИЗАЦИИ
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    // title: Text("My title"),
    content: Text(alertDialog),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class NumtoPinBtn extends StatefulWidget {
  NumtoPinBtn({Key? key}) : super(key: key);

  @override
  State<NumtoPinBtn> createState() => _NumtoPinBtnState();
}

class _NumtoPinBtnState extends State<NumtoPinBtn> {
  List<int> pincode = [];
  List<int> pinCodeStorage = [];
  List<int> pinCodeTEMPStorage = [];

  String textEnterPin = 'Enter Pincode';
  String textCreatePin = 'Create PIN';
  String textRepeatPin = 'Re-enter your PIN';
  String textDefaultPin = 'Create PIN';
  int pagesIndicator = 0;
  int errors = 0;
  int pagesIndicatorTWO = 0;

  Function eq = const ListEquality().equals;

  deletePin(id) {
    print('DELETE-');
    setState(() {
      isSelected[pincode.length - 1] = false;
      print("isSelected from del $isSelected");
      pincode.removeLast();
      print('pincode from del $pincode');
      if (isSelected.isEmpty && pincode.isEmpty) {
        id = null;
      }
    });
    print('-DELETE');
  }

  addPin(id) {
    pincode.add(id);
    isSelected[pincode.length - 1] = true;
    // print('ADD-');
    // print(id);
    print(pincode);
    // print(isSelected);
    // print('-ADD');
    setState(() {});
  }

  checkRepeatPin() {
    if (eq(pincode, pinCodeTEMPStorage)) {
      alertDialog = alertDialogSuccess;
      showAlertDialog(context);
      pinCodeStorage = pinCodeTEMPStorage;
      print('SUCSESS');
      pinCodeTEMPStorage = [];
      pincode = [];
      pagesIndicatorTWO++;
      textDefaultPin = textEnterPin;
      setState(() {
      });
    } else {
      alertDialog = alertDialogError;
      showAlertDialog(context);
      print('pincode: $pincode, pinCodeStorage: $pinCodeTEMPStorage');
      print('ERROR: pincode != pinCodeTEMPStorage');
      pincode = [];
      textDefaultPin = textCreatePin;
      isSelected = [false, false, false, false];
      pagesIndicator = 0;
      setState(() {});
    }
  }

  loginPage() {
    // ПЕРЕХОД НА СТРАНИЦУ АВТОРИЗАЦИИ
    textDefaultPin = textEnterPin;
    isSelected = [false, false, false, false];
    setState(() {});
    if (eq(pincode, pinCodeStorage)) {
      alertDialog = alertDialogSuccessAuth;
      showAlertDialog(context);
      print('SUCSESS auth');
      pinCodeTEMPStorage = [];
      pincode = [];
      
    } else if (pincode.isNotEmpty) {
      alertDialog = alertDialogErrorAuth;
      showAlertDialog(context);

      print(
          'ERROR WRONG PIN FOR ENTER pincode: $pincode, pinCodeStorage: $pinCodeStorage');
      pincode = [];
      isSelected = [false, false, false, false];
      pinCodeTEMPStorage = [];
      setState(() {});
    } else {
      pincode = [];
    }
  }
  authPage() {
    pagesIndicator = 0;
    textDefaultPin = textCreatePin;
    setState(() {
    });
  }

  _bnt_press(id) {
    setState(() {
      // repeatPin() {
      //   isSelected = [false, false, false, false];
      //   pinCodeTEMPStorage = pincode;
      //   pincode = [];
      //   pagesIndicator++;
      //   print('$pagesIndicator pagesIndicator');
      //   textDefaultPin = textRepeatPin;
      //   print('$isSelected ЗАПУСТИЛСЯ ЭКРАН ПОВТОРА УСТАНОВКИ ПАРОЛЯ');
      //   // showAlertDialog(context);
      // }

      if (id == 10 && pincode.isNotEmpty) {
        deletePin(id);
      } else if (id == 10 && pincode.isEmpty) {
        print('return');
        return;
      } else {
        if (pincode.length < 4) {
          addPin(id);
        } else {
          print('error?');
          print('pincode from error $pincode');
          errors++;
          if (errors == 5) {
            return;
          }
        }
      }

      if (pincode.length == 4 && pagesIndicator != 3) {
        pagesIndicator++;
        print('$pagesIndicator увеличился на 1');
        if (pagesIndicator == 2) {
          isSelected = [false, false, false, false];
          pagesIndicator = 3;
          checkRepeatPin();
        } else if (pagesIndicator == 1) {
          isSelected = [false, false, false, false];
          pinCodeTEMPStorage = pincode;
          pincode = [];
          textDefaultPin = textRepeatPin;
        }
      }
      if (pincode.length == 4 && pagesIndicator == 3) {
        loginPage();
      }
      print('from main change id: $id');
      print("from main changeisSelected:  $isSelected");
      print('from main changepincode:  $pincode');
    });
  }

  List<bool> isSelected = [false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 150,
        height: 400,
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                  child: Text("Login Page", style: TextStyle(fontSize: 14)),
                  onPressed: () {
                    loginPage();
                  }),
              ElevatedButton(
                  child: Text("Auth Page", style: TextStyle(fontSize: 14)),
                  onPressed: () {
                    authPage();
                  }),
              Text(textDefaultPin),
              Container(
                child: Row(
                  children: [
                    ToggleButtons(
                      children: const <Widget>[
                        Text('*'),
                        Text('*'),
                        Text('*'),
                        Text('*'),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          isSelected[index] = !isSelected[index];
                        });
                      },
                      isSelected: isSelected,
                      // constraints: BoxConstraints(maxWidth: 10, maxHeight: 10),
                      // borderColor: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  FloatingActionButton.extended(
                    backgroundColor: Colors.white70,
                    elevation: 1,
                    label: const Text('1'),
                    onPressed: () => {_bnt_press(1)},
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Colors.white70,
                    elevation: 1,
                    label: const Text('2'),
                    onPressed: () => {_bnt_press(2)},
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Colors.white70,
                    elevation: 1,
                    label: const Text('3'),
                    onPressed: () => {_bnt_press(3)},
                  ),
                ],
              ),
              Row(
                children: [
                  FloatingActionButton.extended(
                    backgroundColor: Colors.white70,
                    elevation: 1,
                    label: const Text('4'),
                    onPressed: () => {_bnt_press(4)},
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Colors.white70,
                    elevation: 1,
                    label: const Text('5'),
                    onPressed: () => {_bnt_press(5)},
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Colors.white70,
                    elevation: 1,
                    label: const Text('6'),
                    onPressed: () => {_bnt_press(6)},
                  ),
                ],
              ),
              Row(
                children: [
                  FloatingActionButton.extended(
                    backgroundColor: Colors.white70,
                    elevation: 1,
                    label: const Text('7'),
                    onPressed: () => {_bnt_press(7)},
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Colors.white70,
                    elevation: 1,
                    label: const Text('8'),
                    onPressed: () => {_bnt_press(8)},
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Colors.white70,
                    elevation: 1,
                    label: const Text('9'),
                    onPressed: () => {_bnt_press(9)},
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 100,
                      color: Colors.red,
                    ),
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Colors.white70,
                    elevation: 1,
                    label: const Text('0'),
                    onPressed: () => {_bnt_press(0)},
                  ),
                  Container(
                    height: 48,
                    width: 50,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white70,
                      elevation: 1,
                      child: const Icon(Icons.delete),
                      onPressed: () => {_bnt_press(10)},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
