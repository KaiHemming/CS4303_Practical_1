final class Ballista {
  final color BALLISTA_COLOUR = #FFFFFF;
  final color SELECTED_BALLISTA_COLOUR = #6A6A6A;
  final color LAUNCH_POS_COLOUR = #810000;
  final color TRAJECTORY_COLOUR = #272525;
  final int TRAJECTORY_LINE_WEIGHT = 2;
  final int TRAJECTORY_DISPLAY_HEIGHT = displayHeight/2;
  PVector drawPosition;
  PVector launchPosition;
  int width, height;
  
  Ballista(int x, int y, int width, int height) {
    drawPosition = new PVector(x, y);
    launchPosition = drawPosition.copy();
    launchPosition.x += width/2;
    this.width = width;
    this.height = height;
  }
  void draw(PVector crossHairPos) {
    strokeWeight(TRAJECTORY_LINE_WEIGHT);
    stroke(TRAJECTORY_COLOUR);
    line(launchPosition.x, launchPosition.y, crossHairPos.x, constrain(crossHairPos.y, displayHeight - TRAJECTORY_DISPLAY_HEIGHT, displayHeight));
   
    noStroke();
    ellipseMode(RADIUS);
    fill(LAUNCH_POS_COLOUR);
    ellipse(launchPosition.x, launchPosition.y, height/4, height/4);
    
    fill(SELECTED_BALLISTA_COLOUR);
    rect(drawPosition.x, drawPosition.y, width, height);
  }
  
  void draw() {
    ellipseMode(RADIUS);
    fill(BALLISTA_COLOUR);
    ellipse(launchPosition.x, launchPosition.y, height/4, height/4);
    rect(drawPosition.x, drawPosition.y, width, height);
  }
}
