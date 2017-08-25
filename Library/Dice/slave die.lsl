//
//  Slave Dice 
//  
//  Appy rotation on rez to flip nicely. 
//  
// 


float HOP_SCALE = 0.5;
float TORQUE_SCALE = 0.05;


vector HELD_COLOR = <1, 0.75, 0.75>;
vector NORMAL_COLOR = <1, 1, 1>;

integer HELD = FALSE; 

vector impulse;
vector torque;

integer CHANNEL = 1263;

default
{
    state_entry()
    {
        llListen(CHANNEL, "", "", "");
        llCollisionSound("dice_drop", 0.25);
    }

    on_rez(integer param)
    {
        torque = <  llFrand(TORQUE_SCALE), 
                    llFrand(TORQUE_SCALE), 
                    llFrand(TORQUE_SCALE)>;
        llApplyRotationalImpulse(torque, TRUE);
    }
    
    touch_start(integer total_number)
    {
       llDie();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        llDie();
    }
}
