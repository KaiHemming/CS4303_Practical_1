final class Meteor extends Projectile { 
  final int MAX_SPLITS = 4;
  final int SCORE = 25;
  color trajectoryColour = #810000;
  
  Meteor(int x, int y, int radius, int xVelocity, int yVelocity, int mass) {
    super(x, y, radius, xVelocity, yVelocity, mass);
    this.setTrajectoryColour(trajectoryColour);
  }

  ArrayList<Meteor> split(float waveGravity) {
    int numSplits = (int)random(2,MAX_SPLITS+1);
    ArrayList<Meteor> meteors = new ArrayList<Meteor>();
    for (int i = 0; i < numSplits; i++) {
      int newXVelocity = (int)random(-10, 11);
      Meteor meteor = new Meteor((int)position.x, (int)position.y, missileRadius, newXVelocity, -1, mass/numSplits);
      meteor.setGravitationalForce(waveGravity);
      meteors.add(meteor);
    }
    return meteors;
  }
}
