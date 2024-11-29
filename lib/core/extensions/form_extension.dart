import 'package:flutter/material.dart';

extension FormExtension on GlobalKey<FormState> {
  bool get validateFields => currentState!.validate();
}
