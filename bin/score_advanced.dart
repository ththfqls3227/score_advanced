import 'dart:io';

//점수 클래스
class Score {
  int mark;
  Score(this.mark);

  void showInfo() => print('점수: $mark점');
}

//학생 점수 클래스
class StudentScore extends Score {
  String name;
  StudentScore(this.name, super.mark);

  @override
  void showInfo() => print('이름: $name, 점수: $mark점');
}

List<StudentScore> students = [];

//파일로부터 데이터 읽어오기 기능
void loadStudentData(String filePath) {
  try {
    final file = File(filePath);
    final lines = file.readAsLinesSync();

    for (var line in lines) {
      final parts = line.split(',');
      if (parts.length != 2) throw FormatException('잘못된 데이터 형식: $line');

      String name = parts[0].trim();   
      int score = int.parse(parts[1].trim());

      students.add(StudentScore(name, score));
    }
  } catch (e) {
    print("학생 데이터를 불러오는 데 실패했습니다: $e");
    exit(1);
  }
}

// 프로그램 종료 후, 결과를 파일에 저장하는 기능
void saveResults(String filePath, String content) {
  try {
    final file = File(filePath);
    file.writeAsStringSync(content);
    print("저장이 완료되었습니다.");
  } catch (e) {
    print("저장에 실패했습니다: $e");
  }
}

void main() {
  loadStudentData("students.txt");

  for (var s in students) {
    s.showInfo();
  }

  String selectedName = "";

  while (true) {
    print("어떤 학생의 통계를 확인하시겠습니까?");
    print("1: 홍길동, 2: 김철수 중 하나의 번호를 입력하세요.");
    //print("(홍길동 / 김철수 중 하나를 입력하세요)"); - Dart는 입력을 UTF-8로 해석하려고 해서 한글로 비교 불가.

    final line = stdin.readLineSync();  
    if (line == null) {
      print("입력을 읽을 수 없습니다. 다시 입력해주세요.");
      continue;
    }

    final input = line.trim(); 
    
    //print("DEBUG: '$input'  length: ${input.length}  codeUnits: ${input.codeUnits}");

    //if (input == "홍길동" || input == "김철수") {
      //selectedName = input;
    if (input == "1") {
      selectedName = "홍길동";
      break;
    } else if (input == "2") {
      selectedName = "김철수";
      break;
    } else {
      print("잘못된 입력입니다. 다시 입력해주세요.");
    }
  }

  int sum = 0;
  int count = 0;

  for (var s in students) {
    if (s.name == selectedName) {
      sum += s.mark;
      count++;
    }
  }

  if (count == 0) {
    print("해당 학생의 데이터를 찾을 수 없습니다.");
    exit(1);
  }

  int average = (sum / count).round();

  final resultLine = "이름: $selectedName, 점수: $average점";

  print(resultLine);

  saveResults("result.txt", resultLine);
}
