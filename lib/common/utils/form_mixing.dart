import 'package:flutter/material.dart';

mixin FormMixin {
  final formKey = GlobalKey<FormState>();

  bool get validFormData => formKey.currentState!.validate();
}
