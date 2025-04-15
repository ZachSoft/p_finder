import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:p_finder/constants/Constants.dart';


class PropertyCarousel extends StatefulWidget {
  final List<String> imageBase64List;
  const PropertyCarousel({required this.imageBase64List});

  @override
  _PropertyCarouselState createState() => _PropertyCarouselState();
}

class _PropertyCarouselState extends State<PropertyCarousel> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageBase64List.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              return widget.imageBase64List[index].isNotEmpty
                  ? Image.memory(
                      base64Decode(widget.imageBase64List[index]),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: Center(
                          child: Icon(Icons.image,
                              size: 80, color: Colors.grey[700])),
                    );
            },
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imageBase64List.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: currentIndex == index ? 12 : 8,
              height: currentIndex == index ? 12 : 8,
              decoration: BoxDecoration(
                color: currentIndex == index ? AppColors.blue : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        )
      ],
    );
  }
}
