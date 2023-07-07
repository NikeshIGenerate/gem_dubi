import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/utils/state_theme.dart';
import 'package:gem_dubi/common/utils/validator.dart';
import 'package:gem_dubi/src/events/controllers/events_controller.dart';
import 'package:gem_dubi/src/events/entities/listing.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:phone_form_field/phone_form_field.dart';

class EventBookingScreen extends ConsumerWidget with ConsumerTheme {
  EventBookingScreen({
    super.key,
    required this.guestCount,
    required this.listing,
  });

  final int guestCount;
  final EventListing listing;

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final notesController = TextEditingController();
  late final guestsController = TextEditingController(text: guestCount.toString());
  final init = [false];

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!init[0]) {
      final loginProvider = ref.read(loginProviderRef);

      nameController.text = loginProvider.user.displayName.split(' ').first;
      lastNameController.text = loginProvider.user.displayName.split(' ').last;
      emailController.text = loginProvider.user.email;
      // phoneController.text = loginProvider.user.displayName.split(' ').last;

      init[0] = true;
    }

    super.build(context, ref);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Book a ticket'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: CustomInputValidator(isRequired: true, minLength: 3),
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    validator: CustomInputValidator(isRequired: true, minLength: 3),
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              validator: CustomInputValidator(isRequired: true, email: true),
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            // TextFormField(
            //   controller: phoneController,
            //   decoration: const InputDecoration(labelText: 'Phone'),
            // ),
            PhoneFormField(
              decoration: InputDecoration(
                border: theme.inputDecorationTheme.border,
                isDense: theme.inputDecorationTheme.isDense,
                labelText: 'Phone Number',
              ),
              countrySelectorNavigator: const CountrySelectorNavigator.searchDelegate(
                favorites: [
                  IsoCode.US,
                  IsoCode.EG,
                  IsoCode.ID,
                  IsoCode.RU,
                  IsoCode.UA,
                ],
              ),
            ),

            const SizedBox(height: 10),
            TextFormField(
              controller: guestsController,
              keyboardType: TextInputType.number,
              validator: CustomInputValidator(isRequired: true, isInt: true),
              decoration: const InputDecoration(labelText: 'Guests'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLines: 3,
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                ref.read(eventControllerRef).bookATicket(
                      listing: listing,
                      user: ref.read(loginProviderRef).user,
                      eventDate: DateTime.now(),
                    );
              },
              child: const Text('Complete booking'),
            ),
          ],
        ),
      ),
    );
  }
}
