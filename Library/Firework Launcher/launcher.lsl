//
//  Rocket Launcher
//  

integer LAUNCH_DELAY = 5;
integer ready = TRUE;

default
{
    on_rez(integer param)
    {
        //llTriggerSound("startup", 1.0);
        llPreloadSound("startup");
        llPreloadSound("launch");
        llPreloadSound("explosion");
        llGiveInventory(llGetOwner(), "Rocket Launcher");
    }

    touch_start(integer total_number)
    {
        if (ready)
        {
            llTriggerSound("switch", 1.0); 
            vector pos = llGetPos();
            pos.z += 0.8;
            pos.x -= 0.2;
            llRezObject("Rocket", pos, <0,0,0>, <0,0,0.5,1>, LAUNCH_DELAY);
            llTriggerSound("startup", 1.0);
            ready = FALSE;
            llSetTimerEvent((float)LAUNCH_DELAY);
        }
    }
    attach(key avatar)
    {
        if (avatar != NULL_KEY)
        {
            //  If attached to body, remove and give message 
            llRequestPermissions(avatar, PERMISSION_ATTACH);
        }
    }
    run_time_permissions(integer perm)
    {
        //
        //  As soon as we are able to detach (if accidentally attached), do so. 
        // 
        if (perm & PERMISSION_ATTACH)
        {
            llWhisper(0, "Drop me on the ground, don't attach me to your body.");
            llDetachFromAvatar();
        }
    } 
    timer()
    {
        llSetTimerEvent(0.0);
        ready = TRUE;
    }
}
