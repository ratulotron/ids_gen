import 'dart:html';

import 'dart:math';

makeCSV(data) {
  DateTime d = new DateTime.now();
  AnchorElement hiddenElement = document.createElement('a');
  hiddenElement.href = 'data:text/csv;charset=utf-8,' + Uri.encodeFull(data);
  hiddenElement.target = '_blank';
  hiddenElement.download = 'ids-${d.millisecond}.csv';
  hiddenElement.click();
  hiddenElement.remove();
  return;
}

generateFromStartEnd(start, end) {
  String result = "";
  start = int.parse(start.value);
  end = int.parse(end.value) + 1;

  for (var i = start; i < end; i++) {
    result += i.toString() + ", ";
  }
  return result;
}

generateDigits(digits, count) {
  String result = "";
  digits = int.parse(digits.value);
  count = int.parse(count.value);

  Random rnd = new Random();
  for (var c = 0; c < count; c++) {
    int i = rnd.nextInt(900000) + 100000;
    result += i.toString() + ", ";
  }
  return result;
}

void main() {
  var validationBox = querySelector('p.help');

  // Input boxes
  InputElement start = querySelector('#start');
  InputElement end = querySelector('#end');
  InputElement digits = querySelector('#digits');
  InputElement count = querySelector('#count');
  var firstCase = querySelector('.with-start-end');
  var secondCase = querySelector('.with-digits');

  // Buttons
  ButtonElement submitButton = querySelector('#submit');
  ButtonElement cancelButton = querySelector('#cancel');

  firstCase.addEventListener('input', (evt) {
    if (start.value.isNotEmpty || end.value.isNotEmpty) {
      count.disabled = true;
      digits.disabled = true;
    } else {
      count.disabled = false;
      digits.disabled = false;
    }

    if ((start.value.isNotEmpty && (int.tryParse(start.value) == null)) ||
        (end.value.isNotEmpty && (int.tryParse(end.value) == null))) {
      validationBox.text = "Only positive decimal numbers is allowed";
      submitButton.disabled = true;
    } else if (start.value.isNotEmpty && end.value.isNotEmpty) {
      var s = int.tryParse(start.value);
      var e = int.tryParse(end.value);
        if (e < s || e-s > 2000 || s > 999999) {
      validationBox.text = "End value must be below 6 digits and max difference between start and end is 2000";
      submitButton.disabled = true;
    }
    } else {
      validationBox.text = "";
      submitButton.disabled = false;
    }
  });

  secondCase.addEventListener('input', (evt) {
    if (digits.value.isNotEmpty || count.value.isNotEmpty) {
      start.disabled = true;
      end.disabled = true;
    } else {
      start.disabled = false;
      end.disabled = false;
    }
    if ((digits.value.isNotEmpty && (int.tryParse(digits.value) == null)) ||
        (count.value.isNotEmpty && (int.tryParse(count.value) == null))) {
      validationBox.text = "Only positive decimal numbers is allowed";
      submitButton.disabled = true;
    } else if ((count.value.isNotEmpty &&
            (int.tryParse(count.value) > 2000)) ||
        (digits.value.isNotEmpty && (int.tryParse(digits.value) > 6))) {
      validationBox.text = "Max no. of ids is 2000 and max digits allowed is 6";
      submitButton.disabled = true;
    } else {
      validationBox.text = "";
      submitButton.disabled = false;
    }
  });

  submitButton.addEventListener('click', (evt) {
    if ((start.value.isEmpty || end.value.isEmpty) && digits.value.isEmpty) {
      validationBox.text = "Can't submit empty values";
      return;
    }

    String idList;
    if (digits.value.isNotEmpty) {
      idList = generateDigits(digits, count);
    } else {
      idList = generateFromStartEnd(start, end);
    }
    makeCSV(idList);
    return;
  });

  cancelButton.addEventListener('click', (evt) {
    dynamic inputElements = document.getElementsByTagName("input");
    for (var i in inputElements) {
      i.disabled = false;
      i.value = "";
    }
    return;
  });
}
