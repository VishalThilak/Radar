/* Sonar Radar calculating distance and angle.
 *  Sending those values to processing to draw
 *  a radar graph
 * By Vishal Thilak
 */

#include <Servo.h>

// servo
Servo myServo;
int servoMax = 180;
int servoMin=0;
int angle = 0;

//ultrasonic sensor
// Specify pins
int trig_pin = 2;        
int echo_pin = 3;

//rgb pins
int red_pin = 6;
int green_pin = 5;

float distance;

void setup() {
  pinMode(trig_pin, OUTPUT); // Sets the trigPin as an Output
  pinMode(echo_pin, INPUT); // Sets the echoPin as an Input
  myServo.write(0);
  myServo.attach(9);

  //rgb
  pinMode(red_pin, OUTPUT);
  pinMode(green_pin, OUTPUT);
  
  // Initialize servo port
  Serial.begin(9600);

}

void loop() {
  // Causes servo motor to rotate
  for (angle = 0; angle <= servoMax; angle++){
    distance = distanceCalculated();
    lightMode();
    myServo.write(angle);
    delay(15);
    Serial.print(distance); // Sends the distance
    Serial.print(",");
    Serial.print(angle); // Sends the angle
    Serial.println();
  }

  for (angle = servoMax; angle >= servoMin; angle--){
    distance = distanceCalculated();
    lightMode();
    myServo.write(angle);
    delay(15);
    Serial.print(distance); // Sends the distance
    Serial.print(",");
    Serial.print(angle); // Sends the angle
    Serial.println();
  }
}

// distance between the object and the sensor
int distanceCalculated(){ 
  //clearing the trig pin
  digitalWrite(trig_pin, LOW); 
  delayMicroseconds(2);
  
  // Sets the trigPin on the HIGH state for 10 ms
  digitalWrite(trig_pin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trig_pin, LOW);

  // Gets the tiem it takes fot the sound wave to travel
  float duration = pulseIn(echo_pin, HIGH);

  // distane = time * speed
  // where speed is the speed of the sound in cm/ms divided by 2
  float distance= duration * 0.017;
  return distance;
}

// determines whether to change the rgb color to red or green
// red for when an object is detected and green for when it
// is not
void lightMode(){
  if (distance > 0 && distance <= 100){
      analogWrite(red_pin, 255);
      analogWrite(green_pin, 0);
    }
  else{
      analogWrite(green_pin, 255);
      analogWrite(red_pin, 0);
    }
}
