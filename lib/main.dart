import 'dart:math' as math;
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/flame.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/gestures.dart';


const COLOR = const Color(0xFF75DA8B);
const SIZE = 52.0;
const GRAVITY = 400.0;
const BOOST = -380.0;

void main() async{
  WidgetsFlutterBinding.ensureInitialized ();
  final size = await Flame.util.initialDimensions();
  final game = MyGame(size);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: game.widget,
      ),
    )
  );
}

// Resizable will resize the with and height of the background component depending on the size of the mobile
class Bg extends Component with Resizable{
  static final Paint _paint = Paint()..color = COLOR;
  @override
  void render(Canvas c) {
    c.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _paint);
  }

  @override
  void update(double t) {}

}


class Bird extends AnimationComponent with Resizable{
  // to move the bird so it "falls" we move the speed to the Y direction
  double speedY = 0.0;
  bool frozen;
  // The amount is the number of frames, so i this case 4
  Bird () : super.sequenced(SIZE, SIZE, 'bird.png', 4, textureWidth: 16.0, textureHeight: 16.0) {
    this.anchor = Anchor.center;
  }

  // angle so the bird looks up or down
  Position get velocity => Position (300.0, speedY);


  reset () {
    this.x = size.width/ 2;
    this.y = size.height/2;
    this.speedY = 0;
    this.frozen = false;
    this.angle = 0.0;
  }


  @override
  void resize(Size size) {
    // every time updates resize
    super.resize(size);
    reset();
  }

  @override
  void update(double t) {
    // TODO: implement update // we update the Y and the speed
    // formula of gravity to make it seem like its real
    super.update(t);
    // when its frozen we just return and do nothing. We need onTap for the bird to move
    if (frozen) return;
    // bird falls on constant acceleration which is gravity function
    this.y += speedY * t - GRAVITY * t * t / 2;
    this.speedY += GRAVITY * t;
    this.angle = velocity.angle();
    // if birds falls out of the screen reset()
    if (y > size.height) {
      reset();
    }
  }
  onTap() {
    if (this.frozen) {
      this.frozen = false;
      return;
    };
    print('pasa');
    this.speedY = (this.speedY + BOOST).clamp(BOOST, this.speedY);
  }

}


class MyGame extends BaseGame with TapDetector{
  Bird bird;
  MyGame (Size size){
    add(Bg());
    add(bird = Bird());
  }
  @override
  void onTap() {
    bird.onTap();
    print("tap up");
  }
}