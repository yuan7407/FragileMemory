import neurosky.*;
ThinkGearSocket neuroSocket;
int attention = 0;
int meditation = 0;
import websockets.*;
WebsocketServer server;

void setup() {
  size(500, 500);
  server = new WebsocketServer(this, 9091, "/");
  ThinkGearSocket neuroSocket = new ThinkGearSocket(this);
  
  try {
    neuroSocket.start();
  }
  catch(Exception e) {
    println("There is an error");
  }
}

void draw() {
  background(0);
  fill(255);
  ellipse(width/2, height/2, attention, attention);
}

void poorSignalEvent(int sig){
  println("Signal: " + str(sig)); 
}

public void attentionEvent(int attentionLevel){
  println("Attention: " + str(attentionLevel));
  attention = attentionLevel;
  server.sendMessage(str(attention));
}

void meditationEvent(int meditationLevel){
  println("Meditation: " + str(meditationLevel)); 
}

void blinkEvent(int blinkStrength){
  println("Blink: " + str(blinkStrength)); 
}

void stop(){
  neuroSocket.stop();
  super.stop();
}