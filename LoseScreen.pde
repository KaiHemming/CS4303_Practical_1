final class LoseScreen {
  final color TEXT_COLOUR = #FFFFFF;
  final color BACKGROUND_COLOUR = #810000;
  final int FONT_SIZE = 128;
  final int Y_PADDING = 5;
  final String loseMessage = "YOU LOSE!";
  final String instruction = "Press spacebar to play again";
  void draw() {
    background(BACKGROUND_COLOUR);
    fill(TEXT_COLOUR);
    textSize(FONT_SIZE);
    textAlign(CENTER, CENTER);
    text(loseMessage, displayWidth/2, displayHeight/2);
    textAlign(CENTER, BOTTOM);
    textSize(FONT_SIZE/2);
    text(instruction, displayWidth/2, displayHeight/2 + FONT_SIZE + Y_PADDING);
  }
}
