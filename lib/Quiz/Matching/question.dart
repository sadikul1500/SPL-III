class Question {
  String category = '';
  String imagePath = '';
  String ques = '';
  List<String> options = [];
  String correctAnswer = '';

  Question(this.category, this.imagePath, this.ques, this.options,
      this.correctAnswer);
}
