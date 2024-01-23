final class City {
  final int SURVIVING_SCORE = 100;
  final color CITY_COLOUR = #E0B33F;
  boolean isSurviving = true;
  int width, height;
  PVector position;
  
  City(int x, int y, int width, int height) {
    position = new PVector(x, y);
    this.width = width;
    this.height = height;
  }
  
  PVector getPosition() {
    return position;
  }
  
  int getWidth() { 
    return width;
  }
  
  void setSurviving(boolean isSurviving) {
    this.isSurviving = isSurviving;
  }
  
  void draw() {
    if (isSurviving) {
      stroke(#FFFFFF);
      fill(CITY_COLOUR);
      rect(position.x, position.y, width, height);
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
