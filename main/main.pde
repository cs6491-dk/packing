// Lectures in Graphics (LiG)
// Author(s): Kyle Harrigan, Donnie Smith
// Subject: Packing Game
// Class: CS6491
// Last update on: August 22, 2012
// $Id$
// Usage: press 'r' to see rows
//        click&drag mouse horizontally to change number of disks
// Contains: tools for using colors, images, screen (help) text
// Comments: Demonstrates loops, classes, 2D transforms

//**************************** global variables ****************************
Boolean scribeText=true; // toggle for displaying of help text
String title ="CS6491 Fall 2012, Project 1: Packing", 
  name1 ="Kyle Harrigan", name2="Donnie Smith", 
  menu="?:help(on/off), !:snapPicure,  r: reset, d: player done with turn, Q:quit", 
  guide="press&drag mouse right/left to move disks";
MouseController mc;
AIPlayer ai;
Disks disks1; // player 1 disks
Disks disks2; // player 2 disks
Disk bound_1; // bound for player 1
Disk bound_2; // bound for player 2
float min_r_seen = 5e10;
Disks min_r_disks = null;
int turn=0; // player 1
// color variables are defined in the "utilities" tab and set in "defineColors" during initialization

//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(800, 600);            // canvas size
  disks1 = new Disks();
  disks2 = new Disks();
  loadDiskConfig();
  disks1.sort();
  disks2.sort();
  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  myFace1 = loadImage("data/kwharrigan.jpg");
  myFace2 = loadImage("data/dsmith.png");
  // sets HSB color mode and THEN defines values for color variables
  defineMyColors();
  mc = new MouseController();
  mc.set_turn();
  ai = new AIPlayer(width/4, height/2, disks1);
}

//**************************** display current frame ****************************
// executed at each frame
void draw() {
  background(white);
  setTurnText(turn);
  pen(black, 3);
  drawDividers(); // Draw a divider for player1/player2 spaces

    // shows mouse location or whether mouse is pressed an d which key is pressed               
  if (keyPressed) {
    fill(black); 
    text(str(key), mouseX-2, mouseY);
  }
  if (turn == 0) {
    if (ai.update()) {
      turn = 1;
      mc.set_turn();
    }
  }
  else if (turn == 1) {
    mc.update();
  }
  displayDisks();
  if (!mousePressed) scribeMouseCoordinates();
  if (scribeText) displayTextImage();
  bound_1 = minbound(disks1).show_outline();
  if (bound_1.get_r() < min_r_seen) 
  {  
    min_r_seen = bound_1.get_r();
    min_r_disks = new Disks(disks1);
    println("min_r_disks bound: " + minbound(min_r_disks).get_r());
  }
  bound_2 = minbound(disks2).show_outline();
  //Disk tmp = new Disk(30, 30, 50);
  text("Min bound seen: " + min_r_seen, 30, 100);
}

// User actions
// executed each time a key is pressed: sets the "keyPressed" and "key" state variables,
// till it is released or another key is pressed or released
void keyPressed() {
  if (key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if (key=='!') snapPicture(); // make a picture of the canvas
  if (key=='d') {
    turn += 1;
    if (turn == 2) {
      println("Game over, score both players");
    }
    
    println("Setting disks1 to min_r_disks");
    disks1 = min_r_disks; // change the disks1 reference to point to min_r_disks
    bound_1 = minbound(disks1).show_outline();
    println("Bound1: " + bound_1.get_r());
    println("min_r_disks bound: " + minbound(min_r_disks).get_r());
    mc.set_turn();
   
      
    
  }
  if (key=='r') {
    setup();
    turn = 0;
    mc.set_turn();
  }
  if (key=='Q') exit();  // quit application
}

void displayDisks() {
  for (int i=0; i<disks1.size(); i++)
  {
    Disk theDisk = disks1.get(i);
    theDisk.show();
  }
  for (int i=0; i<disks2.size(); i++)
  {
    Disk theDisk = disks2.get(i);
    theDisk.show();
  }
}

