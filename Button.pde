
class Button {
  String type;
  PImage b;
  //Main menu images
  PImage playOver;
  PImage musicOver;
  PImage backOver;
  PImage calibOver;
  PImage exitPic;
  
  //In game rollovers
  PImage eraseO;
  PImage stoneO;
  PImage iceO;
  PImage worksO;
  PImage oilO;
  PImage waterO;
  PImage fireO;
  PImage seedO;
  PImage noMelO;
  PImage noRhyO;

  int X;
  int Y;
  int wide;
  int high;
  int sec;
  int count;
  int menuSoundBuffer = 0;

  Button(String inType, int x, int y) {
    X = x;
    Y = y;
    type = inType;
    //main menu rollovers
    playOver = loadImage("playOver.gif");
    musicOver = loadImage("musicOver.gif");
    backOver = loadImage("backOver.gif");
    calibOver = loadImage("calibOver.gif");
    
    //ingame rollovers
    eraseO = loadImage("eraseO.gif");
    stoneO = loadImage("stoneO.gif");
    iceO = loadImage("iceO.gif");
    worksO = loadImage("worksO.gif");
    oilO = loadImage("oilO.gif");
    waterO = loadImage("waterO.gif");
    fireO = loadImage("fireO.gif");
    seedO = loadImage("seedO.gif");
    noMelO = loadImage("noMelO.gif");
    noRhyO = loadImage("noRhyO.gif");

    //fills the b image with 
    if(inType == "play")
    {
      b = loadImage("play.gif");
    }
    else if(inType == "music")
    {
      b = loadImage("music.gif");
    }
    else if(inType == "back")
    {
      b = loadImage("back.gif");
    }
    else if(inType == "calib")
    {
      b = loadImage("calib.gif");
    }
    else if(inType == "mel1")
    {
      b = loadImage("mel1.gif");
    }
    else if(inType == "mel2")
    {
      b = loadImage("mel2.gif");
    }
    else if(inType == "rhy1")
    {
      b = loadImage("rhy1.gif");
    }
    else if (inType == "rhy2")
    {
      b = loadImage("rhy2.gif");
    }
    else if (inType == "rhy3")
    {
      b = loadImage("rhy3.gif");
    }
    else if (inType == "rhy4")
    {
      b = loadImage("rhy4.gif");
    }
    else if (inType == "exit")
    {
      b = loadImage("exit.gif");
    }
    else if (inType == "erase")
    {
      b = loadImage("erase.gif");
    }
    else if (inType == "stone")
    {
      b = loadImage("stone.gif");
    }
    else if (inType == "ice")
    {
      b = loadImage("ice.gif");
    }
    else if (inType == "works")
    {
      b = loadImage("works.gif");
    }
    else if (inType == "oil")
    {
      b = loadImage("oil.gif");
    }
    else if (inType == "water")
    {
      b = loadImage("water.gif");
    }
    else if (inType == "fire")
    {
      b = loadImage("fire.gif");
    }
    else if (inType == "seed")
    {
      b = loadImage("seed.gif");
    }
    else if (inType == "clear")
    {
      b = loadImage("clear.gif");
    }
    else if (inType == "noMel")
    {
      b = loadImage("noMel.gif");
    }
    else if (inType == "noRhy")
    {
      b = loadImage("noRhy.gif");
    }
  }

  void animate() {
    rect(0,0,width,Y);
    Y += 6;
    if( Y >= 0)
      Y = 0;
      rect(0,0,width,Y);
  }

  void animateOut() {
    rect(0,0,width,Y);
    Y -= 6;
    if( Y <= -80 )
      Y = -80 ;
      
  }

  void run(int i) {
    image(b, X, Y);
    if(menuSoundBuffer >0)
      menuSoundBuffer--;
    if(ui.inGame == true && (wand1.y < 63 || wand2.y < 63))
    //if(ui.inGame == true && mouseY < 102)
    {
      animate();
    }
    else if(ui.inGame == true) {
      animateOut();
    }
    //menu buttons by only the first wand
    if(ui.cursorX > X && ui.cursorX < X + b.width && ui.cursorY > Y && ui.cursorY < Y + b.height && (glob.wand1Pressed() || mousePressed))
    {
      //text(type,width/2,height/2);
      if(menuSoundBuffer == 0)
      {
        music.playMenuSound();
        menuSoundBuffer = 10;
      }
      if(type == "play")
      { 
        setHSB(233, 1,1,1);
        ui.inGame = true;        
        for(int k = 0; k < 10; k++)
        {
          ui.Main.buttonArray[k] = ui.Main.gameArray[k];
        }
        page = 'v';
      }
      else if (type == "music")
      {
        ui.inMusic = true;
        for(int k = 0; k < 10; k++)
        {
          if(k > ui.Main.musicArray.length - 1)
          {
            ui.Main.buttonArray[k] = null;
          }
          else {
            ui.Main.buttonArray[k] = ui.Main.musicArray[k];
          }
        }
        page = 'm';
      }
      else if (type == "back")
      {
        ui.inMusic = false;
        for (int k = 0; k < 10; k++)
        {
          if( k > ui.Main.mainArray.length - 1)
          {
            ui.Main.buttonArray[k] = null;
          }
          else {
            ui.Main.buttonArray[k] = ui.Main.mainArray[k];
          }
        }
        page = 'u';
      }
      else if(type == "exit")
      {
        ui.inGame = false;
        animateOut();
        for (int k = 0; k < 10; k++)
        {
          if( k > ui.Main.mainArray.length - 1)
          {
            ui.Main.buttonArray[k] = null;
          }
          else {
            ui.Main.buttonArray[k] = ui.Main.mainArray[k];
          }
        }
        reset();
        page = 'u';
      }
      else if(type == "calib")
      {
        ui.inCalib = true;
        for(int k = 0; k < 10; k++)
        {
          if(k > ui.Main.calibArray.length - 1)
          {
            ui.Main.buttonArray[k] = null;
          }
          else {
            ui.Main.buttonArray[k] = ui.Main.calibArray[k];
          }
        }
        page = 'c';
      } 
      else if (type == "erase")
      {
        changeParticle('e', 0);
      }
      else if(type == "fire")
      {
        changeParticle('f', 0);
      }
      else if(type == "stone")
      {
        changeParticle('c', 0);
      }
      else if(type == "ice")
      {
        changeParticle('i', 0);
      }
      else if(type == "works")
      {
        changeParticle('k', 0);
      }
      else if(type == "oil")
      {
        changeParticle('o', 0);
      }
      else if(type == "water")
      {
        changeParticle('w', 0);
      }
      else if(type == "seed")
      {
        changeParticle('s', 0);
      }
      else if(type == "rhy1")
      {
        music.setRhythm(0);
      }
      else if(type == "rhy2")
      {
        music.setRhythm(1);
      }
      else if(type == "rhy3")
      {
        music.setRhythm(2);
      }
      else if(type == "rhy4")
      {
        music.setRhythm(3);
      }
      else if(type == "mel1")
      {
        music.setMelody(0);
      }
      else if(type == "mel2")
      {
        music.setMelody(1);
      }
      else if(type == "noMel")
      {
        music.noMelody();
      }
      else if(type == "noRhy")
      {
        music.noRhythm();
      }
      else if(type == "clear")
      {
        reset();
      }
    }
    //ingame ui buttons by either wand
    else if(ui.cursor2X > X && ui.cursor2X < X + b.width && ui.cursor2Y > Y && ui.cursor2Y < Y + b.height && glob.wand2Pressed())
    {
      if(type == "fire")
      {
        changeParticle('f', 1);
      }
      else if (type == "erase")
      {
        changeParticle('e', 1);
      }
      else if(type == "stone")
      {
        changeParticle('c', 1);
      }
      else if(type == "ice")
      {
        changeParticle('i', 1);
      }
      else if(type == "works")
      {
        changeParticle('k', 1);
      }
      else if(type == "oil")
      {
        changeParticle('o', 1);
      }
      else if(type == "water")
      {
        changeParticle('w', 1);
      }
      else if(type == "seed")
      {
        changeParticle('s', 1);
      }
      else if(type == "clear")
      {
        reset();
      }
      else if(type == "exit")
      {
        ui.inGame = false;
        animateOut();
        for (int k = 0; k < 10; k++)
        {
          if( k > ui.Main.mainArray.length - 1)
          {
            ui.Main.buttonArray[k] = null;
          }
          else {
            ui.Main.buttonArray[k] = ui.Main.mainArray[k];
          }
        }
        reset();
        page = 'u';
      }
      
    }
    else if(ui.cursorX > X && ui.cursorX < X + b.width && ui.cursorY > Y && ui.cursorY < Y + b.height)
    {
      if(type == "play")
      {
        image(playOver, X, Y);
      }
      else if(type == "music")
      {
        image(musicOver, X, Y);
      }
      else if(type == "back")
      {
        image(backOver, X, Y);
      }
      else if(type == "calib")
      {
        image(calibOver, X, Y);
      }
      else if(type == "rhy1")
      {
        image(rhy1Over, X, Y);
      }
      else if(type == "rhy2")
      {
        image(rhy2Over, X, Y);
      }
      else if(type == "rhy3")
      {
        image(rhy3Over, X, Y);
      }
      else if(type == "rhy4")
      {
        image(rhy4Over, X, Y);
      }
      else if(type == "mel1")
      {
        image(mel1Over, X, Y);
      }
      else if(type == "mel2")
      {
        image(mel2Over, X, Y);
      }
      else if(type == "erase")
      {
        image(eraseO,X,Y);
      }
      else if(type == "stone")
      {
        image(stoneO,X,Y);
      }
      else if(type == "ice")
      {
        image(iceO,X,Y);
      }
      else if(type == "works")
      {
        image(worksO,X,Y);
      }
      else if(type == "oil")
      {
        image(oilO,X,Y);
      }
      else if(type == "water")
      {
        image(waterO,X,Y);
      }
      else if(type == "fire")
      {
        image(fireO,X,Y);
      }
      else if(type == "seed")
      {
        image(seedO,X,Y);
      }
      else if(type == "noMel")
      {
        image(noMelO,X,Y);
      }
      else if(type == "noRhy")
      {
        image(noRhyO,X,Y);
      }
    }
  }
  boolean isOverButton()
  {
    if(ui.cursorX > X && ui.cursorX < X + b.width && ui.cursorY > Y && ui.cursorY < Y + b.height)
      return true;
    else if(ui.cursor2X > X && ui.cursor2X < X + b.width && ui.cursor2Y > Y && ui.cursor2Y < Y + b.height)
      return true;
    else
      return false;
  }
}
