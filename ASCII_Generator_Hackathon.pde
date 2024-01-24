import milchreis.imageprocessing.*;
import milchreis.imageprocessing.utils.*;

import processing.core.PApplet;
import processing.core.PFont;
import processing.core.PGraphics;
import processing.core.PImage;


PImage img;
PImage raw_img;
PGraphics canvas;
String characters;
int foregroundColor;
int backgroundColor;
int fontsize;
PFont font;
boolean colorImage;

int fontSizeMin;
int fontSizeMax;

PImage screen;

PImage[] screens;

void setup() {
  size(750, 750);
  raw_img = loadImage("MeNRemiPFP.JPG");
  img = raw_img.copy();
  img.resize(width, height);
  characters = "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\\|()1{}[]?-_+~<>i!lI;:,\"^`'. ";
  
  colorImage = false;
  foregroundColor = 0;
  backgroundColor = 255;
  fontSizeMin = 1;
  fontSizeMax = 10;
  fontsize = fontSizeMax - 1;
  font = img.parent.createFont("Monospaced", fontsize);
  canvas = img.parent.createGraphics(width, height);
  
  screens = new PImage[fontSizeMax * 2];
}

void draw() {
  //backgroundColor = int(map(mouseY, 0, height, 0, 255));
  fontsize = int(map(mouseX, 0, width, fontSizeMax, fontSizeMin));
  int index = 0;
  if(colorImage == true) {
    index = ((fontsize - 1) * 2) + 1;
  } else {
    index = (fontsize - 1) * 2;
  }
  screens[index] = ASCII(img, fontsize, foregroundColor, backgroundColor, colorImage);
    //screen = ASCII(img, fontsize, foregroundColor, backgroundColor, colorImage);
  if (mousePressed == true) {
    image(img, 0, 0);
  } else {
    image(screens[index], 0, 0);
  }
}


//PImage ASCII(PImage input, String characterset, int fontsize, int foreground, int background, boolean toneInColor) {?
PImage ASCII(PImage input, int fs, int foreground, int background, boolean inColor) {
  canvas.beginDraw();
  canvas.fill(background);
  canvas.rect(0, 0, canvas.width, canvas.height);

  canvas.fill(foreground);
  canvas.textFont(font, fs);

  for (int y = 0; y < input.height; y += fs) {
    for (int x = 0; x < input.width; x += fs) {

      int pixel = input.get(x, y);
      int tone = getTone(input, y, x);
      
      if(inColor == true) {
        canvas.fill(pixel);
      }

      int characterIndex = int(map(tone, 0, 255, 0, characters.length() - 1));

      canvas.text(characters.charAt(characterIndex), x, y);
    }
  }

  canvas.endDraw();
  return canvas.get();
}


// I don't know how this works
private static int getTone(PImage input, int y, int x) {
  int pixel = input.get(x, y);
  int r = (pixel >> 16) & 0xff;
  int g = (pixel >> 8) & 0xff;
  int b = (pixel & 0xff);
  return (r + g + b) / 3;
}

void keyPressed() {
  boolean oldColorImage = colorImage;
  if (key == ' ' && oldColorImage == colorImage) {
    colorImage = !colorImage;
  }
  
}
