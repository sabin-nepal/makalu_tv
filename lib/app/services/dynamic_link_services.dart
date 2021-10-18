import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:package_info/package_info.dart';

class DynamicLinksService {
  static Future<String> createDynamicLink(
      String parameter, String title, String mediaUrl) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String uriPrefix = "https://makalutv.page.link";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse('https://makalutv.com/$parameter'),
      androidParameters: AndroidParameters(
        packageName: packageInfo.packageName,
        minimumVersion: 1,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: title,
          description: 'Click to view the news..',
          imageUrl: Uri.parse(mediaUrl)),
    );

    // final Uri dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl.toString();
  }

  static void initDynamicLinks(BuildContext context) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDynamicLink(context, data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _handleDynamicLink(context, dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  static _handleDynamicLink(
      BuildContext context, PendingDynamicLinkData data) async {
    final Uri deepLink = data?.link;
    if (deepLink == null) {
      return;
    }
    var id = deepLink.pathSegments[0];
    if (id != null) {
      await UserSharePreferences().dynamicLinkId(value: id);
      Navigator.pushNamed(
        context,
        AppRoutes.mainScreen,
      );
    }
  }
}
