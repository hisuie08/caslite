import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseConsumerPage extends ConsumerWidget with PageRouter {
  const BaseConsumerPage({super.key});
}

abstract class BaseStaticPage extends StatelessWidget
    with PageRouter
    implements PageBase {
  const BaseStaticPage({super.key});
}

abstract class PageBase {
  void router(BuildContext context);
}

mixin PageRouter on Widget {
  void router(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => this));
  }
}
