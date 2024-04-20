import 'package:flutter/material.dart';

class ToggleDropdown extends StatefulWidget {
  @override
  _ToggleDropdownState createState() => _ToggleDropdownState();
}

class _ToggleDropdownState extends State<ToggleDropdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _toggleDropdown,
            child: const Text(
              "Destinaton",
              // _isOpen ? 'Close' : 'Open',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          SizeTransition(
            axis: Axis.vertical,
            sizeFactor: _animation,
            axisAlignment: 1.0,
            child: Container(
              alignment: Alignment.center,
              width: 200,
              height: 100,
              color: Colors.grey,
              child: const Center(
                child: SingleChildScrollView(
                  child: Text(
                    'This is a test content so for testing purpose am trying to input multpiple texts so shashank is a bad boy because he is reading this text',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
