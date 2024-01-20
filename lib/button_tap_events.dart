import 'package:flutter/material.dart';

enum map_type {
  water_electricity,
  house_decoration,
  movingNtransportation,
  house_cleaning,
  transportation,
  emergency,
  body_care,
  pharmacy,
  group_buying,
  group_course,
  outing,
  my_favorite,
}

class Events {
  static openMap(BuildContext context, map_type type) {
    print('openMap');
    print(type);
  }
}
