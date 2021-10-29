class ActiveSymbolData {
  int allowForwardStarting;
  String displayName;
  int exchangeIsOpen;
  int isTradingSuspended;
  String market;
  String marketDisplayName;
  num pip;
  String submarket;
  String submarketDisplayName;
  String symbol;
  String symbolType;

  ActiveSymbolData(
      [this.allowForwardStarting = 0,
      this.displayName = "NA",
      this.exchangeIsOpen = 0,
      this.isTradingSuspended = 0,
      this.market = "NA",
      this.marketDisplayName = "NA",
      this.pip = 0,
      this.submarket = "NA",
      this.submarketDisplayName = "NA",
      this.symbol = "NA",
      this.symbolType = "NA"]) {
    // id = new_id;
    // firstName = first_name;
    // lastName = last_name;
    // userName = user_name;
    // lastSeenTime = last_seen_time;
    // avatar = new_avatar;
    // status = new_status;
    // messages = new_messages;
  }
}
