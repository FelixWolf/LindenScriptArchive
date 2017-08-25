// SLRR Sensor script that detects trains and shouts to switches to 
// set them automaticaly. Sensor are used rather then VolumeDetect
// to insure phantom trains are detected as well.
// Version: 1.0.0
// Creator: LDPW-Sylvan Mole 2010-06-29
// License: Open Source / Full mod
//
// Version update information at the end of the script


// Variabels to change
integer COMM_CHANNEL    = 101;          // Communication Channel set this to match the Switch Stand channel
string  SWITCH_SIDE     = "Main";       // Uncomment if this is a Main side sensor
//string  SWITCH_SIDE     = "Branch";     // Uncomment if this is a Branch side sensor

// Special case trains or trolleys you may want to switch automatically to specific route different from what is set above.
string  TRAIN_NAME      = "train";      // Name of the special train / trolley to detect.
string  SWITCH_SIDE_S   = "Main";       // Uncomment if this special train should go to Main side
//string  SWITCH_SIDE_S   = "Branch";     // Uncomment if this special train should go to Brance side

        // WARNING: Only use this timer function on 1 side of the switch
        // if you use it on the Main side then you can NOT use it on the
        // Branch side of the same switch as well and vv.
integer TIMER_ON        = TRUE;         // Switch on (TRUE) / off (FALSE) timer (Default = TRUE).
integer TIME            = 60;           // Time in seconds (Default = 60).


// Global Variables (Do not change)       
float   gfRange         = 4.0;          // Sensor range     
float   gfArc           = PI_BY_TWO;    // Sensor Arc
float   gfRate          = 0.5;          // Sensor Rate 
string  gsDescription;                  // Set object description to match Variables

integer listen_handle;                  // Listen handler to remove unwanted listen command

integer DEBUG           = TRUE;         // Debug message TRUE or FALSE
    

default
{
    changed( integer change )
    {
        if( change & (CHANGED_OWNER | CHANGED_INVENTORY) ) // Either of the changes will return true
        {
            if ( DEBUG ) llOwnerSay ( "Updating ..." );
            llResetScript(); // Reset the script if it was changed.
        }
    }

    state_entry()
    {
        // Set the description of the object to the selected variables above  
        gsDescription = "Talking on channel " + (string)COMM_CHANNEL + " / " + SWITCH_SIDE;
        if ( TIMER_ON == 1 ) gsDescription = gsDescription + " / Timer: ON ";
        else gsDescription = gsDescription + " / Timer: OFF ";
        
        if ( TRAIN_NAME != "" ) gsDescription = gsDescription +  " / Looking for: '" + TRAIN_NAME + "'";
        else gsDescription = gsDescription;
        
        if ( DEBUG ) llOwnerSay ( gsDescription ); 
        
        llSetObjectDesc ( gsDescription );
        
        // Start the Sensor Repeat function to detect Active scripted objects
        llSensorRepeat ( "", NULL_KEY, ACTIVE, gfRange, gfArc, gfRate );
        // llSensorRepeat ( "", NULL_KEY, ACTIVE, gfRange, gfArc, gfRate );
        
        // Start the Listen function if the timed auto-reset is on
        if ( TIMER_ON == 1 )
        {
            if ( SWITCH_SIDE == "Main" ) listen_handle = llListen(COMM_CHANNEL, "", NULL_KEY, "Branch");
            if ( SWITCH_SIDE == "Branch" ) listen_handle = llListen(COMM_CHANNEL, "", NULL_KEY, "Main");
            if ( DEBUG ) 
            {
            llOwnerSay ( "Timer ON. Resetting to '" + SWITCH_SIDE + "' after " + (string)TIME + " sec." );
            }
        }
        else
        {
            llListenRemove(listen_handle);
            if ( DEBUG ) llOwnerSay ( "Timer OFF" );
        }

    }
    
    listen(integer iChannel, string sName, key kID, string sMessage)
    {
        if ( DEBUG ) llOwnerSay ( "Switch position changed, starting timer..." );
        llSetTimerEvent ( TIME ); // Start timer
    }
    
    timer()
    {
        if ( DEBUG ) llOwnerSay ( "Timed auto-reset to " + SWITCH_SIDE );
        llShout(COMM_CHANNEL, SWITCH_SIDE);
    }
    
    sensor( integer num_detected )
    {
        string this_Obj = "";
        integer detect_Obj;
        for ( detect_Obj=0; detect_Obj<num_detected; detect_Obj++ )
        {
            string this_Obj = llDetectedName( detect_Obj );
            
            // Check if it's the Guide or Altenate Guide that where active scripted
            // if so "ignore"
            if ( this_Obj == "Guide" || this_Obj == "Alternate Guide" )
            {
                if ( DEBUG ) llOwnerSay ( this_Obj + " = detected " );
                this_Obj = "";
            }
            else if ( this_Obj == TRAIN_NAME )
            {
                // Seeing a special train object switch accordingly
                if ( DEBUG ) llOwnerSay ( " A Special obj. nammed: '" + TRAIN_NAME + "' was detected Switching it to: " + (string)COMM_CHANNEL + " to " + SWITCH_SIDE_S );
                llShout( COMM_CHANNEL, SWITCH_SIDE );
            }
            else if ( this_Obj != TRAIN_NAME )
            {
                // Give command to swtich to change if needed if a train is detected
                if ( DEBUG ) llOwnerSay ( " A train named: '" + this_Obj + "' was detected Switching " + (string)COMM_CHANNEL + " to " + SWITCH_SIDE );
                llShout( COMM_CHANNEL, SWITCH_SIDE );
            }
        }
    }
}


// Update:  2.0.0
//          2010-12-25 - Stryker Jenkins
//          Included variable SWITCH_SIDE and Set the channel in the 
//          description of the prim.
// Update:  2.1.0
//          2010-12-26 - Stryker Jenkins
//          Included a function to exclude detecting changes to "Guide" 
//          or "Alternate Guide" preventing false positives.
//          Included a Debug owner chat variable.
// Update:  2.2.0
//          2010-12-28 - Stryker Jenkins
//          Added timer and variables to auto-reset track to either
//          Main or Branch after xx seconds after switching over.
// Update:  2.3.0
//          2011-11-15 - Stryker Jenkins
//          Added a detection for special trains or trolleys that 
//          Need to swtich to a different route then the normal trains
