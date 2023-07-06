import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Encryptor extends StatefulWidget {
  const Encryptor({super.key});

  @override
  State<Encryptor> createState() => _EncryptorState();
}

class _EncryptorState extends State<Encryptor> {
  late TextEditingController _txtController;
  Algorithm? _algorithm;
  String _txt = '';
  bool _clearBtnShowed = false;

  @override
  void initState() {
    _txtController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _txtController.dispose();
    super.dispose();
  }

  void _onChangeAlgorithm(Algorithm? algorithm) {
    setState(() {
      _algorithm = algorithm;
    });
  }

  void _onChangeTxt(String txt) {
    setState(() {
      _txt = txt;
    });
    _shouldShowClearBtn(txt);
  }

  void _shouldShowClearBtn(String txt) {
    if (txt.isEmpty && _clearBtnShowed) {
      setState(() {
        _clearBtnShowed = false;
      });
    } else if (txt.isNotEmpty && !_clearBtnShowed) {
      setState(() {
        _clearBtnShowed = true;
      });
    }
  }

  void _clearTxt() {
    _txtController.clear();
    setState(() {
      _clearBtnShowed = false;
    });
  }

  Future<void> _copyToClipboard() async {
    if (result.trim().isEmpty) {
      _notify('Select algorithm and enter the text you want to encrypt');

      return;
    }

    try {
      final data = ClipboardData(text: result);
      await Clipboard.setData(data);
      FocusManager.instance.primaryFocus?.unfocus();
      _notify('Copied to clipboard');
    } catch (err) {
      _notify('Failed to copy');
    }
  }

  void _notify(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12.0),
        content: Text(msg),
      ),
    );
  }

  String get result {
    if (_algorithm == null || _txt.trim().isEmpty) {
      return '';
    }

    final bytes = utf8.encode(_txt.trim());
    Digest? digest;

    switch (_algorithm!) {
      case Algorithm.sha1:
        digest = sha1.convert(bytes);
        break;
      case Algorithm.sha224:
        digest = sha224.convert(bytes);
        break;
      case Algorithm.sha256:
        digest = sha256.convert(bytes);
        break;
      case Algorithm.sha384:
        digest = sha384.convert(bytes);
        break;
      case Algorithm.sha512:
        digest = sha512.convert(bytes);
        break;
      case Algorithm.sha512_224:
        digest = sha512224.convert(bytes);
        break;
      case Algorithm.sha512_256:
        digest = sha512256.convert(bytes);
        break;
      case Algorithm.md5:
        digest = md5.convert(bytes);
        break;
    }

    return digest.toString();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encryptor'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<Algorithm>(
                value: _algorithm,
                onChanged: _onChangeAlgorithm,
                isExpanded: true,
                isDense: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: Algorithm.values
                    .map((v) => DropdownMenuItem<Algorithm>(
                          value: v,
                          child: Text(v.txt),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _txtController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _clearBtnShowed ? 1.0 : 0.0,
                    child: IconButton(
                      onPressed: _clearTxt,
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.black54.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                maxLines: 1,
                onChanged: _onChangeTxt,
              ),
              const SizedBox(height: 20.0),
              Container(
                height: 170.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 12.0,
                ),
                child: Text(
                  result,
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                height: 42.0,
                child: TextButton(
                  onPressed: _copyToClipboard,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Theme.of(context).primaryColor,
                    ),
                  ),
                  child: const Text(
                    'Copy',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum Algorithm {
  sha1('SHA-1'),
  sha224('SHA-224'),
  sha256('SHA-256'),
  sha384('SHA-384'),
  sha512('SHA-512'),
  sha512_224('SHA-512/224'),
  sha512_256('SHA-512/256'),
  md5('MD5');

  const Algorithm(this.txt);

  final String txt;
}
