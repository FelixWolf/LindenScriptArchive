//Communicates to scripts in lightbulb

integer on;

default
{
    state_entry()
    {
        llPassTouches(TRUE);
    }

    touch_start(integer total_number)
    {
        if(on)
        {
            on = FALSE;
            llMessageLinked(LINK_SET, on, "","");
            
        }
        else
        {
            on = TRUE;
            llMessageLinked(LINK_SET, on, "","");
            
        }
    }
}
