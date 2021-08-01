import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:olx_clone/widgets/custom_progress_bar.dart';

class BannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          color: Colors.cyan,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "CARS",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 45.0,
                            child: DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                              child: AnimatedTextKit(
                                repeatForever: true,
                                isRepeatingAnimation: true,
                                animatedTexts: [
                                  FadeAnimatedText(
                                    'Reach 20 Lakh+\nInterested Buyers',
                                    textAlign: TextAlign.center,
                                    duration: Duration(seconds: 2),
                                  ),
                                  FadeAnimatedText(
                                    'New way to\nBuy or Sell Cars',
                                    textAlign: TextAlign.center,
                                    duration: Duration(seconds: 2),
                                  ),
                                  FadeAnimatedText(
                                    'Over 1 Lakh\nCars to Buy',
                                    textAlign: TextAlign.center,
                                    duration: Duration(seconds: 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Neumorphic(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/olx-clone-8ab7a.appspot.com/o/banners%2Ficons8-car-100.png?alt=media&token=29204d16-f799-4d0a-b935-f6dd52ef34f0',
                          placeholder: (context, url) =>
                              buildCustomProgressIndicator(context),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: NeumorphicButton(
                          onPressed: () {},
                          style: NeumorphicStyle(color: Colors.white),
                          child: Text("Buy Car",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: NeumorphicButton(
                        onPressed: () {},
                        style: NeumorphicStyle(color: Colors.white),
                        child: Text("Sell Car",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
