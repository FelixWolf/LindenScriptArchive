integer hour;
integer min;

default
{

    link_message(integer sender, integer num, string message, key id)
    {
        if(num == 1)
        {
            hour = (integer)message;
            
            if(hour > 12)
            {
                hour = hour - 12;
            }
        }
        if(num == 2)
        {
            min = (integer)message;
        }
        
        integer time = (hour * 60) + min;
        
        
        float rot = (time / -720.0) * (2 * PI);
        
        
        
        llRotateTexture(rot, ALL_SIDES);
    }
}
