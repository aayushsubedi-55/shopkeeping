extension Capitalize on String {
  String capitalize({bool allWords = true}) {
    if (isEmpty) {
      return this;
    }
    if (allWords) {
      final List<String> words = split(' ');
      final List<String> capitalized = <String>[];
      for (var w in words) {
        capitalized.add(w.capitalize(allWords: false));
      }
      return capitalized.join(" ");
    } else {
      return substring(0, 1).toUpperCase() + substring(1).toLowerCase();
    }
  }

  // String removeUnderScore(){

  //   if(isEmpty){
  //     return this;
  //   }
  // return split("")
  // }
}

extension AddSpace on String {
  String addSpace() {
    if (isEmpty) {
      return this;
    }

    final List<String> word = split(RegExp(r"(?=[A-Z])"));

    return word.join(" ");
  }
}

// extension NepaliConversion on String {
//   String toNepali() {
//     if (CheckLocal.isEnglish()) {
//       return this;
//     }

//     return NepaliUnicode.convert(this);
//   }

//   String toEnglish() {
//     if (CheckLocal.isEnglish()) {
//       return this;
//     }

//     return NepaliUnicode.convert(this);
//   }
// }

// extension Localized on MultiLanguage {
//   String localize() {
//     if (CheckLocal.isEnglish()) {
//       return en ?? "";
//     }

//     return ne ?? "";
//   }
// }
