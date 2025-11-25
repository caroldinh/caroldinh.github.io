// Created November 2025 by Caroline Dinh
// caroldinh.github.io
// CC BY-NC

float thisX, thisY;
final float GAP = 40;
int numLoops = 0;
final int MAX_LOOPS = 255;
final color BLUE = color(43, 93, 243);
final color BROWN = color(143, 69, 0);
final color BLUE_ACCENT = color(133, 247, 255);
final color BROWN_ACCENT = color(240, 136, 102);
final int MIN_RADIUS = 20;
final int MAX_RADIUS = 120;
final int MARGIN_SIZE = 50;

color fromColor, toColor;

void setup() {

  // Underpainting
  size(3000, 2400);
  background(
    red(BROWN) / 2,
    green(BROWN) / 2,
    blue(BROWN) / 2
    );

  // Add noise to canvas
  loadPixels();
  float r, g, b;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      r = red(pixels[x + y * width]) + random(-50, 50);
      g = green(pixels[x + y * width]) + random(-50, 50);
      b = blue(pixels[x + y * width]) + random(-50, 50);
      pixels[x + y * width] = color(r, g, b);
    }
  }
  updatePixels();

  frameRate(120);
  colorMode(RGB, 255);
  strokeWeight(2);
}

void draw() {

  // Fil the canvas with brush strokes
  if (numLoops < MAX_LOOPS) {

    float radius = random(MIN_RADIUS, MAX_RADIUS);
    color baseColor = lerpColor(BROWN, BLUE, radius / MAX_RADIUS);
    float jitterStrength = random(3, 20);

    float red = red(baseColor) + random(-jitterStrength, jitterStrength);
    float green = green(baseColor) + random(-jitterStrength, jitterStrength);
    float blue = blue(baseColor) + random(-jitterStrength, jitterStrength);

    color brushColor = color(red, green, blue);

    Brush b = new Brush(
      random(width), //startX
      random(height), //startY
      random(height / 100, height / 20), //radius
      brushColor, //color
      random(10, 20), //fillOpacity
      random(width / 20, width / 5), //lengthLeft
      random(width / 20, width / 5), //lengthRight
      100, //jitterStrength
      random(1, width / 80), //strokeGap
      true //hasStroke
      );

    b.draw();
    numLoops++;
    
    // When complete:
  } else {
    
    // Draw margins
    noStroke();
    fill(
    red(BROWN) / 2,
    green(BROWN) / 2,
    blue(BROWN) / 2
    );
    rect(0, 0, MARGIN_SIZE, height);
    rect(0, 0, width, MARGIN_SIZE);
    rect(0, height - MARGIN_SIZE, width, height);
    rect(width - MARGIN_SIZE, 0, width, height);
    
    noFill();
    
    // Draw bezier curves
    int numBezGroups = int(random(3, 6));
    
    for (int g = 0; g < numBezGroups; g++) {
      
      if (int(random(2)) == 0) {
        stroke(BLUE_ACCENT);
      } else {
        stroke(BROWN_ACCENT);
      }
    strokeWeight(2);
    
    float startBez = random(height);
    float endBez = random(height);
    float anchor1X = random(width);
    float anchor1Y = random(height);
    float anchor2X = random(width);
    float anchor2Y = random(height);
    int numBez = int(random(3, 10));
    float bezGap = random(5, height / 80);
    
    for (int i = 0; i < numBez; i++) {
      pushMatrix();
      translate(0, bezGap * i);
      bezier(0, startBez, anchor1X, anchor1Y, anchor2X, anchor2Y, width, endBez);
      popMatrix();
    }
    }
    
    // Draw circles
    int numCircles = int(random(1, 4));
    
    for (int i = 0; i < numCircles; i++) {
      
      if (int(random(2)) == 0) {
        stroke(BLUE_ACCENT);
      } else {
        stroke(BROWN_ACCENT);
      }
      
      float circleX = random(width);
      float circleY = random(height);
      int numOutlines = int(random(10, 50));
      int radFactor = 20;
      
      for (int j = 0; j < numOutlines; j++) {
        
        circle(circleX, circleY, radFactor * (j+1));
        
      }
      
      
    }
    
    noLoop();
    save(str(year()) + str(month()) + str(day()) + "_" + str(hour()) + str(minute()) + str(second()) + str(millis()) + ".png");
  }
}

/**
 * Define the Brush
 */
class Brush {

  float startX;
  float startY;
  float radius;
  color brushColor;
  float fillOpacity;
  float lengthLeft;
  float lengthRight;
  float jitterStrength;
  float strokeGap;
  boolean hasStroke;
  color strokeColor;

  Brush (float startX, float startY, float radius, color brushColor, float fillOpacity,
    float lengthLeft, float lengthRight, float jitterStrength, float strokeGap, boolean hasStroke) {

    this.startX = startX;
    this.startY = startY;
    this.radius = radius;
    this.brushColor = brushColor;
    this.fillOpacity = fillOpacity;
    this.lengthLeft = lengthLeft;
    this.lengthRight = lengthRight;
    this.jitterStrength = jitterStrength;
    this.strokeGap = strokeGap;
    this.hasStroke = hasStroke;

    if (hasStroke) {
      this.strokeColor = color(
        red(brushColor) * 1.5,
        green(brushColor) * 1.5,
        blue(brushColor) * 1.5,
        100
        );
    }
  }

  void draw() {

    float prevX = this.startX;
    float prevRadius = this.radius;

    pushMatrix();
    rotate(random(-PI / 32, PI / 32));

    // Brushstroke fill
    for (float i = -this.lengthLeft; i < lengthRight; i++) {

      float red = red(this.brushColor) + random(-jitterStrength, jitterStrength);
      float green = green(this.brushColor) + random(-jitterStrength, jitterStrength);
      float blue = blue(this.brushColor) + random(-jitterStrength, jitterStrength);

      if (random(20) == 0) {
        red = random(255);
        green = random(255);
        blue = random(255);
      }

      fill(red, green, blue, this.fillOpacity);

      float radius;
      if (i < 0) {
        radius = this.radius * ((lengthLeft - abs(i)) / lengthLeft);
      } else {
        radius = this.radius * ((lengthRight - i) / lengthRight);
      }

      float newX = this.startX + (this.strokeGap * i);
      ellipse(newX, this.startY, radius, radius);

      // Brushstroke outline and hatches
      if (this.radius > 70) {
        stroke(this.strokeColor);
        line(prevX, this.startY - (prevRadius / 2), newX, this.startY - (radius / 2));
        line(prevX, this.startY + (prevRadius / 2), newX, this.startY + (radius / 2));
        line(newX, this.startY - (radius / 2), newX, this.startY + (radius / 2));
        prevX = newX;
        prevRadius = radius;
      }

      noStroke();
    }

    popMatrix();
  }
}
