integer hour;
integer min;

default
{

    link_message(integer sender, integer num, string message, key id)
    {
        
        if(num == 2)
        {
            min = (integer)message;
        }
        
        integer time =  min;
        
        
        float rot = (time / -60.0) * (2 * PI);
        
        
        
        llRotateTexture(rot, ALL_SIDES);
    }
}
