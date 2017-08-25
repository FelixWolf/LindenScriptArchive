default
{
    attach(key id)
    {
        if(id)
        {
            llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
        }
        else
        {
            llStopAnimation("hold_r_handgun");
        }
    }
    
    run_time_permissions(integer perms)
    {
        if(perms)
        {
            llStartAnimation("hold_r_handgun");   
            
        }
    }
}
