library flutter_net_promoter_score;

import 'package:flutter/material.dart';
import 'package:flutter_net_promoter_score/model/nps_survey_texts.dart';
import 'package:flutter_net_promoter_score/widgets/nps_feedback_widget.dart';
import 'package:flutter_net_promoter_score/widgets/nps_select_score_widget.dart';
import 'package:flutter_net_promoter_score/widgets/nps_thank_you_widget.dart';
import 'package:flutter_net_promoter_score/model/promoter_type.dart';
import 'model/net_promoter_score_result.dart';
import 'model/nps_survey_page.dart';

/// Show a modal Net Promoter Score as a material design bottom sheet.
Future<T> showNetPromoterScore<T>({
  @required BuildContext context,
  ThemeData theme,
  VoidCallback onClosePressed,
  Function(int newScore) onScoreChanged,
  Function(String newFeedback) onFeedbackChanged,
  Function(NetPromoterScoreResult result) onSurveyCompleted,
  NpsSurveyTexts texts = const NpsSurveyTexts(),
  Widget thankYouIcon,
}) {
  assert(texts != null);

  bool currentlyShowingSurvey = true;

  Future<T> future = showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return FlutterNetPromoterScore(
        onClosePressed: () {
          Navigator.pop(context);
          if (onClosePressed != null) {
            onClosePressed();
          }
        },
        onSurveyCompleted: (NetPromoterScoreResult result) {
          // call survey completion block
          if (onSurveyCompleted != null) {
            onSurveyCompleted(result);
          }

          // Dismiss after delay
          Future.delayed(
            const Duration(milliseconds: 2000),
            () {
              // Check if the user didn't dismiss the modal view manually by him self
              if (currentlyShowingSurvey) {
                Navigator.pop(context);
              }
            },
          );
        },
        onScoreChanged: onScoreChanged,
        onFeedbackChanged: onFeedbackChanged,
        texts: texts,
        theme: theme == null ? Theme.of(context) : theme,
        thankYouIcon: thankYouIcon,
      );
    },
  );

  future.then((value) {
    currentlyShowingSurvey = false;
  });

  return future;
}

class FlutterNetPromoterScore extends StatefulWidget {
  final NpsSurveyTexts texts;
  final VoidCallback onClosePressed;
  final void Function(NetPromoterScoreResult result) onSurveyCompleted;
  final Function(int newScore) onScoreChanged;
  final Function(String newFeedback) onFeedbackChanged;
  final ThemeData theme;
  final Widget thankYouIcon;

  FlutterNetPromoterScore({
    this.onSurveyCompleted,
    this.onClosePressed,
    this.onScoreChanged,
    this.onFeedbackChanged,
    this.theme,
    this.texts = const NpsSurveyTexts(),
    this.thankYouIcon,
  }) : assert(texts != null);

  @override
  FlutterNetPromoterScoreState createState() => FlutterNetPromoterScoreState();
}

class FlutterNetPromoterScoreState extends State<FlutterNetPromoterScore> {
  int _currentScore;
  String _currentFeedbackText = "";

  NpsSurveyPage _currentPage = NpsSurveyPage.score;
  List<Widget Function()> _pageBuilders = List<Widget Function()>();

  @override
  void initState() {
    super.initState();
    _setupPageBuilders();
    _currentPage = NpsSurveyPage.score;
  }

  void _setupPageBuilders() {
    _pageBuilders.add(_npsSelectScoreWidgetBuilder);
    _pageBuilders.add(_npsFeedbackWidgetBuilder);
    _pageBuilders.add(_npsThankYouWidgetBuilder);
  }

  Widget _npsThankYouWidgetBuilder() {
    return NpsThankYouWidget(
      texts: this.widget.texts.thankYouPageTexts,
      thankYouIcon: this.widget.thankYouIcon,
    );
  }

  Widget _npsFeedbackWidgetBuilder() {
    return NpsFeedbackWidget(
      onEditScoreButtonPressed: () {
        setState(() => _currentPage = NpsSurveyPage.score);
      },
      onSendButtonPressed: () {
        setState(() => _currentPage = NpsSurveyPage.thankYou);

        _finilizeResult();
      },
      onFeedbackTextChanged: (String feedbackText) {
        _currentFeedbackText = feedbackText;
        if (this.widget.onFeedbackChanged != null) {
          this.widget.onFeedbackChanged(feedbackText);
        }
      },
      onClosePressed: () {
        if (this.widget.onClosePressed != null) {
          this.widget.onClosePressed();
        }
      },
      feedbackText: _currentFeedbackText,
      texts: this.widget.texts.feedbackPageTexts,
      promoterType: _currentScore.toPromoterType(),
    );
  }

  Widget _npsSelectScoreWidgetBuilder() {
    return NpsSelectScoreWidget(
      onSendButtonPressed: () {
        setState(() => _currentPage = NpsSurveyPage.feedback);
      },
      onScoreChanged: (int score) {
        _currentScore = score;
        if (this.widget.onScoreChanged != null) {
          this.widget.onScoreChanged(score);
        }
      },
      onClosePressed: () {
        if (this.widget.onClosePressed != null) {
          this.widget.onClosePressed();
        }
      },
      score: _currentScore,
      texts: this.widget.texts.selectScorePageTexts,
    );
  }

  void _finilizeResult() {
    if (this.widget.onSurveyCompleted != null) {
      NetPromoterScoreResult finalResult = NetPromoterScoreResult();
      finalResult.score = _currentScore;
      finalResult.feedback = _currentFeedbackText;
      finalResult.promoterType = _currentScore.toPromoterType();

      this.widget.onSurveyCompleted(finalResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: this.widget.theme == null ? Theme.of(context) : this.widget.theme,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 0,
              right: 0),
          child: AnimatedSwitcher(
            child: _pageBuilders[_currentPage.index](),
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final outAnimation =
                  Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                      .animate(animation);

              return SlideTransition(
                position: outAnimation,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Card(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 680,
                      ),
                      child: child,
                      padding: EdgeInsets.all(10),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.only(right: 5, left: 5, bottom: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
