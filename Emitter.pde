class Emitter
{
  //emitter position
  PVector loc = new PVector(0,0);
  //rate particles are created
  float birthRate;
  //#d path particles are projects
  PVector birthPath = new PVector(0,0);
  PVector birthForce;
  //keep trak of particle life span
  //float[] birthTime;
  //float[] lifeTime;
  // frame rate of sketch
  float sketchFrameRate;
  int maxParticles = 2000;
  //radius the particles spray from teh emittrer at birth
  float sprayWidth;
  //ammo
  //Particle[] p;
  //by defaul teh emitter runs infinitely
  boolean isInfinite = true;
  //environment reference w/ default instantiation
  Environment environment = new Environment();
  //used to control particle birth rate
  float particleCounter = 0.0;
  ArrayList p = new ArrayList();
  float theta, r;
  char type;
  int lifeSpan;
  int birthNum = 0;
  int birthTime;
  float birthRemainder = 0.0;
  Particle temp;
  boolean isOn = false;
  PVector concretePos = new PVector(-10,-10);
  PVector concretePPos = new PVector(-100, -100);
  PVector woodPos = new PVector(-10,-10);
  PVector woodPPos = new PVector(-100, -100);
  boolean firstEmit = true;
  boolean firstWoodEmit = true;
  boolean isFirework = false;
  int nowCalibrating = 1;
  int wandNum;

  //default constructor
  Emitter()
  {
  }
  //constructor for infinite emission
  Emitter(PVector loc, float sketchFrameRate, PVector birthForce, float sprayWidth, char type, int lifeSpan)
  {
    this.loc = loc;
    this.sketchFrameRate = sketchFrameRate;
    this.type = type;
      this.birthRate = maxParticles/((lifeSpan/1000.0) * (sketchFrameRate));
    this.lifeSpan = lifeSpan;
    this.birthForce = birthForce;
    this.birthPath.add(birthForce);
    this.sprayWidth = sprayWidth;
  }
  //infinite life particles
  Emitter(PVector loc, float sketchFrameRate, PVector birthForce, float sprayWidth, char type, float birthRate, int wandNum)
  {
    this.loc = loc;
    this.sketchFrameRate = sketchFrameRate;
    this.type = type;
    this.birthRate = birthRate;
    this.lifeSpan = -1;
    this.birthForce = birthForce;
    this.birthPath.add(birthForce);
    this.sprayWidth = sprayWidth;
    this.wandNum = wandNum;
  }
  //constructor for single emission with birthRate param (explosions etc)
  Emitter(PVector loc, PVector birthForce, float particleNum, float sprayWidth, char type, int lifeSpan, boolean fWorks)
  {
    this.loc = loc;
    //println(this.loc);
    this.type = type;
    this.birthRate = particleNum - 1;
    this.birthForce = birthForce;
    this.birthPath.add(birthForce);
    this.sprayWidth = sprayWidth;
    this.lifeSpan = lifeSpan;
    this.birthTime = millis();
    this.isOn = true;
    isInfinite = false;
    if(fWorks)
      isFirework = true;
  }
  
  //general methods
  void create()
  {
    //println(frameRate + " - " + birthRate + " - " + birthNum + " - " + birthRemainder + " - " + p.size());
    if(isOn && !isMaxed())
    {
      //if over a ui icon, dont create new particles
      for(int i = 0; i<ui.Main.gameArray.length; i++)
      {
        if(ui.Main.gameArray[i].isOverButton(wandNum))
          return;
      }
      birthRemainder = birthRate + birthRemainder;
      birthNum = floor(birthRemainder);
      birthRemainder %= 1;

      colorMode(RGB,255);
      int colIndex = 0;
      color colFW = color(0);
      // if the emitter is emitting a fireworks burst, choose randomly from 5 colors
      if(isFirework)
      {
        colIndex = int(random(0,5));
        switch(colIndex)
        {
          case 0:
            colFW = color(random(240,255), random(240,255), random(0,10), particleOpacity);
            break;
          case 1:
            colFW = color(random(0,10), random(240,255), random(25,40), particleOpacity);
            break;
          case 2:
            colFW = color(random(240,255), random(0,10), random(240,255), particleOpacity);
            break;
          case 3:
            colFW = color(random(240,255), random(140,165), random(0,10), particleOpacity);
            break;
          case 4:
            colFW = color(random(0,10), random(240,250), random(245,255), particleOpacity);
            break;
          default:
            break;
        }
      }
      //create a new particle based on the emitter's type
      for(int i = 0; i < birthNum; i++)
      {
        switch(type)
        {
          case 'p':
            temp = new Particle(random(9, 12), color(random(255,180), random(120,160), random(0, 30), particleOpacity), lifeSpan, 0.98, type);
            initParticle(temp);
            particleCount++;
            break;
          case 'a':
            temp = new Arrow(random(5, 40), color(255, random(80, 150), 10, particleOpacity), lifeSpan, 0.85, 6, type);
            initParticle(temp);
            arrowCount++;
            break;
          case 'w':
            temp = new Water(random(8, 10), color(random(0,30), random(0,30), random(230, 255), particleOpacity), lifeSpan, 0.95, type);
            initParticle(temp);
            waterCount++;
            break;
          case 'o':
            temp = new Oil(random(7, 10), color(random(140,160), random(75,95), random(35,45), particleOpacity), lifeSpan, 0.98, type);
            initParticle(temp);
            oilCount++;
            break;
          case 's':
            temp = new Seed(random(2, 4), color(random(220,240), random(160,180), random(55,75), particleOpacity), lifeSpan, 0.98, type);
            temp.isSource = true;
            initParticle(temp);
            seedCount++;
            break;
          case 'f':
            if(isFirework)
            {
              temp = new Fire(random(3,7), colFW, lifeSpan, 0.98, type);
              temp.isFirework = true;
            }
            else
            {
              temp = new Fire(random(3, 7), firePalette[254], lifeSpan, 0.98, type);
            }
            initParticle(temp);
            fireCount++;
            break;
          case 'c':
            concretePos.set(loc.x, loc.y, 0);
            int numParticles = floor(PVector.dist(concretePos, concretePPos)/9);
            //println(PVector.dist(concretePos, concretePPos));
            //println(numParticles);
            drawConcrete(numParticles);
            break;
          case 'd':
            woodPos.set(loc.x, loc.y, 0);
            int numWoodParticles = floor(PVector.dist(woodPos, woodPPos)/9);
            drawWood(numWoodParticles);
            break;
          case 'i':
            temp = new Ice(random(3, 7), color(random(120,130), random(225,235), random(230,240), particleOpacity), lifeSpan, 0.98, type);
            initParticle(temp);
            iceCount++;
            break;
          case 'k':
            temp = new Firework(random(3, 5), color(random(190,210), random(65,80), random(220,230), particleOpacity), lifeSpan, 0.98, type);
            initParticle(temp);
            fireworkCount++;
            break;
          default:
            println("unknown particle type...");
            break;
        }
      }
    }
  }
  //linear interpolation is used to draw concrete such that there are no gaps no matter how
  //fast the cursor is moving by adding in extra contcrete particles in what would be gaps
  //the number of particles needed to be drawn is passed into the function and the positions
  //are dynamically determined.
  void drawConcrete(int numParticles)
  {
    if(numParticles == 1 || firstEmit)
    {
      
      temp = new Concrete(15, color(175, 255), lifeSpan, 0.98, type);
      initParticle(temp);
      concreteCount++;
      if(firstEmit)
        firstEmit = false;
      concretePPos.set(concretePos);
      return;
    }
    float x = 0;
    float y = 0;
    for(int i = 1; i<=numParticles; i++)
    {
      temp = new Concrete(15, color(175, 255), lifeSpan, 0.98, type);
      if(i==numParticles)
      {
        temp = new Concrete(15, color(175, 255), lifeSpan, 0.98, type);
        initParticle(temp);
        concreteCount++;
        concretePPos.set(concretePos);
        continue;
      }
      else
      {
        x = lerp(concretePPos.x, concretePos.x, (1.0/numParticles)*i);
        y = lerp(concretePPos.y, concretePos.y, (1.0/numParticles)*i);
        initParticle(temp, x, y);
        //println("drew at " + x +"+"+ y);
        concreteCount++;
      }
    }
  }
  //same principle as the concrete function
  void drawWood(int numParticles)
  {
    if(numParticles == 1 || firstWoodEmit)
    {
      
      temp = new Wood(15, color(139, 84, 62, 255), lifeSpan, 0.98, type);
      initParticle(temp);
      woodCount++;
      if(firstWoodEmit)
        firstWoodEmit = false;
      woodPPos.set(woodPos);
      return;
    }
    float x = 0;
    float y = 0;
    for(int i = 1; i<=numParticles; i++)
    {
      temp = new Wood(15, color(139, 84, 62, 255), lifeSpan, 0.98, type);
      if(i==numParticles)
      {
        temp = new Wood(15, color(139, 84, 62, 255), lifeSpan, 0.98, type);
        initParticle(temp);
        woodCount++;
        woodPPos.set(woodPos);
        continue;
      }
      else
      {
        x = lerp(woodPPos.x, woodPos.x, (1.0/numParticles)*i);
        y = lerp(woodPPos.y, woodPos.y, (1.0/numParticles)*i);
        initParticle(temp, x, y);
        //println("drew at " + x +"+"+ y);
        woodCount++;
      }
    }
  }
  //intializes new particles
  void initParticle(Particle particle)
  {
    theta = random(TWO_PI);
    r = random(sprayWidth);
    
    temp.loc.set(loc.x, loc.y, 0);
    //correct the position before it gets added to the hashGrid if the location is outside the screen
    correctOffScreen(temp);
    temp.birthTime = millis();
    temp.vel = new PVector(birthPath.x + cos(theta)*r, birthPath.y + sin(theta)*r);
    //add to emitted paricles arraylist
    p.add(temp);
    //add to hashgrid
    engine.allObjs.add(temp);
  }
  //same as above but with passed location coordinates (used for drawing plants)
  void initParticle(Particle particle, float x, float y)
  {
    theta = random(TWO_PI);
    r = random(sprayWidth);
    
    temp.loc.set(x, y, 0);
    correctOffScreen(temp);
    temp.birthTime = millis();
    temp.vel = new PVector(birthPath.x + cos(theta)*r, birthPath.y + sin(theta)*r);
    p.add(temp);
    engine.allObjs.add(temp);
  }
  //draws a plant particle at a given location
  void createPlant(PVector location, boolean flower)
  {
    if(flower)
    {
      int randomCol = int(random(0,5));
      temp = new Seed(random(8, 10), flowerColor[randomCol], -1, 0.98, 's');
      temp.rotation = PI/4;
    }
    else
    {
    temp = new Seed(random(4, 6), color(random(75,95), random(220,240), random(10,30), 255), -1, 0.98, 's');
    }
    temp.loc = location;
    correctOffScreen(temp);
    temp.birthTime = millis();
    temp.vel = new PVector(0,0);
    temp.isPlanted = true;
    p.add(temp);
    engine.allObjs.add(temp);
  }
  //craetes the eraser particle, one per emitter
  void createErasor(PVector location)
  {
    temp = new Eraser(30, -1, 'e');
    temp.loc = location;
    temp.birthTime = millis();
    temp.vel = new PVector(0,0);
    p.add(temp);
    engine.allObjs.add(temp);
  }
  //moves the particle location onto the screen, fixed a bug with adding prticles outside of the hashgrid
  void correctOffScreen(Particle part)
  {
    if(engine.boundsSet[0] && part.loc.x > width - part.radius)
    {
      part.loc.x = width - part.radius;
    }
    else if(engine.boundsSet[1] && part.loc.x < part.radius)
    {
      part.loc.x = part.radius;
    }
    if(engine.boundsSet[2] && part.loc.y > height - part.radius)
    {
      part.loc.y = height - part.radius;
    }
    else if(engine.boundsSet[3] && part.loc.y < part.radius)
    {
      part.loc.y = part.radius;
    }
  }
  
  void emit()
  {
    colorMode(RGB,255);
    //loop through all the particles and either kill them or update their position
    //if killing, update the particle counts
    for (int i = p.size() - 1 ; i >= 0; i--)
    {
      Particle part = (Particle) p.get(i);
      pushMatrix();
      part.move();
      part.create();
      popMatrix();
      
      if((part.lifeTime >= part.lifeSpan && part.lifeSpan != -1) || part.toKill)
      {
        part.kill();
        p.remove(i);
        switch(part.type)
        {
          case 'p':
            particleCount--;
            break;
          case 'a':
            arrowCount--;
            break;
          case 'w':
            waterCount--;
            break;
          case 'o':
            oilCount--;
            break;
          case 's':
            if(part.isSource)
              seedCount--;
            break;
          case 'f':
            fireCount--;
            break;
          case 'c':
            concreteCount--;
            break;
          case 'd':
            woodCount--;
            break;
          case 'i':
            iceCount--;
            break;
          case 'k':
            fireworkCount--;
            break;
          default:
            break;
        }
        continue;
      }
      else
      {
        //apply wind to velocity
        int fluidIndex = engine.fluidSolver.getIndexForNormalizedPosition(part.loc.x * invWidth, part.loc.y * invHeight);
        part.vel.x += engine.fluidSolver.u[fluidIndex] * (width/20);
        part.vel.y += engine.fluidSolver.v[fluidIndex] * (height/20);
        //accelerate based on gravity
        part.vel.y += environment.gravity;
        part.vel.y += random(-environment.turbulence, environment.turbulence) + environment.wind.y;
        part.vel.x += random(-environment.turbulence, environment.turbulence) + environment.wind.x;
        part.vel.mult(environment.resistance);
        //fade particle
        if(part.lifeSpan > -1)
          part.createFade(part.initAlpha/(frameRate*(part.lifeSpan/1000)));
      }
      part.lifeTime = millis() - part.birthTime;
      //println(part.vel);
      //println(part.loc);
    }
  }
  //returns true if the current emitter type's particles are maxed
  boolean isMaxed()
  {
    boolean answer;
    switch(type)
    {
      case 'p':
        if(particleCount < particle_max)
          return false;
        else
          return true;
      case 'a':
        if(arrowCount < arrow_max)
          return false;
        else
          return true;
      case 'w':
        if(waterCount < water_max)
          return false;
        else
          return true;
      case 'o':
        if(oilCount < oil_max)
          return false;
        else
          return true;
      case 's':
        if(seedCount < seed_max)
          return false;
        else
          return true;
      case 'f':
        if(fireCount < fire_max)
          return false;
        else
          return true;
      case 'c':
        if(concreteCount < concrete_max)
          return false;
        else
          return true;
      case 'd':
        if(woodCount < wood_max)
          return false;
        else
          return true;
      case 'i':
        if(iceCount < ice_max)
          return false;
        else
          return true;
      case 'k':
        if(fireworkCount < firework_max)
          return false;
        else
          return true;
      default:
        return true;
    }
  }
  
  //set methods
  void setLoc(PVector loc)
  {
    this.loc = loc;
  }
  void setBirthRate(float birthRate)
  {
    this.birthRate = birthRate;
  }
  void setBirthForce(PVector birthForce)
  {
    this.birthForce = birthForce;
  }
  void setBirthPath(PVector birthPath)
  {
    this.birthPath = birthPath;
  }
  void setType(char type)
  {
    this.type = type;
  }
  void setSprayWidth(float sprayWidth)
  {
    this.sprayWidth = sprayWidth;
  }
  void calcAndSetRate(int maxNum)
  {
    birthRate = maxNum/((lifeSpan/1000.0) * (sketchFrameRate));
  }
  void setLifeSpan(int lifeSpan)
  {
    this.lifeSpan = lifeSpan;
  }
    void setEnvironment(Environment environment)
  {
    this.environment = environment;
  }
  void turnOn()
  {
    this.isOn = true;
    if(type == 'e')
    {
      Particle part = (Particle) p.get(0);
      part.isErasing = true;
      //println(p.size());
    }
  }
  void turnOff()
  {
    this.isOn = false;
    firstEmit = true;
    firstWoodEmit = true;
    if(type == 'e')
    {
      Particle part = (Particle) p.get(0);
      part.isErasing = false;
    }
  }
  void killEraser()
  {
    Particle part = (Particle) p.get(0);
    part.isErasing = false;
  }
}
