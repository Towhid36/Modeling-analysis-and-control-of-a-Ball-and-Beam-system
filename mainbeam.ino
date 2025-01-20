#include <Servo.h>
#include <PID_v1.h>

const int trigPin = 2;    // Trig pin of the ultrasonic sensor (Yellow)
const int echoPin = 3;   // Echo pin of the ultrasonic sensor (Orange)
const int servoPin = 11;  // Servo Pin

float Kp = 2.05;                                                   // Initial Proportional Gain 2.05
float Ki = 0.001;                                                  // Initial Integral Gain 0.001
float Kd = 0.2;                                                    // Initial Derivative Gain 2
double Setpoint, Input, Output, ServoOutput;

PID myPID(&Input, &Output, &Setpoint, Kp, Ki, Kd, DIRECT);          // Initialize PID object, which is in the class PID.
Servo myServo;                                                      // Initialize Servo.

void setup() {
  Serial.begin(9600);                                               // Begin Serial communication
  myServo.attach(servoPin);                                         // Attach Servo
  resetServo();                                                     // Reset servo to initial angle

  Input = readPosition();                                           // Calls function readPosition() and sets the ball's position as the input to the PID algorithm

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  myPID.SetMode(AUTOMATIC);                                         // Set PID object myPID to AUTOMATIC

  myPID.SetOutputLimits(-60, 80);                                    // Set output limits to match servo range
}

void loop() {
  delay(100);
  Setpoint = 15;                                                     // Setpoint for PID
  Input = readPosition();                                            // Get the current position from the ultrasonic sensor

  myPID.Compute();                                                   // Compute the PID output in range of -60 to 80 degrees

  ServoOutput = 122 - Output;                                        // Adjust servo angle based on PID output (122 is the baseline for horizontal)
  myServo.write(ServoOutput);                                        // Writes value of Output to servo

  unsigned long currentTime = millis();                              // Get the current time in milliseconds
  Serial.print("Time: ");
  Serial.print(currentTime / 1000.0);                                // Print time in seconds
  Serial.print(" s, Angle: ");
  Serial.println(ServoOutput);                                       // Print the current servo angle
}

void resetServo() {
  myServo.write(122);  // Set servo to 102 degrees for horizontal positioning
  delay(500);          // Delay to allow the servo to reach the desired position
}

float readPosition() {
  delay(100);                                                   // Don't set too low or echos will run into each other.
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH);
  float distance = duration * 0.034 / 2;                          // Calculate distance in cm

  if (distance > 30 || distance <= 0) {
    distance = 40;                                                 // Set maximum distance as 30 cm for the ball
  }
  
  // Send the distance data over serial in the expected format
  unsigned long currentTime = millis();                           // Get current time in milliseconds
  Serial.print("Time: ");
  Serial.print(currentTime / 1000.0);                             // Print time in seconds
  Serial.print(" s, Distance: ");
  Serial.println(distance);                                        // Print distance (in cm)
  Serial.flush();                                                  // Ensure data is transmitted

  return distance;                                                 // Return the calculated distance
}
