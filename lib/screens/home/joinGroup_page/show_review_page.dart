import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShowReviewPage extends StatefulWidget {
  ShowReviewPage(this.listReview, this.meanRating, this.countRating);

  final List listReview;
  final double meanRating;
  final int countRating;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShowReviewPage(listReview, meanRating, countRating);
  }
}

class _ShowReviewPage extends State {
  _ShowReviewPage(this.listReview, this.meanRating, this.countRating);

  final List listReview;
  final double meanRating;
  final int countRating;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        backgroundColor: Colors.transparent,elevation: 0,
      ),
      body: Column(
        children: [
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                      "คะแนนรีวิวเฉลี่ย : ${meanRating.toStringAsFixed(1)}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RatingBar.builder(
                    ignoreGestures: true,
                    allowHalfRating: true,
                    itemCount: 5,
                    initialRating: meanRating,
                    itemBuilder: (context, r) {
                      return Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      );
                    },
                    itemSize: 25, onRatingUpdate: (double value) {  },
                  ),
                ),
                Text("(${countRating.toString()})ratings")
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: listReview.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                    child: ListTile(
                      leading: Text("user id : ${listReview[index].userId}"),
                      title: Row(
                        children: [
                          RatingBar.builder(
                            ignoreGestures: true,
                            allowHalfRating: true,
                            itemCount: 5,
                            initialRating: listReview[index].rating,
                            itemBuilder: (context, r) {
                              return Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                              );
                            },
                            itemSize: 20, onRatingUpdate: (double value) {  },
                          ),
                          Text(
                            "(${listReview[index].rating})",
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${listReview[index].content}",
                            style: TextStyle(color: Colors.black),
                          ),
                          Text("${listReview[index].createDate}")
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}