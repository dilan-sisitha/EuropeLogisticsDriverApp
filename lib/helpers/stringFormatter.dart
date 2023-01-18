class StringFormatter {
  formatAddressForSearch(String text) {
    return text.replaceAll('\r', '').replaceAll('\n', ' ').toLowerCase();
  }
}
