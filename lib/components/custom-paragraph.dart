import 'package:flutter/material.dart';

class CustomParagraph extends StatelessWidget {
  CustomParagraph({this.title, this.ingredients, this.prepa, this.size});

  final String title;
  final String ingredients;
  final String prepa;
  final double size;

  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ingredients != null
                    ? ingredients
                        .split(';')
                        .map(
                          (ingredient) => Container(
                            padding: EdgeInsets.only(bottom:15, left:10),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.bubble_chart,
                                  color: Theme.of(context).accentColor,
                                  size: 12,
                                ),
                                SizedBox(width: 10),
                                Text(ingredient,
                                    style: TextStyle(color: Colors.black))
                              ],
                            ),
                          ),
                        )
                        .toList()
                    : []),
          ),
          SizedBox(height: 20),
          Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: prepa != null
                    ? prepa
                        .split(';')
                        .map(
                          (step) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Theme.of(context).accentColor,
                                      Color.fromRGBO(255, 206, 69, 1)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24),
                                  ),
                                ),
                                child: Text(
                                  'Étape ' + (index++).toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                step,
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        )
                        .toList()
                    : []),
          ),
        ],
      ),
    );
  }
}
