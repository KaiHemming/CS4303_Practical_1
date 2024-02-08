final class TitleScreen {
  final color TEXT_COLOUR = #FAFF00;
  final color BACKGROUND_COLOUR = 0;
  final int FONT_SIZE = 128;
  final int Y_PADDING = 5;
  final String welcomeMessage = "Ballista Command!";
  final String instruction = "Press spacebar to play";
  
  void draw() {
    background(BACKGROUND_COLOUR);
    fill(TEXT_COLOUR);
    textSize(FONT_SIZE);
    textAlign(CENTER, CENTER);
    text(welcomeMessage, displayWidth/2, displayHeight/2);
    textAlign(CENTER, BOTTOM);
    textSize(FONT_SIZE/2);
    text(instruction, displayWidth/2, displayHeight/2 + FONT_SIZE + Y_PADDING);
  }
}
