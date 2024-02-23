import 'package:flutter/material.dart';

extension LoginFormExtension on GlobalKey<FormState> {
  bool get validateFields => currentState!.validate();
}
