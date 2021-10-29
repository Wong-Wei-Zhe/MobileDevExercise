class UserData {
  int id;
  String firstName;
  String lastName;
  String userName;
  String lastSeenTime;
  String avatar;
  String status; //could be optional
  int messages; //could be optional

  UserData(
      [this.id = 0,
      this.firstName = "NA",
      this.lastName = "NA",
      this.userName = "NA",
      this.lastSeenTime = "NA",
      this.avatar = "NA",
      this.status = "NA",
      this.messages = 0]) {
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
