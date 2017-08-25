//
//  Beachball 
// 
//  This script animates a physical ball by making it more buoyant, 
//  changing the sounds and images you see when it collides with things, 
//  and applying a little force when released. 
//
 
default
{
    state_entry()
    {
        llCollisionSound("bounce_1", 1.0);          //  Change sound on collision to custom sound
        llCollisionSprite("green");                 //  Switch to fun collision sprite (image) 
        llSetBuoyancy(0.75);                        //  Make more buoyant, like a real beach ball!
    }

    on_rez(integer param) 
    {
        //  
        //  As soon as someone makes (rezzes) this ball, 
        //  cause the sounds to preload so they are ready. 
        // 
        llPreloadSound("bounce_1");
        llPreloadSound("bounce_2");
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
        //  
        //  When someone lets go of the ball, apply a little force for fun 
        //
        vector impulse = llGetPos() - llDetectedPos(0);             // Vector between avatar and ball
        impulse.z += 7.0;                                           // always add some 'up'
        impulse = llVecNorm(impulse) * 7.0;
        llApplyImpulse(impulse, FALSE);
        llApplyRotationalImpulse(impulse * 0.25, FALSE);
        llTriggerSound("bounce_2", 0.5);
    }
}
