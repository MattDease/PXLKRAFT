class Wood extends Particle
{
  
  //default constructor
  Wood()
  {
  }
  //constructor
  Wood(float radius, color col, float lifeSpan, float damping, char type)
  {
    super(radius, col, lifeSpan, damping, type);
  }
  //draws particle - (overrides Particle create())
  void create()
  {
    fill(col);
    noStroke();
    ellipse(0, 0, 2*radius, 2*radius);
  }
    
  //moves particle - (overrides Particle move())
  void move()
  {
    vel.set(0,0,0);
    translate(loc.x, loc.y);
  }
  //handle particle-particle collisions/reactions
  void checkHit(Particle otherParticle)
  {
    if(isHit(otherParticle))
    {
      switch(otherParticle.type)
      {
        case 'p': //collided with a base particle
          bounce(otherParticle);
          break;
        case 'a': //collided with a arrow
          bounce(otherParticle);
          break;
        case 'w': //collided with a water particle
          bounce(otherParticle);
          break;
        case 'o': //collided with a oil particle
          bounce(otherParticle);
          break;
        case 's': //collided with a seed particle
          bounce(otherParticle);
          break;
        case 'f': //collided with a fire particle
          bounce(otherParticle);
          break;
        case 'c': //collided with a concrete particle
          break;
        case 'd':
          //bounce(otherParticle);
          break;
        case 'i': //collided with a ice particle
          bounce(otherParticle);
          break;
        case 'k': //collided with a fireworks particle
          //if(!otherParticle.isIgnited)
            bounce(otherParticle);
          break;
        default:
          break;
      }
    }
  }
}
