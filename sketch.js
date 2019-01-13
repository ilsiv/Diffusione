let img;

let grid;
let next;

let th = 255;

let int = 0;

let dA = 1;
let dB = 0.5;
let feed = 0.055;
let k = 0.062;

function preload() {
  img = loadImage('hopper.jpg');
}

function setup() {

  img.resize(0, 600);
  var canvas = createCanvas(img.width, img.height);
  // var canvas = createCanvas(400, 400);
  canvas.id('sketch-container');
  image(img, 0, 0);
  grid = [];
  next = [];
  loadPixels();
  for (let i = 0; i < width; i++) {
    grid[i] = [];
    next[i] = [];
    for (let j = 0; j < height; j++) {
      let index = (i + j * width) * 4;
      let tmp = (pixels[index + 0] + pixels[index + 1] + pixels[index + 2]) / 3;
      let vv =constrain(tmp,0,1);
      if (tmp >200) {
        grid[i][j] = {
          a: vv,
          b: 0
        };
        next[i][j] = {
          a: vv,
          b: 0
        };
      } else if (tmp <30) {
        grid[i][j] = {
          a: 0,
          b: vv
        };
        next[i][j] = {
          a: 0,
          b: vv
        };
      } else {
        grid[i][j] = {
          a: 0,
          b: 0
        };
        next[i][j] = {
          a: 0,
          b: 0
        };
      }
    }
  }
}



function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}


function draw() {
  // noLoop();
  // frameRate(10);

  update();

  loadPixels();
  for (let i = 1; i < width - 1; i++) {
    for (let j = 1; j < height - 1; j++) {
      let pix = (i + j * width) * 4;
      let a = next[i][j].a;
      let b = next[i][j].b;
      let c = floor((a - b) * 255);
      c = constrain(c, 0, 255);
      // pixels[pix + 0] = c;
      // pixels[pix + 1] = c;
      // pixels[pix + 2] = c;
      pixels[pix + 3] = 255-c;
    }
  }
  updatePixels();


}


function mousePressed() {
  update();
  redraw();
  // int++;

  grid[mouseX][mouseY].b = 1;

}

function update() {
  for (let i = 1; i < width - 1; i++) {
    for (let j = 1; j < height - 1; j++) {
      let a = grid[i][j].a;
      let b = grid[i][j].b;
      // next[i][j].a = 1;
      next[i][j].a = a +
        (dA * laplaceA(i, j)) -
        (a * b * b) +
        (feed * (1 - a));

      // next[i][j].b = 0;
      next[i][j].b = b +
        (dB * laplaceB(i, j)) +
        (a * b * b) -
        ((k + feed) * b);
      next[i][j].a = constrain(next[i][j].a, 0, 1);
      next[i][j].b = constrain(next[i][j].b, 0, 1);
      // next[i][j].a = round(next[i][j].a);
      // next[i][j].b = round(next[i][j].b);
    }
  }
  swap();
}



function laplaceA(x, y) {
  var sumA = 0;
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

function laplaceB(x, y) {
  var sumB = 0;
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


function swap() {
  let temp = grid;
  grid = next;
  next = temp;
}
