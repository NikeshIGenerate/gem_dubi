import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/alerts/confirmer.dart';
import 'package:gem_dubi/common/utils/futures.dart';
import 'package:gem_dubi/common/utils/validator.dart';
import 'package:gem_dubi/common/widgets/avatar_image.dart';
import 'package:gem_dubi/common/widgets/loading_button.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/guest_user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../common/utils/app_router.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, required this.user});

  final GuestUser user;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final firstNameController = TextEditingController(text: widget.user.firstName);
  late final lastNameController = TextEditingController(text: widget.user.lastName);
  late final emailController = TextEditingController(text: widget.user.email);
  late final instagramController = TextEditingController(
    text: widget.user.instagramId ?? '',
  );
  final phoneController = PhoneController(
    const PhoneNumber(isoCode: IsoCode.AE, nsn: ''),
  );

  File? image;

  final formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    try {
      phoneController.value = PhoneNumber.parse(widget.user.phone ?? '');
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Edit profile')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            AvatarImage(
              image: widget.user.image,
              file: image,
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              onTap: () async {
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                setState(() {
                  if (image != null) this.image = File(image.path);
                });
              },
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'First Name',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Last Name',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    validator: CustomInputValidator(isRequired: true),
                    controller: firstNameController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: lastNameController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, bottom: 6),
              child: Text(
                'Email',
                style: theme.textTheme.titleSmall,
              ),
            ),
            TextFormField(
              readOnly: true,
              validator: CustomInputValidator(isRequired: true, email: true),
              controller: emailController,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                'Whatsapp',
                style: theme.textTheme.titleSmall,
              ),
            ),
            PhoneFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (phoneNumber) {
                if (phoneNumber == null) 'Missing phone number';

                return phoneController.value!.isValid() ? null : 'Invalid phone number';
              },
              textInputAction: TextInputAction.next,
              controller: phoneController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: theme.inputDecorationTheme.border,
                isDense: theme.inputDecorationTheme.isDense,
              ),
              countryCodeStyle: TextStyle(color: Colors.white),
              countrySelectorNavigator: const CountrySelectorNavigator.searchDelegate(
                favorites: [
                  IsoCode.AE,
                  IsoCode.US,
                  IsoCode.EG,
                  IsoCode.ID,
                  IsoCode.RU,
                  IsoCode.UA,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, bottom: 6),
              child: Text(
                'Instagram',
                style: theme.textTheme.titleSmall,
              ),
            ),
            TextFormField(
              validator: CustomInputValidator(isRequired: true),
              controller: instagramController,
              decoration: const InputDecoration(
                hintText: 'userId',
                hintStyle: TextStyle(color: Colors.grey),
                prefixText: '@',
                prefixStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 30),

            // ElevatedButton(
            //   onPressed: () {
            //     if (!formKey.currentState!.validate()) return;
            //
            //     ref.read(loginProviderRef).updateProfile(
            //           email: emailController.text,
            //           firstName: firstNameController.text,
            //           phone: phoneController.value!.international,
            //           lastName: lastNameController.text,
            //         );
            //   },
            //   child: const Text('SUBMIT'),
            // ),
            LoadingButton(
              isLoading: loading,
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                setState(() {
                  loading = true;
                });

                ref
                    .read(loginProviderRef)
                    .updateProfile(
                      email: emailController.text,
                      firstName: firstNameController.text,
                      phone: phoneController.value!.international,
                      lastName: lastNameController.text,
                      instagram: instagramController.text,
                      image: image,
                    )
                    .then((value) => router.pop())
                    .onFinally(() => setState(() => loading = false));
              },
              label: 'Submit',
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    showConfirmBottomSheet(
                      title: 'Delete account',
                      message: "Are you sure. this action can't be reversed back",
                      onDelete: () {
                        ref.read(loginProviderRef).deleteAccount();
                      },
                    );
                  },
                  child: const Text('Delete my account'),
                ),
              ],
            ),
            // const Divider(),
            // Text(
            //   'Billing details',
            //   style: theme.textTheme.titleMedium,
            // ),
            // const SizedBox(height: 10),
            // Row(
            //   children: [
            //     const SizedBox(width: 10),
            //     Expanded(
            //       child: Text(
            //         'Country',
            //         style: theme.textTheme.titleSmall,
            //       ),
            //     ),
            //     const SizedBox(width: 10),
            //     Expanded(
            //       child: Text(
            //         'City',
            //         style: theme.textTheme.titleSmall,
            //       ),
            //     ),
            //   ],
            // ),
            // Row(
            //   children: [
            //     Expanded(child: TextFormField()),
            //     const SizedBox(width: 10),
            //     Expanded(child: TextFormField()),
            //   ],
            // ),
            // const SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10, left: 10),
            //   child: Text(
            //     'Address',
            //     style: theme.textTheme.titleSmall,
            //   ),
            // ),
            // TextFormField(),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10, left: 10),
            //   child: Text(
            //     'Postal code',
            //     style: theme.textTheme.titleSmall,
            //   ),
            // ),
            // FractionallySizedBox(
            //   alignment: Alignment.centerLeft,
            //   widthFactor: 0.5,
            //   child: TextFormField(),
            // ),
          ],
        ),
      ),
    );
  }
}
