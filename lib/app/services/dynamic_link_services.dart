import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:package_info/package_info.dart';

class DynamicLinksService {
  static Future<String> createDynamicLink(
      String parameter, String title, String mediaUrl) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String uriPrefix = "https://makalu.page.link";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse('https://makalutv.com/$parameter'),
      androidParameters: AndroidParameters(
        packageName: packageInfo.packageName,
        minimumVersion: 125,
      ),
      iosParameters: IosParameters(
        bundleId: packageInfo.packageName,
        minimumVersion: packageInfo.version,
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: title,
          description: 'This link works whether app is installed or not!',
          imageUrl: Uri.parse(mediaUrl)),
    );

    // final Uri dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl.toString();
  }

  static void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDynamicLink(data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _handleDynamicLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  static _handleDynamicLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data?.link;

    if (deepLink == null) {
      return;
    }
    if (deepLink.pathSegments.contains('refer')) {
      var title = deepLink.queryParameters['code'];
      if (title != null) {
        print("refercode=$title");
      }
    }
  }
}
