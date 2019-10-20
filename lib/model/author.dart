class Author {
  Author(this.firstName, this.lastName, this.bio, this.occupation, this.twitter,
      this.email, this.avatar);

  final String firstName;
  final String lastName;
  String get fullName => "$firstName $lastName";

  final String bio;
  final String occupation;
  final String twitter;
  final String email;
  final String avatar;
}
