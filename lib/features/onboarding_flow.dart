import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<String> _selectedInterests = [];
  String? _selectedRole;

  final List<String> _interests = ['Music', 'Video', 'Community'];

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    // Store selections locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('interests', _selectedInterests);
    await prefs.setString('role', _selectedRole ?? '');

    // Navigate to home
    Navigator.pushReplacementNamed(context, '/radartv');
  }

  bool _canContinue() {
    if (_currentPage == 0) {
      return _selectedInterests.isNotEmpty;
    } else {
      return _selectedRole != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildInterestsPage(),
          _buildRolePage(),
        ],
      ),
    );
  }

  Widget _buildInterestsPage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'What are you interested in?',
            style: TextStyle(color: Colors.white, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ..._interests.map((interest) => _buildInterestCard(interest)),
          const Spacer(),
          ElevatedButton(
            onPressed: _canContinue() ? _nextPage : null,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestCard(String interest) {
    final isSelected = _selectedInterests.contains(interest);
    return GestureDetector(
      onTap: () => _toggleInterest(interest),
      child: Card(
        elevation: 8,
        color: isSelected ? Colors.blue : Colors.grey[800],
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: 80,
          alignment: Alignment.center,
          child: Text(
            interest,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildRolePage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'What is your role?',
            style: TextStyle(color: Colors.white, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildRoleCard('Artist'),
          _buildRoleCard('Community User'),
          const Spacer(),
          ElevatedButton(
            onPressed: _canContinue() ? _nextPage : null,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(String role) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => _selectRole(role),
      child: Card(
        elevation: 8,
        color: isSelected ? Colors.blue : Colors.grey[800],
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: 80,
          alignment: Alignment.center,
          child: Text(
            role,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}