class Site {
  static const ID = "_id";
  static const SITEID = "siteId";
  static const SITENAME = "siteName";
  static const CONTACT = "contact";
  static const SITEADDRESS = "siteAddress";
  static const MANAGER = "manager";

  final String id;
  final String siteId;
  final String siteName;
  final String siteAddress;
  final Map<String, dynamic> manager;
  final String contact;

  Site(
      {required this.id,
      required this.siteId,
      required this.siteName,
      required this.siteAddress,
      required this.manager,
      required this.contact});

  List<Site> sites = [];
  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
        id: json[Site.ID],
        siteName: json[Site.SITENAME],
        siteId: json[Site.SITEID],
        siteAddress: json[Site.SITEADDRESS],
        manager: json[Site.MANAGER],
        contact: json[Site.CONTACT]);
  }
}

class SiteList {
  final List<Site> sites;

  SiteList({required this.sites});

  factory SiteList.fromJson(List<dynamic> parsedJson) {
    List<Site> sites = <Site>[];
    sites = parsedJson.map((i) => Site.fromJson(i)).toList();
    return new SiteList(sites: sites);
  }
}
