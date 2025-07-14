import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_application/core/colors.dart';
import 'package:instagram_application/views/completeProfile/cubit/editprofile_cubit.dart';
import 'package:instagram_application/views/completeProfile/cubit/editprofile_state.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final websiteController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = TextEditingController();

  bool isInitialized = false;

  void _initializeControllers(ProfileLoaded state) {
    if (!isInitialized) {
      nameController.text = state.user.name;
      usernameController.text = state.user.username;
      bioController.text = state.user.bio;
      phoneController.text = state.user.phone;
      genderController.text = state.user.gender;
      isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadUserProfile(widget.uid);
  }

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          Navigator.pushReplacementNamed(context, 'mainLayout');
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          backgroundColor: colorScheme.background,
          iconTheme: theme.iconTheme,
          title: Text(
            'editProfile'.tr(),
            style: theme.textTheme.titleLarge,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final cubit = context.read<ProfileCubit>();
                final state = cubit.state;
                if (state is ProfileLoaded) {
                  final updatedUser = state.user.copyWith(
                    name: nameController.text,
                    username: usernameController.text,
                    bio: bioController.text,
                    phone: phoneController.text,
                    gender: genderController.text,
                  );
                  await cubit.updateProfile(updatedUser);
                }
              },
              child: Text(
                'done'.tr(),
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final cubit = context.read<ProfileCubit>();

            final profileState = state is ProfileLoaded
                ? state
                : cubit.state is ProfileLoaded
                    ? (cubit.state as ProfileLoaded)
                    : null;

            if (state is ProfileLoading || profileState == null) {
              return const Center(child: CircularProgressIndicator());
            }

            _initializeControllers(profileState);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InkWell(
                    onTap: cubit.pickProfileImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: cubit.profileImage != null
                          ? FileImage(cubit.profileImage!)
                          : profileState.user.imageUrl.isNotEmpty
                              ? NetworkImage(profileState.user.imageUrl)
                              : null,
                      child: (cubit.profileImage == null &&
                              profileState.user.imageUrl.isEmpty)
                          ? Icon(Icons.person,
                              size: 40, color: colorScheme.onBackground)
                          : null,
                    ),
                  ),
                  TextButton(
                    onPressed: cubit.pickProfileImage,
                    child: Text(
                      'changeProfilePhoto'.tr(),
                      style: TextStyle(color: colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildField('name'.tr(), nameController),
                  buildField('username'.tr(), usernameController),
                  buildField('website'.tr(), websiteController),
                  buildField('bio'.tr(), bioController, maxLines: 2),
                  const SizedBox(height: 20),
                  Text("privateInfo".tr(),
                      style: theme.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                  TextFormField(
                    initialValue: profileState.user.email,
                    readOnly: true,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'email'.tr(),
                      labelStyle: theme.textTheme.labelMedium,
                    ),
                  ),
                  buildField('phone'.tr(), phoneController),
                  buildField('gender'.tr(), genderController),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.labelMedium,
      ),
    );
  }
}
