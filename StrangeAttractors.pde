StrangePoint[] sp;
int numPoints;
int numTrailPoints;

float hu = 0;

int mode = 1;

int scl = 6;
int extraScaleFactor = 1;

StrangeTrail[] trail;

float moveHorz = 0;
float moveVert = 0;

float xBaseAngle = 0;
float yBaseAngle = 0;
float xAngle = 0;
float yAngle = 0;
float previousMouseXForAngle = -1;
float previousMouseYForAngle = -1;

float previousMouseX = -1;
float previousMouseY = -1;
float moveBaseX = 0;
float moveBaseY = 0;

void setup() {
  size(800, 600, P3D);
  
  colorMode(HSB);
  frameRate(60);
  
  Init(50, 50, 0.01, 0.15);
}

void draw() {
  background(51);

  float dt = 0.01;

  for (int i = 0; i < sp.length; i++) {
    updatePoint(sp[i], dt, i);
  }
  
  noFill();

  translate(width/2, height/2);
  translate(moveHorz, moveVert);
  if (mode == 2) {
    rotateY(90);
  } else if (mode == 3) {
    rotateY(135);
  } else if (mode == 5) {
    rotateX(180);
  } else if (mode == 6) {
  }
  rotateX(-yAngle / 500f);
  rotateY(-xAngle / 500f);
  
  println("X: " + yAngle + " | Y: " + xAngle);
  scale(scl);

  for (StrangeTrail st : trail) {
    ArrayList<PVector> points = st.points;
    
    for (int i = 0; i < points.size(); i++) {
      PVector v = null;
      if (points.get(i) != null) {
        v = points.get(i);
      }
      PVector p = null;
      
      int alpha = calculateAlpha(i);
      stroke(hu, 255, 255, alpha);

      
      if (i > 0) {
        if (points.get(i-1) != null) {
          p = points.get(i-1);
        }
      }
      if (p != null && v != null) {
        strokeWeight(0.25);
        line(p.x * extraScaleFactor, p.y * extraScaleFactor, p.z * extraScaleFactor, v.x * extraScaleFactor, v.y * extraScaleFactor, v.z * extraScaleFactor);
      }
    
    }
    
    strokeWeight(0.5);
    stroke(255);
    point(points.get(0).x * extraScaleFactor, points.get(0).y * extraScaleFactor, points.get(0).z * extraScaleFactor);
  }
  
  hu += 0.1;
  if (hu > 255) {
    hu = 0;
  }
  
  // stats
  surface.setTitle("Strange Attractors : " + AttractorUtils.GetAttractorName(mode) + " | " + numPoints + " Points" + " | " + round(frameRate) + " FPS");
}

void mouseDragged() {
  if (mouseButton == LEFT) {
    moveHorz = moveBaseX + mouseX - previousMouseX;
    moveVert = moveBaseY + mouseY - previousMouseY;
  } else if (mouseButton == RIGHT) {
    xAngle = xBaseAngle + (mouseX - previousMouseXForAngle);
    yAngle = yBaseAngle + (mouseY - previousMouseYForAngle);
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    previousMouseX = mouseX;
    previousMouseY = mouseY;
  } else if (mouseButton == RIGHT) {
    previousMouseXForAngle = mouseX;
    previousMouseYForAngle = mouseY;
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    moveBaseX += mouseX - previousMouseX;
    moveBaseY += mouseY - previousMouseY;
  } else if (mouseButton == RIGHT) {
    xBaseAngle += mouseX - previousMouseXForAngle;
    yBaseAngle += mouseY - previousMouseYForAngle;
  }
}

void mouseWheel(MouseEvent event) {
  scl -= event.getCount();
}

void keyPressed() {
  if (keyCode == UP) {
    scl++;
  } else if (keyCode == DOWN && scl > 0) {
    scl--;
  } else if (keyCode == RIGHT && numPoints < 500) {
    switch(numPoints) {
      case 200:
        numPoints = 500;
        Init(numPoints, numTrailPoints, 0.01, 0.15);
        return;
      case 100:
        numPoints = 200;
        Init(numPoints, numTrailPoints, 0.01, 0.15);
        return;
      case 50:
        numPoints = 100;
        Init(numPoints, numTrailPoints, 0.01, 0.15);
        return;
      case 25:
        numPoints = 50;
        Init(numPoints, numTrailPoints, 0.01, 0.15);
        return;
      case 10:
        numPoints = 25;
        Init(numPoints, numTrailPoints, 0.01, 0.15);
        return;
      case 1: 
        numPoints = 10;
        Init(numPoints, numTrailPoints, 0.01, 0.15);
        return;
      default:
        return;
    }
  } else if (keyCode == LEFT && numPoints > 1) {
    switch(numPoints) {
      case 500:
        numPoints = 200;
        Init(numPoints, numTrailPoints, 0.01, 0.15);
        return;
      case 200:
        numPoints = 100;
        Init(numPoints, numTrailPoints, 0.01, 0.15);
        return;
      case 100:
        numPoints = 50;
        Init(numPoints, numTrailPoints, 0.01, 0.15);
        return;
      case 50:
        numPoints = 25;
        Init(numPoints, numTrailPoints, 0.01, 0.15);
        return;
      case 25:
        numPoints = 10;
        Init(numPoints, numTrailPoints, 0.01, 0.15);
        return;
      case 10: 
        numPoints = 1;
        Init(numPoints, numTrailPoints, 0.01, 0.15);
        return;
      default:
        return;
    }
  } else if (key == '1') {
    mode = 1;
    extraScaleFactor = 1;
    AttractorUtils.UpdateConstants(mode);
    Init(numPoints, numTrailPoints, 0.01, 0.15);
  } else if (key == '2') {
    mode = 2;
    extraScaleFactor = 15;
    AttractorUtils.UpdateConstants(mode);
    Init(numPoints, numTrailPoints, 0.01, 0.15);
  } else if (key == '3') {
    mode = 3;
    extraScaleFactor = 15;
    AttractorUtils.UpdateConstants(mode);
    Init(numPoints, numTrailPoints, 0.01, 0.15);
  } else if (key == '4') {
    mode = 4;
    extraScaleFactor = 3;
    AttractorUtils.UpdateConstants(mode);
    Init(numPoints, numTrailPoints, 0.01, 0.15);
  } else if (key == '5') {
    mode = 5;
    extraScaleFactor = 15;
    AttractorUtils.UpdateConstants(mode);
    Init(numPoints, numTrailPoints, 0.01, 0.15);
  } else if (key == '6') {
    mode = 6;
    extraScaleFactor = 3;
    AttractorUtils.UpdateConstants(mode);
    Init(numPoints, numTrailPoints, 0.01, 0.15);
  }
}

void updatePoint(StrangePoint p, float dt, int index) {
  float dx = AttractorUtils.GetDX(p.x, p.y, p.z, dt, mode);
  //float dx = (a * (p.y-p.x)) * dt;
  p.x += dx;

  float dy = AttractorUtils.GetDY(p.x, p.y, p.z, dt, mode);
  //float dy = (p.x * (b-p.z) - p.y) * dt;
  p.y += dy;

  float dz = AttractorUtils.GetDZ(p.x, p.y, p.z, dt, mode);
  //float dz = (p.x * p.y - c * p.z) * dt;
  p.z += dz;

  trail[index].addTrailPoint(new PVector(p.x, p.y, p.z));
}

int calculateAlpha(int i) {
  int result = 255;
  
  if (numTrailPoints > 10) {
    if (i == numTrailPoints-1) {
      result = 50;
    } else if (i == numTrailPoints-1) {
      result = 100;
    } else if (i == numTrailPoints-2) {
      result = 150;
    } else if (i == numTrailPoints-3) {
      result = 175;
    } else if (i == numTrailPoints-4) {
      result = 200;
    } else if (i == numTrailPoints-5) {
      result = 225;
    }
  } else if (numTrailPoints > 20) {
    if (i == numTrailPoints-1) {
      result = 25;
    } else if (i == numTrailPoints-2) {
      result = 25;
    } else if (i == numTrailPoints-3) {
      result = 50;
    } else if (i == numTrailPoints-4) {
      result = 75;
    } else if (i == numTrailPoints-5) {
      result = 100;
    } else if (i == numTrailPoints-6) {
      result = 150;
    } else if (i == numTrailPoints-8) {
      result = 175;
    } else if (i == numTrailPoints-9) {
      result = 200;
    } else if (i == numTrailPoints-10) {
      result = 225;
    }
  }
  return result;
}

void Init(int pointNum, int trailPointNum, float startingVal, float variation) {
  numPoints = pointNum;
  numTrailPoints = trailPointNum;
  
  sp = new StrangePoint[numPoints];
  trail = new StrangeTrail[numPoints];
  for (int i = 0; i < numPoints; i++) {
    float varX = random(-variation, variation);
    float varY = random(-variation, variation);
    float varZ = random(-variation, variation);
    
    sp[i] = new StrangePoint(startingVal + varX, startingVal + varY, startingVal + varZ);
    
    trail[i] = new StrangeTrail(numTrailPoints);
  }
}
