final class City {
  final int SURVIVING_SCORE = 100;
  final color CITY_COLOUR = #E0B33F;
  boolean isSurviving = true;
  int width, height;
  PVector drawPosition;
  
  City(int x, int y, int width, int height) {
    drawPosition = new PVector(x, y);
    this.width = width;
    this.height = height;
  }
  
  void draw() {
    if (isSurviving) {
      stroke(#FFFFFF);
      fill(CITY_COLOUR);
      rect(drawPosition.x, drawPosition.y, width, height);
      noStroke();
    }
  }
  
  int getSurvivingScore() {
    if (isSurviving) {
      return SURVIVING_SCORE;
    }
    return 0;
  }
}
