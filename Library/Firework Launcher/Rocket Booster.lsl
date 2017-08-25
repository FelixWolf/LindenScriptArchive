//
//  Modified Rocket Script To make 2 second bursts of rocket pack
//
//  Click to fire
// 

float gTotalTime = 0.0;
float gTimeStep = 0.2;

float FLIGHT_TIME = 1.0;
float THRUST = 15.0;

integer launched = FALSE;

launch()
{
    launched = TRUE;
    gTotalTime = 0.0;
    llSetStatus(STATUS_PHYSICS, TRUE);
    llSetForce(<0,0,THRUST>, TRUE);
    llSetTimerEvent(gTimeStep);
    llTriggerSound("launch", 1.0);
    llMakeExplosion(20, 1.0, 5, 3.0, 1.0, "smoke", ZERO_VECTOR);
}
default
{
    state_entry()
    {
        llPreloadSound("launch");
        llPreloadSound("explosion");
        llSetStatus(STATUS_PHYSICS, FALSE);         
    } 
    on_rez(integer param) 
    {
        if (param > 0)
        {
            llSetTimerEvent((float)param);      //  Wait passed number seconds then launch
        }
    }    
    touch_start(integer num)
    {
        llSay(0, "Launching, please wait!");
    }
    
    timer()
    {
        if (!launched)
        {
            launch();
            return;    
        }
        gTotalTime += gTimeStep;
        if (gTotalTime < FLIGHT_TIME)
        {
            llMakeExplosion(5, 1.0, 2, 3.0, PI, "smoke", ZERO_VECTOR);
        }
        else
        {
            llSetStatus(STATUS_PHYSICS, FALSE);
            llSetForce(<0,0,0>, TRUE);
            llTriggerSound("explosion", 10.0);
            llMakeExplosion(20, 1.0, 5, 3.0, 1.0, "green", ZERO_VECTOR);
            llMakeExplosion(20, 1.0, 5, 3.0, 1.0, "blue", ZERO_VECTOR);
            llDie();
        }        
    }
    collision_start(integer num)
    {
            llSetStatus(STATUS_PHYSICS, FALSE); 
            llSetForce(<0,0,0>, TRUE);
            llTriggerSound("explosion", 10.0);
            llMakeExplosion(20, 1.0, 5, 3.0, 1.0, "green", ZERO_VECTOR);
            llMakeExplosion(20, 1.0, 5, 3.0, 1.0, "blue", ZERO_VECTOR);
            llDie();
            
    }
}
