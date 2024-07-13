// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   if (Platform.isAndroid) {
//     // WebView.platform = SurfaceAndroidWebView();
//   } else if (Platform.isIOS) {
//     // WebView.platform = CupertinoWebView();
//   }
//
//   runApp(const MaterialApp(home: WebViewExample()));
// }
//
// const String kNavigationExamplePage = '''
// <!DOCTYPE html><html>
// <head><title>Navigation Delegate Example</title></head>
// <body>
// <p>
// The navigation delegate is set to block navigation to the youtube website.
// </p>
// <ul>
// <ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
// <ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
// </ul>
// </body>
// </html>
// ''';
//
// const String kLocalExamplePage = '''
// <!DOCTYPE html>
// <html lang="en">
// <head>
// <title>Load file or HTML string example</title>
// </head>
// <body>
//
// <h1>Local demo page</h1>
// <p>
//   This is an example page used to demonstrate how to load a local file or HTML
//   string using the <a href="https://pub.dev/packages/webview_flutter">Flutter
//   webview</a> plugin.
// </p>
//
// </body>
// </html>
// ''';
//
// const String kTransparentBackgroundPage = '''
//   <!DOCTYPE html>
//   <html>
//   <head>
//     <title>Transparent background test</title>
//   </head>
//   <style type="text/css">
//     body { background: transparent; margin: 0; padding: 0; }
//     #container { position: relative; margin: 0; padding: 0; width: 100vw; height: 100vh; }
//     #shape { background: red; width: 200px; height: 200px; margin: 0; padding: 0; position: absolute; top: calc(50% - 100px); left: calc(50% - 100px); }
//     p { text-align: center; }
//   </style>
//   <body>
//     <div id="container">
//       <p>Transparent background test</p>
//       <div id="shape"></div>
//     </div>
//   </body>
//   </html>
// ''';
//
// const String kLogExamplePage = '''
// <!DOCTYPE html>
// <html lang="en">
// <head>
// <title>Load file or HTML string example</title>
// </head>
// <body onload="console.log('Logging that the page is loading.')">
//
// <h1>Local demo page</h1>
// <p>
//   This page is used to test the forwarding of console logs to Dart.
// </p>
//
// <style>
//     .btn-group button {
//       padding: 24px; 24px;
//       display: block;
//       width: 25%;
//       margin: 5px 0px 0px 0px;
//     }
// </style>
//
// <div class="btn-group">
//     <button onclick="console.error('This is an error message.')">Error</button>
//     <button onclick="console.warn('This is a warning message.')">Warning</button>
//     <button onclick="console.info('This is a info message.')">Info</button>
//     <button onclick="console.debug('This is a debug message.')">Debug</button>
//     <button onclick="console.log('This is a log message.')">Log</button>
// </div>
//
// </body>
// </html>
// ''';
//
// class WebViewExample extends StatefulWidget {
//   const WebViewExample({super.key});
//
//   @override
//   State<WebViewExample> createState() => _WebViewExampleState();
// }
//
// class _WebViewExampleState extends State<WebViewExample> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // #docregion platform_features
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     final WebViewController controller =
//         WebViewController.fromPlatformCreationParams(params);
//
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             debugPrint('WebView is loading (progress : $progress%)');
//           },
//           onPageStarted: (String url) {
//             debugPrint('Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             debugPrint('Page finished loading: $url');
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint('''
// Page resource error:
//   code: ${error.errorCode}
//   description: ${error.description}
//   errorType: ${error.errorType}
//   isForMainFrame: ${error.isForMainFrame}
//           ''');
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               debugPrint('blocking navigation to ${request.url}');
//               return NavigationDecision.prevent;
//             }
//             debugPrint('allowing navigation to ${request.url}');
//             return NavigationDecision.navigate;
//           },
//           onHttpError: (HttpResponseError error) {
//             debugPrint('Error occurred on page: ${error.response?.statusCode}');
//           },
//           onUrlChange: (UrlChange change) {
//             debugPrint('url change to ${change.url}');
//           },
//           onHttpAuthRequest: (HttpAuthRequest request) {
//             openDialog(request);
//           },
//         ),
//       )
//       ..addJavaScriptChannel(
//         'Toaster',
//         onMessageReceived: (JavaScriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         },
//       )
//       ..loadRequest(Uri.parse('https://flutter.dev'));
//
//     // #docregion platform_features
//     if (controller.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (controller.platform as AndroidWebViewController)
//           .setMediaPlaybackRequiresUserGesture(false);
//     }
//     // #enddocregion platform_features
//
//     _controller = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green,
//       appBar: AppBar(
//         title: const Text('Flutter WebView example'),
//         // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
//         actions: <Widget>[
//           NavigationControls(webViewController: _controller),
//           SampleMenu(webViewController: _controller),
//         ],
//       ),
//       body: WebViewWidget(controller: _controller),
//       floatingActionButton: favoriteButton(),
//     );
//   }
//
//   Widget favoriteButton() {
//     return FloatingActionButton(
//       onPressed: () async {
//         final String? url = await _controller.currentUrl();
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Favorited $url')),
//           );
//         }
//       },
//       child: const Icon(Icons.favorite),
//     );
//   }
//
//   Future<void> openDialog(HttpAuthRequest httpRequest) async {
//     final TextEditingController usernameTextController =
//         TextEditingController();
//     final TextEditingController passwordTextController =
//         TextEditingController();
//
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('${httpRequest.host}: ${httpRequest.realm ?? '-'}'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Username'),
//                   autofocus: true,
//                   controller: usernameTextController,
//                 ),
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Password'),
//                   controller: passwordTextController,
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             // Explicitly cancel the request on iOS as the OS does not emit new
//             // requests when a previous request is pending.
//             TextButton(
//               onPressed: () {
//                 httpRequest.onCancel();
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 httpRequest.onProceed(
//                   WebViewCredential(
//                     user: usernameTextController.text,
//                     password: passwordTextController.text,
//                   ),
//                 );
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Authenticate'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// enum MenuOptions {
//   showUserAgent,
//   listCookies,
//   clearCookies,
//   addToCache,
//   listCache,
//   clearCache,
//   navigationDelegate,
//   doPostRequest,
//   loadLocalFile,
//   loadFlutterAsset,
//   loadHtmlString,
//   transparentBackground,
//   setCookie,
//   logExample,
//   basicAuthentication,
// }
//
// class SampleMenu extends StatelessWidget {
//   SampleMenu({
//     super.key,
//     required this.webViewController,
//   });
//
//   final WebViewController webViewController;
//   late final WebViewCookieManager cookieManager = WebViewCookieManager();
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<MenuOptions>(
//       key: const ValueKey<String>('ShowPopupMenu'),
//       onSelected: (MenuOptions value) {
//         switch (value) {
//           case MenuOptions.showUserAgent:
//             _onShowUserAgent();
//           case MenuOptions.listCookies:
//             _onListCookies(context);
//           case MenuOptions.clearCookies:
//             _onClearCookies(context);
//           case MenuOptions.addToCache:
//             _onAddToCache(context);
//           case MenuOptions.listCache:
//             _onListCache();
//           case MenuOptions.clearCache:
//             _onClearCache(context);
//           case MenuOptions.navigationDelegate:
//             _onNavigationDelegateExample();
//           case MenuOptions.doPostRequest:
//             _onDoPostRequest();
//           case MenuOptions.loadLocalFile:
//             _onLoadLocalFileExample();
//           case MenuOptions.loadFlutterAsset:
//             _onLoadFlutterAssetExample();
//           case MenuOptions.loadHtmlString:
//             _onLoadHtmlStringExample();
//           case MenuOptions.transparentBackground:
//             _onTransparentBackground();
//           case MenuOptions.setCookie:
//             _onSetCookie();
//           case MenuOptions.logExample:
//             _onLogExample();
//           case MenuOptions.basicAuthentication:
//             _promptForUrl(context);
//         }
//       },
//       itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.showUserAgent,
//           child: Text('Show user agent'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.listCookies,
//           child: Text('List cookies'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.clearCookies,
//           child: Text('Clear cookies'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.addToCache,
//           child: Text('Add to cache'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.listCache,
//           child: Text('List cache'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.clearCache,
//           child: Text('Clear cache'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.navigationDelegate,
//           child: Text('Navigation Delegate example'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.doPostRequest,
//           child: Text('Post Request'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.loadHtmlString,
//           child: Text('Load HTML string'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.loadLocalFile,
//           child: Text('Load local file'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.loadFlutterAsset,
//           child: Text('Load Flutter Asset'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           key: ValueKey<String>('ShowTransparentBackgroundExample'),
//           value: MenuOptions.transparentBackground,
//           child: Text('Transparent background example'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.setCookie,
//           child: Text('Set cookie'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.logExample,
//           child: Text('Log example'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.basicAuthentication,
//           child: Text('Basic Authentication Example'),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _onShowUserAgent() {
//     // Send a message with the user agent string to the Toaster JavaScript channel we registered
//     // with the WebView.
//     return webViewController.runJavaScript(
//       'Toaster.postMessage("User Agent: " + navigator.userAgent);',
//     );
//   }
//
//   Future<void> _onListCookies(BuildContext context) async {
//     final String cookies = await webViewController
//         .runJavaScriptReturningResult('document.cookie') as String;
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const Text('Cookies:'),
//             _getCookieList(cookies),
//           ],
//         ),
//       ));
//     }
//   }
//
//   Future<void> _onAddToCache(BuildContext context) async {
//     await webViewController.runJavaScript(
//       'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";',
//     );
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Added a test entry to cache.'),
//       ));
//     }
//   }
//
//   Future<void> _onListCache() {
//     return webViewController.runJavaScript('caches.keys()'
//         // ignore: missing_whitespace_between_adjacent_strings
//         '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
//         '.then((caches) => Toaster.postMessage(caches))');
//   }
//
//   Future<void> _onClearCache(BuildContext context) async {
//     await webViewController.clearCache();
//     await webViewController.clearLocalStorage();
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Cache cleared.'),
//       ));
//     }
//   }
//
//   Future<void> _onClearCookies(BuildContext context) async {
//     final bool hadCookies = await cookieManager.clearCookies();
//     String message = 'There were cookies. Now, they are gone!';
//     if (!hadCookies) {
//       message = 'There are no cookies.';
//     }
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(message),
//       ));
//     }
//   }
//
//   Future<void> _onNavigationDelegateExample() {
//     final String contentBase64 = base64Encode(
//       const Utf8Encoder().convert(kNavigationExamplePage),
//     );
//     return webViewController.loadRequest(
//       Uri.parse('data:text/html;base64,$contentBase64'),
//     );
//   }
//
//   Future<void> _onSetCookie() async {
//     await cookieManager.setCookie(
//       const WebViewCookie(
//         name: 'foo',
//         value: 'bar',
//         domain: 'httpbin.org',
//         path: '/anything',
//       ),
//     );
//     await webViewController.loadRequest(Uri.parse(
//       'https://httpbin.org/anything',
//     ));
//   }
//
//   Future<void> _onDoPostRequest() {
//     return webViewController.loadRequest(
//       Uri.parse('https://httpbin.org/post'),
//       method: LoadRequestMethod.post,
//       headers: <String, String>{'foo': 'bar', 'Content-Type': 'text/plain'},
//       body: Uint8List.fromList('Test Body'.codeUnits),
//     );
//   }
//
//   Future<void> _onLoadLocalFileExample() async {
//     final String pathToIndex = await _prepareLocalFile();
//     await webViewController.loadFile(pathToIndex);
//   }
//
//   Future<void> _onLoadFlutterAssetExample() {
//     return webViewController.loadFlutterAsset('assets/www/index.html');
//   }
//
//   Future<void> _onLoadHtmlStringExample() {
//     return webViewController.loadHtmlString(kLocalExamplePage);
//   }
//
//   Future<void> _onTransparentBackground() {
//     return webViewController.loadHtmlString(kTransparentBackgroundPage);
//   }
//
//   Widget _getCookieList(String cookies) {
//     if (cookies == '""') {
//       return Container();
//     }
//     final List<String> cookieList = cookies.split(';');
//     final Iterable<Text> cookieWidgets =
//         cookieList.map((String cookie) => Text(cookie));
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       mainAxisSize: MainAxisSize.min,
//       children: cookieWidgets.toList(),
//     );
//   }
//
//   static Future<String> _prepareLocalFile() async {
//     final String tmpDir = (await getTemporaryDirectory()).path;
//     final File indexFile = File(
//         <String>{tmpDir, 'www', 'index.html'}.join(Platform.pathSeparator));
//
//     await indexFile.create(recursive: true);
//     await indexFile.writeAsString(kLocalExamplePage);
//
//     return indexFile.path;
//   }
//
//   Future<void> _onLogExample() {
//     webViewController
//         .setOnConsoleMessage((JavaScriptConsoleMessage consoleMessage) {
//       debugPrint(
//           '== JS == ${consoleMessage.level.name}: ${consoleMessage.message}');
//     });
//
//     return webViewController.loadHtmlString(kLogExamplePage);
//   }
//
//   Future<void> _promptForUrl(BuildContext context) {
//     final TextEditingController urlTextController = TextEditingController();
//
//     return showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Input URL to visit'),
//           content: TextField(
//             decoration: const InputDecoration(labelText: 'URL'),
//             autofocus: true,
//             controller: urlTextController,
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 if (urlTextController.text.isNotEmpty) {
//                   final Uri? uri = Uri.tryParse(urlTextController.text);
//                   if (uri != null && uri.scheme.isNotEmpty) {
//                     webViewController.loadRequest(uri);
//                     Navigator.pop(context);
//                   }
//                 }
//               },
//               child: const Text('Visit'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class NavigationControls extends StatelessWidget {
//   const NavigationControls({super.key, required this.webViewController});
//
//   final WebViewController webViewController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () async {
//             if (await webViewController.canGoBack()) {
//               await webViewController.goBack();
//             } else {
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('No back history item')),
//                 );
//               }
//             }
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_forward_ios),
//           onPressed: () async {
//             if (await webViewController.canGoForward()) {
//               await webViewController.goForward();
//             } else {
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('No forward history item')),
//                 );
//               }
//             }
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.replay),
//           onPressed: () => webViewController.reload(),
//         ),
//       ],
//     );
//   }
// }



// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   if (Platform.isAndroid) {
//     WebView.platform = SurfaceAndroidWebView();
//   } else if (Platform.isIOS) {
//     WebView.platform = SurfaceAndroidWebView();
//   }
//
//   runApp(const MaterialApp(home: WebViewExample()));
// }
//
// const String kNavigationExamplePage = '''
// <!DOCTYPE html><html>
// <head><title>Navigation Delegate Example</title></head>
// <body>
// <p>
// The navigation delegate is set to block navigation to the youtube website.
// </p>
// <ul>
// <ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
// <ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
// </ul>
// </body>
// </html>
// ''';
//
// const String kLocalExamplePage = '''
// <!DOCTYPE html>
// <html lang="en">
// <head>
// <title>Load file or HTML string example</title>
// </head>
// <body>
//
// <h1>Local demo page</h1>
// <p>
//   This is an example page used to demonstrate how to load a local file or HTML
//   string using the <a href="https://pub.dev/packages/webview_flutter">Flutter
//   webview</a> plugin.
// </p>
//
// </body>
// </html>
// ''';
//
// const String kTransparentBackgroundPage = '''
//   <!DOCTYPE html>
//   <html>
//   <head>
//     <title>Transparent background test</title>
//   </head>
//   <style type="text/css">
//     body { background: transparent; margin: 0; padding: 0; }
//     #container { position: relative; margin: 0; padding: 0; width: 100vw; height: 100vh; }
//     #shape { background: red; width: 200px; height: 200px; margin: 0; padding: 0; position: absolute; top: calc(50% - 100px); left: calc(50% - 100px); }
//     p { text-align: center; }
//   </style>
//   <body>
//     <div id="container">
//       <p>Transparent background test</p>
//       <div id="shape"></div>
//     </div>
//   </body>
//   </html>
// ''';
//
// const String kLogExamplePage = '''
// <!DOCTYPE html>
// <html lang="en">
// <head>
// <title>Load file or HTML string example</title>
// </head>
// <body onload="console.log('Logging that the page is loading.')">
//
// <h1>Local demo page</h1>
// <p>
//   This page is used to test the forwarding of console logs to Dart.
// </p>
//
// <style>
//     .btn-group button {
//       padding: 24px; 24px;
//       display: block;
//       width: 25%;
//       margin: 5px 0px 0px 0px;
//     }
// </style>
//
// <div class="btn-group">
//     <button onclick="console.error('This is an error message.')">Error</button>
//     <button onclick="console.warn('This is a warning message.')">Warning</button>
//     <button onclick="console.info('This is a info message.')">Info</button>
//     <button onclick="console.debug('This is a debug message.')">Debug</button>
//     <button onclick="console.log('This is a log message.')">Log</button>
// </div>
//
// </body>
// </html>
// ''';
//
// class WebViewExample extends StatefulWidget {
//   const WebViewExample({super.key});
//
//   @override
//   State<WebViewExample> createState() => _WebViewExampleState();
// }
//
// class _WebViewExampleState extends State<WebViewExample> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // #docregion platform_features
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }
//
//     final WebViewController controller =
//     WebViewController.fromPlatformCreationParams(params);
//
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             debugPrint('WebView is loading (progress : $progress%)');
//           },
//           onPageStarted: (String url) {
//             debugPrint('Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             debugPrint('Page finished loading: $url');
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint('''
// Page resource error:
//   code: ${error.errorCode}
//   description: ${error.description}
//   errorType: ${error.errorType}
//   isForMainFrame: ${error.isForMainFrame}
//             ''');
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               debugPrint('blocking navigation to ${request.url}');
//               return NavigationDecision.prevent;
//             }
//             debugPrint('allowing navigation to ${request.url}');
//             return NavigationDecision.navigate;
//           },
//           onHttpError: (HttpResponseError error) {
//             debugPrint('Error occurred on page: ${error.response?.statusCode}');
//           },
//           onUrlChange: (UrlChange change) {
//             debugPrint('url change to ${change.url}');
//           },
//           onHttpAuthRequest: (HttpAuthRequest request) {
//             openDialog(request);
//           },
//         ),
//       )
//       ..addJavaScriptChannel(
//         'Toaster',
//         onMessageReceived: (JavaScriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         },
//       )
//       ..loadRequest(Uri.parse('https://flutter.dev'));
//
//     // #docregion platform_features
//     if (controller.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(true);
//       (controller.platform as AndroidWebViewController)
//           .setMediaPlaybackRequiresUserGesture(false);
//     }
//     // #enddocregion platform_features
//
//     _controller = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green,
//       appBar: AppBar(
//         title: const Text('Flutter WebView example'),
//         // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
//         actions: <Widget>[
//           NavigationControls(webViewController: _controller),
//           SampleMenu(webViewController: _controller),
//         ],
//       ),
//       body: WebViewWidget(controller: _controller),
//       floatingActionButton: favoriteButton(),
//     );
//   }
//
//   Widget favoriteButton() {
//     return FloatingActionButton(
//       onPressed: () async {
//         final String? url = await _controller.currentUrl();
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Favorited $url')),
//           );
//         }
//       },
//       child: const Icon(Icons.favorite),
//     );
//   }
//
//   Future<void> openDialog(HttpAuthRequest httpRequest) async {
//     final TextEditingController usernameTextController =
//     TextEditingController();
//     final TextEditingController passwordTextController =
//     TextEditingController();
//
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('${httpRequest.host}: ${httpRequest.realm ?? '-'}'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Username'),
//                   autofocus: true,
//                   controller: usernameTextController,
//                 ),
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Password'),
//                   controller: passwordTextController,
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             // Explicitly cancel the request on iOS as the OS does not emit new
//             // requests when a previous request is pending.
//             TextButton(
//               onPressed: () {
//                 httpRequest.onCancel();
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 httpRequest.onProceed(
//                   WebViewCredential(
//                     user: usernameTextController.text,
//                     password: passwordTextController.text,
//                   ),
//                 );
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Authenticate'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// enum MenuOptions {
//   showUserAgent,
//   listCookies,
//   clearCookies,
//   addToCache,
//   listCache,
//   clearCache,
//   navigationDelegate,
//   doPostRequest,
//   loadLocalFile,
//   loadFlutterAsset,
//   loadHtmlString,
//   transparentBackground,
//   setCookie,
//   logExample,
//   basicAuthentication,
// }
//
// class SampleMenu extends StatelessWidget {
//   SampleMenu({required this.webViewController, super.key});
//
//   final WebViewController webViewController;
//   final CookieManager cookieManager = CookieManager();
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<MenuOptions>(
//       onSelected: (MenuOptions value) {
//         switch (value) {
//           case MenuOptions.showUserAgent:
//             _onShowUserAgent(webViewController, context);
//             break;
//           case MenuOptions.listCookies:
//             _onListCookies(webViewController, context);
//             break;
//           case MenuOptions.clearCookies:
//             _onClearCookies(context);
//             break;
//           case MenuOptions.addToCache:
//             _onAddToCache(webViewController, context);
//             break;
//           case MenuOptions.listCache:
//             _onListCache(webViewController, context);
//             break;
//           case MenuOptions.clearCache:
//             _onClearCache(webViewController, context);
//             break;
//           case MenuOptions.navigationDelegate:
//             _onNavigationDelegateExample(webViewController, context);
//             break;
//           case MenuOptions.doPostRequest:
//             _onDoPostRequest(webViewController, context);
//             break;
//           case MenuOptions.loadLocalFile:
//             _onLoadLocalFileExample(webViewController, context);
//             break;
//           case MenuOptions.loadFlutterAsset:
//             _onLoadFlutterAssetExample(webViewController, context);
//             break;
//           case MenuOptions.loadHtmlString:
//             _onLoadHtmlStringExample(webViewController, context);
//             break;
//           case MenuOptions.transparentBackground:
//             _onTransparentBackgroundExample(webViewController, context);
//             break;
//           case MenuOptions.setCookie:
//             _onSetCookie(webViewController, context);
//             break;
//           case MenuOptions.logExample:
//             _onLogExample(webViewController, context);
//             break;
//           case MenuOptions.basicAuthentication:
//             _onBasicAuthenticationExample(webViewController, context);
//             break;
//         }
//       },
//       itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.showUserAgent,
//           child: Text('Show user-agent'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.listCookies,
//           child: Text('List cookies'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.clearCookies,
//           child: Text('Clear cookies'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.addToCache,
//           child: Text('Add to cache'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.listCache,
//           child: Text('List cache'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.clearCache,
//           child: Text('Clear cache'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.navigationDelegate,
//           child: Text('Navigation Delegate example'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.doPostRequest,
//           child: Text('Post Request'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.loadLocalFile,
//           child: Text('Load local file'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.loadFlutterAsset,
//           child: Text('Load Flutter Asset'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.loadHtmlString,
//           child: Text('Load HTML string'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.transparentBackground,
//           child: Text('Transparent background example'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.setCookie,
//           child: Text('Set cookie'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.logExample,
//           child: Text('Log example'),
//         ),
//         const PopupMenuItem<MenuOptions>(
//           value: MenuOptions.basicAuthentication,
//           child: Text('Basic authentication'),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _onShowUserAgent(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     // Send a message with the user-agent string to the Toaster JavaScript channel we registered with the WebView.
//     await controller.runJavaScript('Toaster.postMessage(navigator.userAgent);');
//   }
//
//   Future<void> _onListCookies(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     final String cookies = await controller.runJavaScriptReturningResult(
//       '''
//     (function() {
//       var cookies = document.cookie;
//       return cookies ? cookies : "No cookies.";
//     })();
//     ''',
//     ) as String;
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(cookies.isNotEmpty ? cookies : 'No cookies.'),
//       ));
//     }
//   }
//
//   Future<void> _onClearCookies(BuildContext context) async {
//     final bool hadCookies = await cookieManager.clearCookies();
//     String message = 'There were cookies. Now, they are gone!';
//     if (!hadCookies) {
//       message = 'There are no cookies.';
//     }
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(message),
//       ));
//     }
//   }
//
//   Future<void> _onAddToCache(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     await controller.runJavaScript('caches.open("test_caches_entry");'
//         'localStorage["test_localStorage"] = "dummy_entry";');
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Added a test entry to cache.'),
//       ));
//     }
//   }
//
//   Future<void> _onListCache(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     await controller.runJavaScriptReturningResult('caches.keys()'
//         '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys,'
//         ' "localStorage" : localStorage}))'
//         '.then((caches) => Toaster.postMessage(caches))');
//   }
//
//   Future<void> _onClearCache(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     await controller.runJavaScript('caches.delete("test_caches_entry");'
//         'localStorage.removeItem("test_localStorage");');
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Cache cleared.'),
//       ));
//     }
//   }
//
//   Future<void> _onNavigationDelegateExample(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     await controller.loadRequest(
//       Uri.parse('data:text/html;base64,${base64Encode(const Utf8Encoder().convert(kNavigationExamplePage))}'),
//     );
//   }
//
//   Future<void> _onDoPostRequest(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     await controller.loadRequest(
//       Uri.parse('https://httpbin.org/post'),
//       method: LoadRequestMethod.post,
//       headers: <String, String>{'foo': 'bar', 'Content-Type': 'text/plain'},
//       body: Uint8List.fromList('Test Body'.codeUnits),
//     );
//   }
//
//   Future<void> _onLoadLocalFileExample(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     final String path = await _prepareLocalFile();
//     await controller.loadFile(path);
//   }
//
//   Future<String> _prepareLocalFile() async {
//     final String tmpDir = (await getTemporaryDirectory()).path;
//     final File file = File(
//         '$tmpDir/localfile.html');
//     await file.writeAsString(kLocalExamplePage);
//     return file.path;
//   }
//
//   Future<void> _onLoadFlutterAssetExample(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     await controller.loadFlutterAsset('assets/play.png');
//   }
//
//   Future<void> _onLoadHtmlStringExample(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     await controller.loadRequest(
//       Uri.parse('data:text/html;base64,${base64Encode(const Utf8Encoder().convert(kNavigationExamplePage))}'),
//     );
//   }
//
//   Future<void> _onTransparentBackgroundExample(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     await controller.loadRequest(
//       Uri.parse('data:text/html;base64,${base64Encode(const Utf8Encoder().convert(kTransparentBackgroundPage))}'),
//     );
//   }
//
//   Future<void> _onSetCookie(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     await cookieManager.setCookie(
//       const WebViewCookie(
//         name: 'foo',
//         value: 'bar',
//         domain: 'httpbin.org',
//         path: '/anything',
//       ),
//     );
//     await controller.loadRequest(Uri.parse('https://httpbin.org/anything'));
//   }
//
//   Future<void> _onLogExample(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     await controller.loadRequest(
//       Uri.parse('data:text/html;base64,${base64Encode(const Utf8Encoder().convert(kLogExamplePage))}'),
//     );
//   }
//
//   Future<void> _onBasicAuthenticationExample(
//       WebViewController controller,
//       BuildContext context,
//       ) async {
//     await controller.loadRequest(Uri.parse('https://jigsaw.w3.org/HTTP/Basic/'));
//   }
// }
//
// class NavigationControls extends StatelessWidget {
//   const NavigationControls({required this.webViewController, super.key});
//
//   final WebViewController webViewController;
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewNavigationState>(
//       future: webViewController.currentNavigationState,
//       builder: (BuildContext context, AsyncSnapshot<WebViewNavigationState> snapshot) {
//         final bool webViewReady =
//             snapshot.connectionState == ConnectionState.done;
//         final WebViewNavigationState? navigationState = snapshot.data;
//         final bool canGoBack = navigationState?.canGoBack ?? false;
//         final bool canGoForward = navigationState?.canGoForward ?? false;
//
//         return Row(
//           children: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: !webViewReady || !canGoBack
//                   ? null
//                   : () async {
//                 if (await webViewController.canGoBack()) {
//                   await webViewController.goBack();
//                 }
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward_ios),
//               onPressed: !webViewReady || !canGoForward
//                   ? null
//                   : () async {
//                 if (await webViewController.canGoForward()) {
//                   await webViewController.goForward();
//                 }
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.replay),
//               onPressed: !webViewReady
//                   ? null
//                   : () {
//                 webViewController.reload();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:web_view/splash_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hi College",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://hicollege.netlify.app/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WebViewWidget(controller: _controller)),
      )),
    );
  }

}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
  doPostRequest,
  loadLocalFile,
  loadFlutterAsset,
  loadHtmlString,
  transparentBackground,
  setCookie,
  logExample,
  basicAuthentication,
}

