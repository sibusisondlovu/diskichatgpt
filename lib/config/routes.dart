import 'package:diskigpt/views/pages/post_details_page.dart';
import 'package:flutter/material.dart';

import '../views/screens/banter_room_screen.dart';
import '../views/screens/create_post_screen.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/match_detail_screen.dart';
import '../views/screens/register_screen.dart';
import 'wrapper.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as dynamic;
    switch (settings.name) {

      case Wrapper.id:
        return _route(const Wrapper());

        case RegisterScreen.id:
        return _route(const RegisterScreen());

      case HomeScreen.id:
        return _route(const HomeScreen());

      case MatchDetailScreen.id:
        return _route(MatchDetailScreen(liveMatchData: args,));
        
      case BanterRoom.id:
        return _route(BanterRoom(roomId: args.toString(),));

      case CreatePostScreen.id:
        return _route(const CreatePostScreen());

      case PostDetailsPage.id:
        return _route(PostDetailsPage(postId: args));

      default:
        return _errorRoute(settings.name);
    }
  }

  static MaterialPageRoute _route(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);

  static Route<dynamic> _errorRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            )
          ],
        ),
        body: Center(
          child: Text(
            'ROUTE \n\n$name\n\nNOT FOUND',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}