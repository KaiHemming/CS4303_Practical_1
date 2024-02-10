final class Bomber extends Enemy {
  final int SCORE_VALUE = 100;
  final color COLOUR = #810000;
  
  Bomber(int x, int y, boolean isMovingLeft, int waveNumber) {
    super(x, y, isMovingLeft, waveNumber);
  }
  
  void draw() {
    fill(COLOUR);
    rect(position.x, position.y, width, height);
    noStroke();
  }
}
