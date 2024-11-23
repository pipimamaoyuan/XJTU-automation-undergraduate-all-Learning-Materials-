# PLC_XJTU_2022
This repository contains the PLC (Programmable Logic Controller) control system special experiments from Xi'an Jiaotong University for the year 2022. It includes four experiments covering various topics such as mail sorting simulation, traffic light simulation, four-floor elevator simulation, and an automatic car control system. They all designed to use PLC (Programmable Logic Controller) to implement different control systems. Through these experiments, students can gain a deep understanding of the basic principles and techniques of PLC programming and applications.

## Experiment 1: Mail Sorting Simulation Control

### Experiment Objective

To use a PLC to construct a mail sorting control system that simulates the automatic sorting process of mail.


### Experiment Details

#### Control Requirements

- Use a DIP switch to input the mail code (XCXDXEXF). If the value is not 1, 2, 3, 4, or 5 (corresponding to binary 0001, 0010, 0011, 0100, 0101), then the L1 light should flash to indicate an error, and the stop button will be ineffective.
- You must set XCXDXEXF to 1, 2, 3, 4, or 5, then reset and press the start button. At this point, L2 lights up indicating that the mail can be processed, and M5 lights up while SB1 generates a pulse signal.

#### Mail Sorting Logic

- **Postal Code 1 (0001)**: After detecting the mail, after 5 pulses, M1 lights up for 2 seconds, indicating the mail has been sorted into the Beijing mailbox, while M5 and L2 turn off for 2 seconds.
- **Postal Code 2 (0010)**: After detecting the mail, after 10 pulses, M2 lights up for 2 seconds, indicating the mail has been sorted into the Shanghai mailbox, while M5 and L2 turn off for 2 seconds.
- **Postal Code 3 (0011)**: After detecting the mail, after 15 pulses, M3 lights up for 2 seconds, indicating the mail has been sorted into the Tianjin mailbox, while M5 and L2 turn off for 2 seconds.
- **Postal Code 4 (0100)**: After detecting the mail, after 20 pulses, M4 lights up for 2 seconds, indicating the mail has been sorted into the Wuhan mailbox, while M5 and L2 turn off for 2 seconds.
- **Postal Code 5 (0101)**: After detecting the mail, after 25 pulses, indicating the mail has been sorted into the Guangzhou mailbox, while M5 and L2 turn off for 2 seconds.

#### Error Handling

- If the mail is detected but the corresponding M light has not yet illuminated and the value of XCXDXEXF changes, then L1 will flash to indicate an error.
- After the mail has been successfully placed into the mailbox, press S1 to indicate the mail processing work is done.

## Experiment 2: Traffic Light Simulation Control

### Experiment Objective

To use a PLC to build a traffic light control system that simulates the operation logic of real traffic lights.



### Experiment Details

#### Control Requirements

- After starting, the north-south red light remains on for 25 seconds, while the east-west green light also lights up.
- 1 second after the east-west green light is on, light A turns on.
- The east-west green light starts flashing after 20 seconds, continues for 3 seconds, then turns off, after which the yellow light turns on and light A turns off.
- The yellow light remains on for 2 seconds, then turns off, and the east-west red light turns on.
- At the same time, the north-south red light turns off, the green light turns on, and after 1 second, light B turns on.
- The north-south green light remains on for 25 seconds, starts flashing for 3 seconds, then turns off, and at the same time, light B turns off, the yellow light turns on for 2 seconds and then turns off.
- The north-south red light turns on, the east-west green light turns on, and the cycle repeats.

## Experiment 3: Four-Floor Elevator Simulation Control

### Experiment Objective

To use a PLC to build a four-floor elevator control system that simulates the elevator's operation and response to call signals.

### Experiment Details

#### Control Requirements

1. Initially, the elevator starts at the first floor.
2. When an external call signal is received, the elevator responds to the signal. Upon reaching the floor, the elevator stops, the doors open, and after a 3-second delay, they automatically close.
3. When an internal call signal is received, the elevator similarly responds to this signal. Upon reaching the floor, the doors open, and after a 3-second delay, they close.
4. During the elevator's ascent or descent, any call signals for the opposite direction are not responded to unless there are no other signals in the forward direction.
5. The elevator has a feature to respond to the farthest reverse call. For example, if the elevator is on the first floor and there are call signals from the second, third, and fourth floors for going down, the elevator will respond to the fourth floor's call first.
6. When the elevator is not leveled or in motion, the open and close door buttons do not function. Once leveled and stopped, these buttons can be used to control the doors.

## Experiment 4: Automatic Car Control System

### Experiment Objective

To use a PLC to construct an automatic car control system that simulates the automatic operation and stopping of a car along a predetermined path.




### Experiment Details

1. After starting, the car resets and moves to position 4, stops for 6 seconds, then automatically moves to position 1.
2. Upon reaching position 1, the car stops for 6 seconds, then automatically returns to position 4, repeating this process.
3. The car can be manually stopped at any position using a switch, and upon restarting, it continues the process described in step 1.
4. The direction of the car's movement (left or right) is indicated by lights, and the position display unit shows the car's current position in real-time.
5. If the car takes more than 15 seconds to travel between points 1 and 4, an alarm triggers, and the car stops.

More details about this experiments can be found in Ref.zip



## Disclaimer
This repository is intended for personal academic use and reference. It is recommended to understand and work through the materials independently before referring to the provided solutions.

Feel free to explore the content and reach out if you have any questions!

---
This article was originally published on GitHub by HuXinying0420 in the repository PLC_XJTU_2022 at the following address: https://github.com/HuXinying0420/PLC_XJTU_2022

Please note the following when reprinting this content:

1. Source: This article was originally published on GitHub by HuXinying0420.
2. Original URL: https://github.com/HuXinying0420/PLC_XJTU_2022
