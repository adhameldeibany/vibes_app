import 'package:flutter/material.dart';
import 'package:vibes/Backend/NavigationPack/Vibespages.dart' as Vpages;

class VibesNavigatorController{
  Widget NavigateToPage(){
    return Vpages.pages[Vpages.index];
  }

  Widget NavigateToSubpage(){
    return Vpages.subpages[Vpages.index][Vpages.subindex];
  }

}