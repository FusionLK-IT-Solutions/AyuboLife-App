import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ayubolife/bloc/profile/profile_bloc.dart';
import 'package:ayubolife/bloc/profile/profile_event.dart';
import 'package:ayubolife/bloc/profile/profile_state.dart';
import 'package:ayubolife/presentation/widgets/common/loading_widget.dart';
import 'package:ayubolife/presentation/widgets/common/error_widget.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        context.read<ProfileBloc>().add(UpdateProfileImage(imageFile: _imageFile!));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _saveProfile() {
    context.read<ProfileBloc>().add(UpdateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      weight: _weightController.text.isNotEmpty ? double.tryParse(_weightController.text) : null,
      height: _heightController.text.isNotEmpty ? double.tryParse(_heightController.text) : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is ProfileLoaded && !state.isUploadingImage) {
            // Update controllers when profile is loaded
            _firstNameController.text = state.user.firstName;
            _lastNameController.text = state.user.lastName;
            _weightController.text = state.user.weight?.toString() ?? '';
            _heightController.text = state.user.height?.toString() ?? '';
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return LoadingWidget();
          } else if (state is ProfileError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<ProfileBloc>().add(LoadProfile()),
            );
          } else if (state is ProfileLoaded) {
            return _buildProfileForm(context, state);
          }
          return LoadingWidget();
        },
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context, ProfileLoaded state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : state.user.photoURL?.isNotEmpty == true
                            ? NetworkImage(state.user.photoURL!)
                            : null,
                    backgroundColor: Colors.blue,
                    child: _imageFile == null && state.user.photoURL?.isEmpty != false
                        ? Icon(Icons.person, color: Colors.white, size: 50)
                        : null,
                  ),
                  if (state.isUploadingImage)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: state.isUploadingImage ? null : _pickImage,
              child: Text('Change Profile Picture'),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: 'Last Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _weightController,
            decoration: InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _heightController,
            decoration: InputDecoration(
              labelText: 'Height (cm)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state is ProfileUpdating ? null : _saveProfile,
              child: state is ProfileUpdating
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}