class NpsSelectScorePageTexts {
  final String surveyQuestionText;
  final String detractorScoreLabelText;
  final String promoterScoreLabelText;
  final String submitButtonText;

  const NpsSelectScorePageTexts({
    this.surveyQuestionText =
        "How likely are you to recommaned this app to a friend or colleague?",
    this.detractorScoreLabelText = "Not likely",
    this.promoterScoreLabelText = "Very likely",
    this.submitButtonText = "SEND",
  });
}

class NpsFeedbackPageTexts {
  final String promoterMainLabelText;
  final String promoterFeedbackTextFieldPlaceholderText;
  final String passiveMainLabelText;
  final String passiveFeedbackTextFieldPlaceholderText;
  final String detractorMainLabelText;
  final String detractorFeedbackTextFieldPlaceholderText;
  final String editScoreButtonText;
  final String submitButtonText;

  const NpsFeedbackPageTexts({
    this.promoterMainLabelText = "Thanks for your feedback!",
    this.promoterFeedbackTextFieldPlaceholderText =
        "Let us know if there's anything you want to share with us",
    this.passiveMainLabelText = "Thanks for your feedback!",
    this.passiveFeedbackTextFieldPlaceholderText =
        "Let us know how we can make the app better",
    this.detractorMainLabelText = "We appreciate your feedback",
    this.detractorFeedbackTextFieldPlaceholderText =
        "Let us know how we can make the app better",
    this.editScoreButtonText = "Edit Score",
    this.submitButtonText = "Done",
  });
}

class NpsThankYouPageTexts {
  final String thankYouLabelText;

  const NpsThankYouPageTexts({
    this.thankYouLabelText = "Thanks for your feedback!",
  });
}

class NpsSurveyTexts {
  final NpsSelectScorePageTexts selectScorePageTexts;
  final NpsFeedbackPageTexts feedbackPageTexts;
  final NpsThankYouPageTexts thankYouPageTexts;

  const NpsSurveyTexts({
    this.selectScorePageTexts = const NpsSelectScorePageTexts(),
    this.feedbackPageTexts = const NpsFeedbackPageTexts(),
    this.thankYouPageTexts = const NpsThankYouPageTexts(),
  });
}
