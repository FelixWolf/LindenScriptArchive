//This script works with the linden media player to make a screen.


integer controller_chan = 8904312;

default
{
    state_entry()
    {
        llListen(controller_chan, "", "", "");
    }
    
    listen(integer chan, string name, key id, string message)
    {
        if(llGetOwnerKey(id) == llGetOwner())
        {
            llSetTexture((key)message, 3);
            
        }
    }
    

    
}
