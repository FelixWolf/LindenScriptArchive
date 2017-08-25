//
//  Popgun
//
//  This script is a basic gun- it waits for a mouseclick in mouselook and
//  then fires a bullet in the direction the user is facing. 
//  It also animates the avatar holding it, to create a convining hold and 
//  firing look for the gun. 
// 
//  This script can be used as a good basis for other weapons. 
//  

float SPEED         = 20.0;         //  Speed of arrow in meters/sec
integer LIFETIME    = 7;            //  How many seconds will bullets live 
                                    //  before deleting themselves
float DELAY         = 0.2;          //  Delay between shots to impose 

vector vel;                         //  Used to store velocity of arrow to be shot 
vector pos;                         //  Used to store position of arrow to be shot
rotation rot;                       //  Used to store rotation of arrow to be shot

integer have_permissions = FALSE;   //  Indicates whether wearer has yet given permission 
                                    //  to take over their controls and animation.
                                    
integer armed = TRUE;               //  Used to impose a short delay between firings

string instruction_held_1 = "Use Mouselook (press 'M') to shoot me.";
string instruction_held_2 = "Choose 'Detach' from my menu to take me off.";
                                    //  Echoed to wearer when they are holding the bow
string instruction_not_held = "Right-click (apple-click) me, and choose More > Wear' from the menu to use me.";
                                    //  Echoed to toucher if not worn
                                    

fire()
{
    // 
    //  This subroutine creates and fires an arrow
    //
    if (armed)
    {
        //  
        //  Actually fires the arrow
        //  
        armed = FALSE;
        rot = llGetRot();               //  Get current avatar mouselook direction
        vel = llRot2Fwd(rot);           //  Convert rotation to a direction vector
        pos = llGetPos();               //  Get position of avatar to create arrow
        pos = pos + vel;                //  Create arrow slightly in direction of travel
        pos.z += 0.75;                  //  Correct creation point upward to eye point 
                                        //  from hips,  so that in mouselook we see arrow 
                                        //  travelling away from the camera. 
        vel = vel * SPEED;              //  Multiply normalized vector by speed 
        
        //llStartAnimation("shoot_R_handgun");    //  Trigger the bow release animation
        llTriggerSound("shoot", 1.0); //  Make the sound of the arrow being shot
        llRezObject("bullet", pos, vel, rot, LIFETIME); 
                                            //  Create the actual arrow from object 
                                            //  inventory, and set its position, velocity, 
                                            //  and rotation.  Pass a parameter to it to 
                                            //  tell it how long to live.
                                            
        llSetTimerEvent(DELAY);         //  Wait until can fire again
    }
}

default
{
    state_entry()
    //  
    //  This routine is called whenever the script is edited and restarted.  So if you 
    //  are editing the bow while wearing it, this code will re-request permissions 
    //  to animate and capture controls. 
    // 
    {
        if (!have_permissions) 
        {
            llRequestPermissions(llGetOwner(),  
                PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);   
        }
    }
    on_rez(integer param)
    {
        //
        //  Called when the gun is created from inventory.
        // 
        llPreloadSound("shoot");        //  Preload shooting sound so you hear it
    }

     run_time_permissions(integer permissions)
    {
        //
        //  This routine is called when the user accepts the permissions request 
        //  (sometimes this is automatic)
        //  so on receiving permissions, start animation and take controls. 
        // 
        if (permissions == PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS)
        {
            if (!have_permissions)
            {
                llWhisper(0, instruction_held_1);
                llWhisper(0, instruction_held_2);
            }
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            llStartAnimation("hold_R_handgun");
            have_permissions = TRUE;
        }
    }

    attach(key attachedAgent)
    {
        //
        //  If attached/detached from agent, change behavior 
        //  
        if (attachedAgent != NULL_KEY)
        {
            //  Bow has been attached or rezzed from inventory, so 
            //  ask for needed permissions. 
            llRequestPermissions(llGetOwner(),  
                PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);   
        }
        else
        {
            //  Bow has been detached from avatar, so stop animation and release controls
            if (have_permissions)
            {
                llStopAnimation("hold_R_handgun");
                llStopAnimation("aim_R_handgun");
                llReleaseControls();
                llSetRot(<0,0,0,1>);
                have_permissions = FALSE;
            }
        }
    }

    control(key name, integer levels, integer edges) 
    {
        //  This function is called when the mouse button or other controls 
        //  are pressed, and the controls are being captured. 
        //  
        //  Note the logical AND (single &) used - the levels and edges 
        //  variables passed in are bitmasks, and must be checked with 
        //  logical compare. 
        //  
        //  Checking for both edge and level means that the button has just 
        //  been pushed down, which is when we want to fire the arrow!
        // 
        if (  ((edges & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            &&((levels & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) )
        {
            //  If left mousebutton is pressed, fire arrow 
            fire();
        }
    }
    
    touch_start(integer num)
    {
        //  If touched, remind user how to enter mouselook and shoot
        if (have_permissions) 
        {
            llWhisper(0, instruction_held_1);
            llWhisper(0, instruction_held_2);
        }
        else 
        {   
            llWhisper(0, instruction_not_held);
        }
    }
    
    timer()
    {
        //  After timer expires, allow user to shoot bow again
        llSetTimerEvent(0.0);
        armed = TRUE;
    }
  
}
 
