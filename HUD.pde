final class HUD {
  final int Y_PADDING = 5;
  final int FONT_SIZE = 64;
  final color PRIMARY_COLOUR = #FFFFFF;
  final color SECONDARY_COLOUR = #810000;
  
  void draw(int score, int waveNumber, Ballista[] ballistae) {
    // Score and wave number
    fill(PRIMARY_COLOUR);
    textSize(FONT_SIZE);
    textAlign(CENTER, TOP);
    text(score, displayWidth/2, Y_PADDING);
    textSize(FONT_SIZE/2);
    text("Wave " + (waveNumber - 1), displayWidth/2, FONT_SIZE + Y_PADDING);
    
    // Ballista remaining projectiles
    fill(SECONDARY_COLOUR);
    textSize(FONT_SIZE/2);
    textAlign(CENTER, BOTTOM);
    text(ballistae[0].getNumProjectiles(), ballistae[0].getWidth()/2, displayHeight - Y_PADDING);
  }
}
