//
//  Dice
//  
//  Flips when you click on it.  Click longer for higher flip. 
//  Drag physically during click for more amusing flight. 
// 


float HOP_SCALE = 1.5;
float TORQUE_SCALE = 0.05;

vector last_color; 
vector HELD_COLOR = <1, 0.75, 0.75>;

integer NUM_DICE = 1;           //  Number of additional dice to throw:
                                //  1 = craps 
                                //  4 = Yahtzee, etc!
integer HELD = FALSE; 

vector impulse;
vector torque;

integer CHANNEL = 1263;

default
{
    state_entry()
    {
        llCollisionSound("dice_drop", 0.5);      //  Override normal collision sounds
    }

    touch_start(integer total_number)
    {
        HELD = TRUE;
        last_color = llGetColor(0);
        llSetColor(HELD_COLOR, ALL_SIDES);
        llSay(CHANNEL, "die");
        llLoopSound("dice_shake", 1.5);
    }
    
    attach(key avatar)
    {
        // 
        //  If this gets called it means someone has attached this 
        //  object to their body rather than creating in-world. 
        //  Ask for permission to detach, then do so with a message
        //
        if (avatar != NULL_KEY)
        {
            llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
        }
    }
    
    run_time_permissions(integer perm)
    {
        // 
        //  This means we are now OK to detach from avatar, so send message and do so
        // 
        llWhisper(0, "Drop me on the ground, don't attach me to your body.");
        llDetachFromAvatar();
    }
    
    touch_end(integer total_number) 
    {
        HELD = FALSE;
        llLoopSound("dice_shake", 0.0);
        llTargetOmega(<1,1,1>, 0.0, 0.0);
        llTriggerSound("dice_drop", 1.0);
        llSetColor(last_color, ALL_SIDES); 
        impulse = < 0,
                    0,
                    HOP_SCALE>;
        llApplyImpulse(impulse, FALSE);
        torque = <  llFrand(TORQUE_SCALE), 
                    llFrand(TORQUE_SCALE), 
                    llFrand(TORQUE_SCALE)>;
        llApplyRotationalImpulse(torque, TRUE);
        vector pos = llGetPos();
        pos.z += 0.50;
        pos.x += 0.30;
        integer i;
        for (i=0; i<NUM_DICE; i++)
        {
            llRezObject("Slave Die",pos,<0,0,1>, <0,0,0,1>, 0); 
            pos.z += 0.50;
        }
    }
   
}
