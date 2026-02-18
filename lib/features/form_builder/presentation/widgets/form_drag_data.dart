class SectionDragData {
  final String sectionId;
  final int index;

  SectionDragData({required this.sectionId, required this.index});
}

class QuestionDragData {
  final String sectionId;
  final String questionId;
  final int index;

  QuestionDragData({
    required this.sectionId,
    required this.questionId,
    required this.index,
  });
}
