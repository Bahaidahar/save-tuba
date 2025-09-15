import 'package:flutter/material.dart';
import '../services/services.dart';
import '../repositories/repositories.dart';
import '../models/models.dart';

class ApiUsageExample extends StatefulWidget {
  const ApiUsageExample({super.key});

  @override
  State<ApiUsageExample> createState() => _ApiUsageExampleState();
}

class _ApiUsageExampleState extends State<ApiUsageExample> {
  final ApiRepository _apiRepository = ApiRepository();
  final AuthService _authService = AuthService.instance as AuthService;

  String _status = 'Ready';
  List<GradeLevelResponse> _gradeLevels = [];
  ProfileResponse? _profile;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isAuthenticated = await _authService.isAuthenticated();
    if (isAuthenticated) {
      _loadProfile();
      _loadGradeLevels();
    }
  }

  Future<void> _login() async {
    setState(() => _status = 'Logging in...');

    try {
      final result =
          await _authService.login('test@example.com', 'password123');

      if (result['success'] == true) {
        setState(() => _status = 'Login successful');
        _loadProfile();
        _loadGradeLevels();
      } else {
        setState(() => _status = 'Login failed: ${result['message']}');
      }
    } catch (e) {
      setState(() => _status = 'Login error: $e');
    }
  }

  Future<void> _guestLogin() async {
    setState(() => _status = 'Guest login...');

    try {
      final result = await _authService.guestLogin();

      if (result['success'] == true) {
        setState(() => _status = 'Guest login successful');
        _loadGradeLevels();
      } else {
        setState(() => _status = 'Guest login failed: ${result['message']}');
      }
    } catch (e) {
      setState(() => _status = 'Guest login error: $e');
    }
  }

  Future<void> _loadProfile() async {
    setState(() => _status = 'Loading profile...');

    try {
      final result = await _apiRepository.getMyProfile();

      if (result.success && result.data != null) {
        setState(() {
          _profile = result.data;
          _status = 'Profile loaded';
        });
      } else {
        setState(() => _status = 'Failed to load profile: ${result.message}');
      }
    } catch (e) {
      setState(() => _status = 'Profile error: $e');
    }
  }

  Future<void> _loadGradeLevels() async {
    setState(() => _status = 'Loading grade levels...');

    try {
      final result = await _apiRepository.getGradeLevels(language: 'en');

      if (result.success && result.data != null) {
        setState(() {
          _gradeLevels = result.data!.content;
          _status = 'Grade levels loaded: ${_gradeLevels.length} items';
        });
      } else {
        setState(
            () => _status = 'Failed to load grade levels: ${result.message}');
      }
    } catch (e) {
      setState(() => _status = 'Grade levels error: $e');
    }
  }

  Future<void> _logout() async {
    setState(() => _status = 'Logging out...');

    try {
      await _authService.logout();
      setState(() {
        _status = 'Logged out';
        _profile = null;
        _gradeLevels.clear();
      });
    } catch (e) {
      setState(() => _status = 'Logout error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Usage Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: $_status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _login,
                            child: const Text('Login'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _guestLogin,
                            child: const Text('Guest Login'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _logout,
                            child: const Text('Logout'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_profile != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                          'Name: ${_profile!.firstName} ${_profile!.lastName}'),
                      Text('Email: ${_profile!.email}'),
                      Text('Role: ${_profile!.role}'),
                      Text('Experience Points: ${_profile!.experiencePoints}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_gradeLevels.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grade Levels (${_gradeLevels.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ...(_gradeLevels.map((grade) => ListTile(
                            title: Text(grade.name),
                            subtitle: Text('Order: ${grade.displayOrder}'),
                            trailing: grade.isActive
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : const Icon(Icons.cancel, color: Colors.red),
                          ))),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}










