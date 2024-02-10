final class Satellite extends Enemy {
  final color COLOUR = #B4B4B4;
  final int SCORE_VALUE = 100;
  
  Satellite(int x, int y, boolean isMovingLeft, int waveNumber) {
    super(x, y, isMovingLeft, waveNumber);
  }
  
  void draw() {
    fill(COLOUR);
    rect(position.x, position.y, width, height);
    noStroke();
  }
}
