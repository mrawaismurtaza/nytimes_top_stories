class TopStory {
  final String section;
  final String subsection;
  final String title;
  final String abstractText;
  final String url;
  final String uri;
  final String byline;
  final String itemType;
  final String updatedDate;
  final String createdDate;
  final String publishedDate;
  final String materialTypeFacet;
  final String kicker;
  final List<String> desFacet;
  final List<String> orgFacet;

  TopStory({
    required this.section,
    required this.subsection,
    required this.title,
    required this.abstractText,
    required this.url,
    required this.uri,
    required this.byline,
    required this.itemType,
    required this.updatedDate,
    required this.createdDate,
    required this.publishedDate,
    required this.materialTypeFacet,
    required this.kicker,
    required this.desFacet,
    required this.orgFacet,
  });

  factory TopStory.fromJson(Map<String, dynamic> json) {
    return TopStory(
      section: json['section'] ?? '',
      subsection: json['subsection'] ?? '',
      title: json['title'] ?? '',
      abstractText: json['abstract'] ?? '',
      url: json['url'] ?? '',
      uri: json['uri'] ?? '',
      byline: json['byline'] ?? '',
      itemType: json['item_type'] ?? '',
      updatedDate: json['updated_date'] ?? '',
      createdDate: json['created_date'] ?? '',
      publishedDate: json['published_date'] ?? '',
      materialTypeFacet: json['material_type_facet'] ?? '',
      kicker: json['kicker'] ?? '',
      desFacet: (json['des_facet'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      orgFacet: (json['org_facet'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'section': section,
      'subsection': subsection,
      'title': title,
      'abstract': abstractText,
      'url': url,
      'uri': uri,
      'byline': byline,
      'item_type': itemType,
      'updated_date': updatedDate,
      'created_date': createdDate,
      'published_date': publishedDate,
      'material_type_facet': materialTypeFacet,
      'kicker': kicker,
      'des_facet': desFacet,
      'org_facet': orgFacet,
    };
  }
}
