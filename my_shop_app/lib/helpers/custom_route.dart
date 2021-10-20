import 'package:flutter/material.dart';

//we are creating our custom route class in which we extends this class with Material Page Route which is generic class so custom route class is also a generic class
//with generic class we <T> after class name
class CustomeRoute<T> extends MaterialPageRoute<T> {
  //creating customroute constructor which takes to arg one is WidgetBuilder, and other is routeSettings and then forwarded these arg to its parent class too
  CustomeRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  //for tansition animation b/w pages we are overriding the build transition
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
} //now we can use this custom route at which screen we need that transition

//But if want to use it in whole app we also have creat another class which extends PageTransitionBuilder
class CustomRoutePageTransition extends PageTransitionsBuilder {
  //for generic class we have generic sub class and for generic arg we have generic method
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // TODO: implement buildTransitions
    if (route.settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}// to use this CustomPageTransition, in main.dart in themedata we use a PageTransitionTheme
