class Business {
  String objectID;
  String imageUrl;
  String name;
  String location;
  String description;
  String contactNumber;
  String tags;

  Business(
      {this.objectID,
      this.description,
      this.location,
      this.name,
      this.contactNumber,
      this.tags,
      this.imageUrl});

  factory Business.toJson(Map<String, dynamic> data) {
    return Business(
      objectID: data["objectID"],
      imageUrl: data["imageUrl"],
      name: data["name"],
      location: data["location"],
      description: data["description"],
      contactNumber: data["contactNumber"],
      tags: data["tags"],
    );
  }
}
