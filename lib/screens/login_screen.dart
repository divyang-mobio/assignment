import 'package:flutter_otp/flutter_otp.dart';
import '../controller/data_fetch_bloc.dart';
import '../controller/favorite_bloc.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final otp = FlutterOtp();
  final _auth = FirebaseAuth.instance;
  final TextEditingController _phoneNo = TextEditingController();
  final TextEditingController _code = TextEditingController();
  String _verificationIdData = "";
  bool _otpSend = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: costumeTextField(_phoneNo, "Phone No",
                    TextInputType.phone, const Icon(Icons.phone))),
            const SizedBox(height: 10),
            Visibility(
              visible: _otpSend,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  child: costumeTextField(_code, "Enter Code",
                      TextInputType.number, const Icon(Icons.lock))),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: () => _otpSend ? _verifyOtp() : _sendOtp(),
              child: Text(_otpSend ? 'log in' : 'Verify'),
            )
          ],
        ),
      ),
    );
  }

  _sendOtp() {
    _auth.verifyPhoneNumber(
        phoneNumber: _phoneNo.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) => {
                BlocProvider.of<DataFetchBloc>(context)
                    .add(GetAllData(path: "assets/data.json")),
                BlocProvider.of<FavoriteBloc>(context)
                    .add(GetAllDataFavorite()),
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()))
              });
        },
        verificationFailed: (FirebaseAuthException exception) => print('''
          --------------------------------
          ${exception.message}
          --------------------------------
          '''),
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationIdData = verificationId;
            _otpSend = true;
          });
        },
        codeAutoRetrievalTimeout: (String timeOut) {});
  }

  _verifyOtp() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationIdData, smsCode: _code.text);
    await _auth.signInWithCredential(credential).then((value) => {
          BlocProvider.of<DataFetchBloc>(context)
              .add(GetAllData(path: "assets/data.json")),
          BlocProvider.of<FavoriteBloc>(context).add(GetAllDataFavorite()),
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MyHomePage()))
        });
  }
}

TextField costumeTextField(TextEditingController controller, String hintTexts,
    TextInputType textInputType, Icon icon) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        hintText: hintTexts, labelText: hintTexts, suffixIcon: icon),
    keyboardType: textInputType,
    maxLength: 14,
  );
}
