// HoverText Clock Script
// By Ben Linden
//
// Drop on an object to make it display the PST time.
//
// If you are interested in scripting, check out
// the Script Help under the help menu.

// The double slash means these lines are comments
// and ignored by the computer.




// Global Variables
// a string is a collection of characters.
string smin; // Represents minutes
string sseconds; //Represens seconds

// All scripts have a default state, this will be
// the first code executed.
default
{
    // state_entry() is an event handler, it executes
    // whenever a state is entered.
    state_entry()
    {
        // llSetTimerEvent() is a function that sets 
        // up a timer event in seconds.
        llSetTimerEvent(2.0);  // call a timer event 
                               // every 2 seconds.
    }
    
    
    // timer() is an event handler, it executes on an
    // interval defined by llSetTimerEvent()
    timer()
    {
       // llFloor is a function that rounds down all numbers.
       // llGetWallClock is a function that returns the time 
       // of day in seconds, on a 24 hour clock.
       integer seconds =  llFloor(llGetWallclock());
       // Convert the total number of seconds into a integer (whole number)
       integer min = llFloor(seconds/60);
       // Figure out how many minutes that is
       seconds = seconds - (min*60);
       //Work out the remaining number of seconds
       integer hour = llFloor(min/60);
       // figure out how many hours it represents.
       min = min - (hour*60);
       // figure out the number of minutes remaining
       
       // if is a conditional statement, it will only execute if the conditions are met. 
       if(hour > 12) {hour = hour - 12;} // if the hours are greater than 12, convert to 12 hour time
       string shour = (string)hour; //convert the number into a string
       if(min < 10) {smin = "0"+(string)min;} // if less than 10 minutes, put a 0 in the minute string
       else { smin = (string)min;} 
       if(seconds < 10) { sseconds = "0"+(string)seconds;} // if less than 10 sec, put a 0 in the second string
       else {sseconds = (string)seconds;}
       
       
       string time = shour + ":" + smin + ":" + sseconds; // build the seperate strings into a complete string, with colons
       
       // llSetText is a function that displays a string over the object.
       llSetText(time, ZERO_VECTOR, 1.0); //Display the string in solid black.
    }

}
