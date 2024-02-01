final class Button {
  final color SET_COLOUR = #810000;
  final color NOT_SET_COLOUR = #FFFFFF;
  final color SHADOW_COLOUR = #CECECE;
  final int SHADOW_THICKNESS = 10;
  PVector dimensions;
  PVector pos;
  String text;
  Boolean isSet = false;
  
  Button(PVector pos, PVector dimensions, String text) {
    this.pos = pos;
    this.dimensions = dimensions;
    this.text = text;
  }
  
  boolean getSet() {
    return isSet;
  }
  
  void isSet(boolean isSet) {
    this.isSet = isSet;
  }
  
  void draw() {
    if (isSet) {
      fill(SET_COLOUR);
    }
    else {
      fill(NOT_SET_COLOUR);
    }
    rect(pos.x, pos.y, dimensions.x, dimensions.y);
    stroke(SHADOW_THICKNESS);
    fill(#810000);
    line(pos.x, pos.y + dimensions.y, dimensions.x, pos.y + dimensions.y);
    noStroke();
    fill(0);
    text(text, pos.x, pos.y, pos.x + dimensions.x, pos.y + dimensions.y);
    textAlign(CENTER, CENTER);
  }
}
