//
//  Popgun Bullet
//
//  Becomes non-physical on impact, makes a little particle system, then fades away. 
// 

integer fade = FALSE;
float alpha = 1.0;

splat()
{      
        llSetStatus(STATUS_PHANTOM, TRUE);
        vector pos = llGetPos();  
        llMoveToTarget(pos, 0.3);          //  Move to where we hit smoothly
        llSetColor(<0,0,1>, ALL_SIDES);
        llTriggerSound("splat4", 1.0);
        llMakeFountain(50, 0.3, 2.0, 4.0, 0.5*PI, 
                        FALSE, "drop", <0,0,0>, 0.0);
        fade = TRUE;
        llSetTimerEvent(0.1);      
}
default
{
    state_entry()
    {
        llSetStatus( STATUS_DIE_AT_EDGE, TRUE);
    }
    
    on_rez(integer delay)
    {
        llSetBuoyancy(1.0);                 //  Make bullet float and not fall 
        llCollisionSound("", 1.0);          //  Disable collision sounds

        if (delay > 0) 
        {
            llSetTimerEvent((float)delay);  //  Time until shot deletes itself 
        }
    }

    collision_start(integer total_number)
    {
        splat();                            //  When we hit something, go spat!
    }
    land_collision_start(vector pos)
    {
        splat();                            //  When we hit the ground, go splat!
    }
    
    timer()
    {
        if (!fade)
        {
            llDie();       
        }   
        else
        {
            //  Slowly turn transparent, then go away.
            llSetAlpha(alpha, -1);
            alpha = alpha * 0.95;  
            if (alpha < 0.1) 
            {
                llDie();
            }     
        }
    }
}
