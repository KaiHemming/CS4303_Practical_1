final class Bomber extends Enemy {
  final int SCORE_VALUE = 100;
  final color COLOUR = #810000;
  
  Bomber(int x, int y, boolean isMovingLeft) {
    super(x, y, isMovingLeft);
  }
  
  void draw() {
    fill(COLOUR);
    rect(position.x, position.y, width, height);
    noStroke();
  }
}
