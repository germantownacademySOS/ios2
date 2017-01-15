/*
The sketch demonstrates iBecaon from an RFduino
*/

/*
 Copyright (c) 2014 OpenSourceRF.com.  All right reserved.

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include <RFduinoBLE.h>

// pin 3 on the RGB shield is the green led
int led = 3;


//char *uuid = "3bdb098f-b8b0-4d1b-baa2-0d93eb7169c4";
//char *uuid = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";

void setup() {
  // led used to indicate that iBeacon has started
  pinMode(led, OUTPUT);

//  Serial.begin(9600);
//  while (!Serial) {
//    ; // wait for serial port to connect. Needed for native USB port only
//  }
//
//  // send an intro:
//  Serial.println("Getting ready to beacon!");
//  Serial.println();

  // do iBeacon advertising
  RFduinoBLE.iBeacon = true;
  
  // override the default iBeacon settings
  //uint8_t uuid[16] = {0xE2, 0xC5, 0x6D, 0xB5, 0xDF, 0xFB, 0x48, 0xD2, 0xB0, 0x60, 0xD0, 0xF5, 0xA7, 0x10, 0x96, 0xE0};
  //memcpy(RFduinoBLE.iBeaconUUID, uuid, sizeof(RFduinoBLE.iBeaconUUID));

  // new way of writing the UUID - this lets us use a String to represent the UUID in code
  // disadvantage is we have to convert it to an array of ints before using, which means we have
  // to account for the dashes and converting from hex 
  uint8_t uuidAsInts[16];  
  convertUUIDStringToArrayOfInts("E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", uuidAsInts);
  memcpy(RFduinoBLE.iBeaconUUID, uuidAsInts, sizeof(RFduinoBLE.iBeaconUUID));  
  
  RFduinoBLE.iBeaconMajor = 1234;
  RFduinoBLE.iBeaconMinor = 5678;
  RFduinoBLE.iBeaconMeasuredPower = 0xC6;
  
  // start the BLE stack
  RFduinoBLE.begin();
}

void loop() {
  // switch to lower power mode
  RFduino_ULPDelay(INFINITE);
}

void RFduinoBLE_onAdvertisement(bool start)
{
  // turn the green led on if we start advertisement, and turn it
  // off if we stop advertisement
  
  if (start)
    digitalWrite(led, HIGH);
  else
    digitalWrite(led, LOW);
}

/**
 * This will walk through the passed in uuid string, and write out the 
 * HEX encoded pairs to the passed in array. This assumes that the string 
 * and the passed in array are the right sizes. For example if you pass in 
 * a UUID that has 32 characters (not including the dashes!), the array should
 * have 16 elements in it because we will be taking two letters at a time and 
 * converting the hex to an int.
 */
void convertUUIDStringToArrayOfInts(char *uuid, uint8_t *uuidAsInts) {

  // This algo will work for any size of uuid regardless where the hyphens are placed
  // However, you have to make sure that the destination have enough space.
  
  int strCounter=0;      // need two counters: one for uuid string and
  int hexCounter=0;      // another one for destination adv_data
  
  while (strCounter<strlen(uuid))
  {
       if (uuid[strCounter] == '-') 
       {
           strCounter++;     //go to the next element
           continue;
       }
  
       // convert the next two hex characters to a string
       char str[3] = "\0";
       str[0] = uuid[strCounter++];
       str[1] = uuid[strCounter++];
  
       // convert hex string to int 
       uuidAsInts[hexCounter++]= (uint8_t)strtol(str, NULL, 16);
  }

}
