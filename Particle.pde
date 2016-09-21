// a basic noise-based moving particle
class Particle {
  // unique id, (previous) position, speed
  float id, x, y, xp, yp, s, d;
  color col; // color
  float vlionX, vlionY; // 在vlion图像中的目标位置
  float bodyX, bodyY;
  int life;
  Particle(float id) {
    this.id = id;
    s = random(2, 6); // speed
  }

  void updateAndDisplay() {
    if (life > 0) {
      this.trackBody();
      return;
    }
    // let it flow, end with a new x and y position
    id += 0.01;
    d = (noise(id, x/globalY, y/globalY)-0.5)*globalX;
    x += cos(radians(d))*s;
    y += sin(radians(d))*s;

    // constrain to boundaries
    if (x<-10) x=xp=kinectWidth+10;
    if (x>kinectWidth+10) x=xp=-10;
    if (y<-10) y=yp=kinectHeight+10;
    if (y>kinectHeight+10) y=yp=-10;

    // if there is a polygon (more than 0 points)
    if (poly.npoints > 0) {
      // if this particle is outside the polygon
      if (!poly.contains(x, y)) {
        // while it is outside the polygon
        while (!poly.contains (x, y)) {
          // randomize x and y
          x = random(kinectWidth);
          y = random(kinectHeight);
        }
        // set previous x and y, to this x and y
        xp=x;
        yp=y;
      }
    }else{
      // life = 100;
    }

    // individual particle color
    stroke(col);
    // line from previous to current position
    line(xp, yp, x, y);
    // set previous to current position
    xp=x;
    yp=y;
  }
  void formVlion(){
    
    // 命令粒子们构成Vlion的字样
    xp = x;
    yp = y;
    id += 0.01;
    d = (noise(id, x/globalY, y/globalY)-0.5)*globalX;
    x += cos(radians(d))*s * vlionM;
    y += sin(radians(d))*s * vlionM;

    x += max(min((vlionX - x) * 0.05, 8), -8);
    y += max(min((vlionY - y) * 0.05, 8), -8);

    stroke(col);
    line(xp, yp, x, y);

  }

  void trackBody(){
  // 这个函数用来尝试追踪构成人形，每5帧重新采样
  xp=x;
  yp=y;
  id += 0.01;
  d = (noise(id, x/globalY, y/globalY)-0.5)*globalX;
  x += cos(radians(d))*s;
  y += sin(radians(d))*s;


  if (frameCount % 4 == 0){
    life --;
    if (poly.npoints > 0) {
      if (poly.contains(x, y)) {
        life = 0;   
        stroke(col);
        line(xp, yp, x, y);     
        return;
      }
      // if this particle is outside the polygon
      if (!poly.contains(bodyX, bodyY)) {
        // while it is outside the polygon
        while (!poly.contains (bodyX, bodyY)) {
          // randomize x and y
          bodyX = random(kinectWidth);
          bodyY = random(kinectHeight);
        }
        // set previous x and y, to this x and y
        
        // x = bodyX;
        // y = bodyY;
        // x += (bodyX - x) * 0.1;
        // y += (bodyY - y) * 0.1;
      }
    }
  }
  x += constrain((bodyX - x) * 0.1, -10, 10);
  y += constrain((bodyY - y) * 0.1, -10, 10);
  stroke(col);
  line(xp, yp, x, y);
}
}

