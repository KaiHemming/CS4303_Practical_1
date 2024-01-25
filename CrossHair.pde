final class CrossHair {
  PVector position;
  PVector size;
  final int CROSSHAIR_SIZE = 2;
  final int CROSSHAIR_SPACING = 15;
  color crossHairColour = #FFFFFF;
  
  CrossHair() {
    position = new PVector(displayWidth/2, displayHeight/2);
  }
  
  PVector getPosition() {
    return position;
  }
  
  void draw() {
    strokeWeight(CROSSHAIR_SIZE*2);
    stroke(crossHairColour);
    line(position.x + CROSSHAIR_SPACING, position.y, position.x + CROSSHAIR_SPACING + CROSSHAIR_SIZE*3, position.y);
    line(position.x - CROSSHAIR_SPACING, position.y, position.x - CROSSHAIR_SPACING - CROSSHAIR_SIZE*3, position.y);
    line(position.x, position.y + CROSSHAIR_SPACING, position.x, position.y + CROSSHAIR_SPACING + CROSSHAIR_SIZE*3);
    line(position.x, position.y - CROSSHAIR_SPACING, position.x, position.y - CROSSHAIR_SPACING - CROSSHAIR_SIZE*3);
    
    ellipseMode(RADIUS);
    fill(crossHairColour);
    ellipse(position.x, position.y, CROSSHAIR_SIZE, CROSSHAIR_SIZE);
    noStroke();
  }
  
  void setPos(int x, int y) {
    position.x = x;
    position.y = y;
  }
}
