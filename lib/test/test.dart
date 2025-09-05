import 'package:flutter/material.dart';

class SlidePages extends StatefulWidget {
  const SlidePages({super.key});

  @override
  State<SlidePages> createState() => _SlidePagesState();
}

class _SlidePagesState extends State<SlidePages> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_totalPages, (index) {
            final isActive = _currentPage == index;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: TextButton(
                onPressed: () {
                  _controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  "P${index + 1}",
                  style: TextStyle(
                    fontSize: isActive ? 18 : 16,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            );
          }),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: const [
          Center(
            child: Text("Page 1",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Text("Page 2",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Text("Page 3",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SlidePages(),
  ));
}
