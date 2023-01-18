class RegexSearch {
  Map countriesRegex = {
    "AUSTRIA": 'r"\d{4}"',
    "BELGIUM": "\d{4}",
    "BULGARIA": "\d{4}",
    "CYPRUS": "\d{4}",
    "CZECH REPUBLIC": "[0-9]{3} [0-9]{2}|[0-9]{5}",
    "GERMANY": "\d{5}",
    "DENMARK": "\d{4}",
    "ESTONIA": "\d{5}",
    "SPAIN": "\d{5}",
    "FINLAND": "\d{5}",
    "FRANCE": 'r"\\d{5}"',
    "UNITED KINGDOM":
        "([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z])))) [0-9][A-Za-z]{2})",
    "GREECE": "(\d{3}) \d{2}|\d{5}",
    "HUNGARY": "\d{4}",
    "CROATIA": "\d{5}",
    "IE": "STRNG_LTN_EXT_255",
    "IT": "\d{5}",
    "LT": "((?:LT)[\-])?(\d{5})",
    "LU": "((?:L)[\-])?(\d{4})",
    "LV": "[L]{1}[V]{1}[-]([0-9]){4}",
    "MT":
        "[A-Z]{3} [0-9]{4}|[A-Z]{2}[0-9]{2}|[A-Z]{2} [0-9]{2}|[A-Z]{3}[0-9]{4}|[A-Z]{3}[0-9]{2}|[A-Z]{3} [0-9]{2}",
    "NL": "[0-9]{4} [A-Z]{2}|[0-9]{4}[A-Z]{2}",
    "PL": "[0-9]{2}[-]([0-9]){3}",
    "PT": "\d{4}((-)\d{3})",
    "RO": "\d{6}",
    "SE": "(\d{3} \d{2})",
    "SI": "\d{4}",
    "SK": "(\d{3} \d{2})|\d{5}",
    "NO": "\d{4}",
    "CH": "\d{4}",
    "LI": "\d{4}",
    "IM":
        "(IM)([0-9][0-9A-HJKPS-UW]?|[A-HK-Y][0-9][0-9ABEHMNPRV-Y]?) [0-9][ABD-HJLNP-UW-Z]{2}"
  };

  getPostCode(String address, String country) {
    RegExp regExp;

    switch (country) {
      case "AUSTRIA":
        {
          regExp = RegExp(
            r"\d{4}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "BELGIUM":
        {
          regExp = RegExp(
            r"\d{4}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "BULGARIA":
        {
          regExp = RegExp(
            r"\d{4}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "CYPRUS":
        {
          regExp = RegExp(
            r"\d{4}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "CZECH REPUBLIC":
        {
          regExp = RegExp(
            r"[0-9]{3} [0-9]{2}|[0-9]{5}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "GERMANY":
        {
          regExp = RegExp(
            r"\d{5}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "DENMARK":
        {
          regExp = RegExp(
            r"\d{4}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "ESTONIA":
        {
          regExp = RegExp(
            r"\d{5}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "SPAIN":
        {
          regExp = RegExp(
            r"\d{5}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "FINLAND":
        {
          regExp = RegExp(
            r"\d{5}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "FRANCE":
        {
          regExp = RegExp(
            r"\d{5}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "UNITED KINGDOM":
        {
          regExp = RegExp(
            r"([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z])))) [0-9][A-Za-z]{2})",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "GREECE":
        {
          regExp = RegExp(
            r"(\d{3}) \d{2}|\d{5}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "HUNGARY":
        {
          regExp = RegExp(
            r"\d{4}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "CROATIA":
        {
          regExp = RegExp(
            r"\d{5}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "IRELAND":
        {
          regExp = RegExp(
            r"STRNG_LTN_EXT_255",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "ITALY":
        {
          regExp = RegExp(
            r"\d{5}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "LITHUANIA":
        {
          regExp = RegExp(
            r"((?:LT)[\-])?(\d{5})",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "LUXEMBOURG":
        {
          regExp = RegExp(
            r"((?:L)[\-])?(\d{4})",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "LATVIA":
        {
          regExp = RegExp(
            r"[L]{1}[V]{1}[-]([0-9]){4}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "MALTA":
        {
          regExp = RegExp(
            r"[A-Z]{3} [0-9]{4}|[A-Z]{2}[0-9]{2}|[A-Z]{2} [0-9]{2}|[A-Z]{3}[0-9]{4}|[A-Z]{3}[0-9]{2}|[A-Z]{3} [0-9]{2}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "NETHERLANDS":
        {
          regExp = RegExp(
            r"[0-9]{4} [A-Z]{2}|[0-9]{4}[A-Z]{2}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "POLAND":
        {
          regExp = RegExp(
            r"[0-9]{2}[-]([0-9]){3}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "PORTUGAL":
        {
          regExp = RegExp(
            r"\d{4}((-)\d{3})",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "ROMANIA":
        {
          regExp = RegExp(
            r"\d{6}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "SWEDEN":
        {
          regExp = RegExp(
            r"(\d{3} \d{2})",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "SLOVENIA":
        {
          regExp = RegExp(
            r"\d{4}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "SLOVAKIA":
        {
          regExp = RegExp(
            r"(\d{3} \d{2})|\d{5}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "NORWAY":
        {
          regExp = RegExp(
            r"\d{4}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "SWITZERLAND":
        {
          regExp = RegExp(
            r"\d{4}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "LIECHTENSTEIN":
        {
          regExp = RegExp(
            r"\d{4}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      case "ISLE OF MAN":
        {
          regExp = RegExp(
            r"(IM)([0-9][0-9A-HJKPS-UW]?|[A-HK-Y][0-9][0-9ABEHMNPRV-Y]?) [0-9][ABD-HJLNP-UW-Z]{2}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;

      default:
        {
          regExp = RegExp(
            r"\d{5}",
            caseSensitive: false,
            multiLine: false,
          );
        }
        break;
    }

    var postCode = regExp.stringMatch(address).toString();
    if (postCode == 'null') {
      return 'N/A';
    }
    return postCode;
  }
}
