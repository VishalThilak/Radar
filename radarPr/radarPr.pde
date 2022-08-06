import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.serial.*;


Serial myPort;  // creates object from Serial class

// objects to open and play the sound file
Minim minim;
AudioPlayer player;

// variable to store serial data
float distance; 
int angle;
String myString = null;

//text
PFont f;

void setup() 
{
  size(1400,800); 
  background(#000000);
  f = createFont("Arial",16,true);
  
  // load the sound file
  minim = new Minim(this);
  player = minim.loadFile("sonar.aiff");
  
  // link processing to serial port 4
  myPort = new Serial(this, "COM4", 9600);
  
  // delays calling serialEvent() until a new line character
  myPort.bufferUntil('\n');
}

void draw() {
  // simulates motion blur
  noStroke(); // disable drawing the outline
  fill(0,4); 
  rect(0, 0, width, 1010);
  
  //running functions
  drawRadar();
  drawNeedle();
  detectObject();
  drawText();
}

// read the serial port and store the distance and angle values
void serialEvent(Serial myPort){
  myString = myPort.readString();
  if (myString != null) {
    // creates a string array with the commas removed
    String[] list = split(myString, ',');
    
    // removing any white space with trim
    list = trim(list);
    distance = int(list[0]);
    String ang = trim(list[1]);
    angle = int(ang);
  }
}

void drawRadar(){
  noFill();
  strokeWeight(4);
  stroke(#0000FF);
  
  // draw semi-circles for radar
  arc(700, 750, 1200, 1200, 3.14, 6.28);
  arc(700, 750, 900, 900, 3.14, 6.28);
  arc(700, 750, 600, 600, 3.14, 6.28);
  arc(700, 750, 300, 300, 3.14, 6.28);
  
  // draw lines for the radar
  line(100, 750, 1300, 750);
  line(700, 150, 700, 750); 
  line(700 - 300 *sqrt(3), 750 - 300, 700, 750);
  line(700 + 300 *sqrt(3), 750 - 300, 700, 750);
  line(700 - 300, 750 - 300*sqrt(3), 700, 750);
  line(700 + 300, 750 - 300 * sqrt(3), 700, 750);

}

void drawNeedle(){
  noFill();
  strokeWeight(2);
  stroke(#0000FF);
  
  // draws the line based on the current position of the servo motor's angle
  line(700 - 600 * cos(radians(angle)), 750 - 600 * sin(radians(angle)), 700, 750);
}

// drawing the object onto the radar
void detectObject(){
  if (distance > 0 && distance <= 100){
    noFill();
    stroke(#ff0000);
    strokeWeight(6);
    
    // since the radius of the semi circle is 600 units and I'm limiting the range of the sensor to 100 cm
    // that would mean each cm would equate to 600 / 100 = 6 units
    float len = distance * 6;
    line(700 - len * cos(radians(angle)), 750 - len * sin(radians(angle)), 700, 750);
    
    // playing the audio clip
    player.play();
    
    // if audio clip got to the end, rewind it and play it again
    if (player.position() == player.length()){
      player.rewind();
      player.play();
    }
  }
  
}

//drawing all the text onto the screen
void drawText(){
  textFont(f, 25);
  fill(#FFFFFF);
  stroke(#FFFFFF);
  strokeWeight(4);
  
  //drawing the angles on the radar
  text("0º", 60,750);
  text("90º",685,130);
  text("180º",1310,750);
  text("30º",650 - 300 *sqrt(3),740 - 300);
  text("150º",710 + 300 *sqrt(3), 740 - 300);
  text("60º",670 - 300, 730 - 300*sqrt(3));
  text("120º",700 + 300,733 - 300 * sqrt(3));
  
  // Showing the distance of the object on screen
  noFill();
  textFont(f, 30);
  rect(100, 50, 170, 100);
  fill(#FFFFFF);
  text("Distance", 130, 100);
  
  if (distance > 0 && distance <= 100){
    text(distance + " cm", 130, 125);
  }
  else{
    text("0 cm", 130, 125);
  }
}
