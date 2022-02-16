#include <Servo.h>

Servo myservo;  // create servo object to control a servo

int pos = 0;  // vairable for loops   
int incoming = 0;   // stores incoming serial data
int prev = 90; // store the previous servo position
int val = 90; //  store the current servo position
int con = true; // set the type of running mode
int dval = 90; // set the rate which goes down 
int uval = 90;// set the rate which goes up 
long prevt = 1;//the time when rotation starts 
int del = 1;//amount of delay in the set time run 
int sec = del; // takes into account the delay in ramping up for faster speeds


void spin(int prev, int val){ // spin the servo        
    if (val>prev){// if going up 
        for (pos = prev; pos <= val; pos += 1) { // goes from prev to new speed when new is higher in steps of 1
          myservo.write(pos);              // tell servo to go to position in variable 'pos'
          Serial.println(pos);             // prints the base information of the servo reaching speed 
          delay(15);                      // give time between steps to allow for the servo to start spinning
        }
    }
    else if (val<prev){ // if going down 
          for (pos = prev; pos >= val; pos -= 1) { // goes from prev to new speed when new is lower in steps of 1 
            myservo.write(pos);              // tell servo to go to position in variable 'pos'
            Serial.println(pos);              // prints the base information of the servo reaching speed 
            delay(15);                        // give time between steps to allow for the servo to start spinning
          }
     }
}

void modeset(int mode){ // set the running mode of the program, prints to info on current mode and how to change whulst setting variables for particular mode 
  if (mode == 104){ // h for high speed
      Serial.println("High speed mode - 0.75 mm/s");
      Serial.println("Press m for Medium speed mode or l for Low speed mode or p for Paper speed");
      dval = 180;
      uval = 5;
      sec = del-2;
      if (sec<0){sec = 0;}
    }
  else if (mode == 109){//m for medium speed 
      Serial.println("Medium speed mode - 0.5 mm/s");
      Serial.println("Press h for High speed mode or l for Low speed mode or p for Paper speed");
      dval = 138;
      uval = 47;
      sec = del-1;
      if (sec<0){sec = 0;}
    }
  else if (mode == 108){//l for low speed 
      Serial.println("Low speed mode - 0.1 mm/s");
      Serial.println("Press h for High speed mode or m for Medium speed mode or p for Paper speed");
      dval = 104;
      uval = 82;
      sec= del;
    }
  else if (mode == 99){// c for continous
      Serial.println("Continous Rotation mode");
      Serial.println("Press (in serial) d for down, u for up and s to stop");
      Serial.println("Press t for Set Rotation mode");
      con = true;
      modeset(104); // when mode changes set it to high speed
    }
  else if (mode == 116){//t for set 
    Serial.println("Set Rotation mode");
    Serial.println("Press (in serial) 1 for down 1 second, 2 for up 1 second and s to stop");
    Serial.println("Press c for Continous Rotation mode");
    con = false;
    modeset(104); // when mode chnages se it to high speed
    }
}

void setup() { // start up the base system 
  Serial.begin(9600); // the band for comunication 
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object
  //set startup mode manually to continous 
  modeset(99);
}

void loop() {
  incoming = Serial.read(); // get keyboard input
  modeset(incoming); // set the mode based on the keyboard input
  if (con){ // code for continous running
    if (incoming > 0){// only reset value is there is a change
      if(incoming == 100){ // d - goes down
                     val = dval;
                    }
      else if(incoming == 117){//u - goes up
                      val = uval;
                    }
      else if(incoming == 115){ // s - stops 
                      val = 90;
                    }
      else {
                      val = prev;
                    }          
      spin(prev,val);
      prev = val;
    }
  }
  
  else{// code to run for set amount of roations 
      if (incoming > 0){// only reset value is there is a change
       if(incoming == 49){ // 1- goes down for set delay
                   val = dval;
                  }
       else if(incoming == 50){//2 - goes up for 1 rotration 
                    val = uval;
                  }
       else if(incoming == 115){ // s - stops 
                    val = 90;
                  }
       else {
                    val = prev;
                  }  
      spin(prev,val);
      prevt = millis(); // get the start time in miliseconds since start of system
      while (millis()< (prevt+(sec*1000))){   // only run for set number of seconds       
      incoming = Serial.read(); // keep reading data to make sure it doesnt have to stop 
      if (incoming == 115){ // if s is recived automatically stop no matter the time
        break;
        }
      }
      spin(val,90);
      prev = 90;
      Serial.println("Ready for new input"); // prints when the full time is done and is safe for new inputs 
    }
  }
}
