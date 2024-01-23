final class Meteor extends Projectile { 
  final int SCORE = 25;
  color trajectoryColour = #810000;
  
  Meteor(int x, int y, int radius, int xVelocity, int yVelocity, int mass) {
    super(x, y, radius, xVelocity, yVelocity, mass);
    this.setTrajectoryColour(trajectoryColour);
  }
}
