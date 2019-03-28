PImage img;

String[] tit;

Diff[][] grid;
Diff[][] next;

int th = 255;

int inte = 0;

float dA = 1;
float dB = 0.5;
float feed = 0.055;
float k = 0.062;

void settings(){
//tit = new String[3];
//tit =  {"hopper.jpg", "las-chicas-del-cable.jpg", "parco.jpg"};
  //img = loadImage(tit[floor(random(0,3))]);
img = loadImage("hopper.jpg");

  size(700,800);
}
void setup() {
  
  //frameRate(1);
filter(THRESHOLD);  
  image(img, 0, 0);

  grid = new Diff[width][height];
  next = new Diff[width][height];
  loadPixels();
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {

      int index = (i + j * width);

      color tmp = pixels[index];
      grid[i][j] = new Diff (0, 0);
      next[i][j] = new Diff (0, 0);

      if (brightness(tmp) > 127) {
        //println("dentro");

        float a = map(brightness(tmp),0,255,0,1);
        float b = 1-a;
        
        grid[i][j] = new Diff(a, b);
        next[i][j] = new Diff(a, b);
        //pixels[index] = color(a*255,b*255,255);
      }
      /* else {//if (tmp2 > 50) {
        //println("fuori");
        grid[i][j] = new Diff(0.0, 1.0);
        next[i][j] = new Diff(0.0, 1.0);
        pixels[index] = color(0,0,0);
      }*/
    }
  }
  updatePixels();
}



void draw() {
  //noLoop();
  // frameRate(10);
  //image(img, 0, 0);
  update();

  loadPixels();
  for (int i = 1; i < width - 1; i++) {
    for (int j = 1; j < height - 1; j++) {
      int pix = (i + j * width);
      float a = next[i][j].a;
      float b = next[i][j].b;
      //int c = floor((a - b) * 255);
      //c = constrain(c, 0, 255);
      color c = color(a*255,a*255,a*255);
      //pixels[pix] =  color(c);
      pixels[pix] =  c;
    }
  }
  updatePixels();
  
  if(frameCount % 100 == 0){
    println(frameRate);
  }
}


void  mousePressed() {
  update();
  redraw();
  // int++;
  println(  grid[mouseX][mouseY].a, grid[mouseX][mouseY].b);

  grid[mouseX][mouseY].a = 1;
  grid[mouseX][mouseY].b = 0;

  println(  grid[mouseX][mouseY].a, grid[mouseX][mouseY].b);
}

void  update() {
  for (int i = 1; i < width - 1; i++) {
    for (int j = 1; j < height - 1; j++) {
      float a = grid[i][j].a;
      float b = grid[i][j].b;
      next[i][j].a = a +
        (dA * laplaceA(i, j)) -
        (a * b * b) +
        (feed * (1 - a));

      next[i][j].b = b +
        (dB * laplaceB(i, j)) +
        (a * b * b) -
        ((k + feed) * b);
      next[i][j].a = constrain(next[i][j].a, 0, 1);
      next[i][j].b = constrain(next[i][j].b, 0, 1);
    }
  }
  swap();
}



float laplaceA(int x, int y) {
  float sumA = 0;
  sumA += grid[x][y].a * -1;
  sumA += grid[x - 1][y].a * 0.2;
  sumA += grid[x + 1][y].a * 0.2;
  sumA += grid[x][y + 1].a * 0.2;
  sumA += grid[x][y - 1].a * 0.2;
  sumA += grid[x - 1][y - 1].a * 0.05;
  sumA += grid[x + 1][y - 1].a * 0.05;
  sumA += grid[x + 1][y + 1].a * 0.05;
  sumA += grid[x - 1][y + 1].a * 0.05;
  return sumA;
}

float laplaceB(int x, int y) {
  float sumB = 0;
  sumB += grid[x][y].b * -1;
  sumB += grid[x - 1][y].b * 0.2;
  sumB += grid[x + 1][y].b * 0.2;
  sumB += grid[x][y + 1].b * 0.2;
  sumB += grid[x][y - 1].b * 0.2;
  sumB += grid[x - 1][y - 1].b * 0.05;
  sumB += grid[x + 1][y - 1].b * 0.05;
  sumB += grid[x + 1][y + 1].b * 0.05;
  sumB += grid[x - 1][y + 1].b * 0.05;
  return sumB;
}


void swap() {
  Diff[][] temp = grid;
  grid = next;
  next = temp;
}
