integer i;
default
{
    state_entry()
    {
        llSensorRepeat("","",AGENT, 30, PI, 10);
    }

    sensor(integer total_number)
    {
        integer in = 0;
        vector here = llGetPos();
        for(i=0; i<total_number; i++)
        {
            vector there = llDetectedPos(i);
            if(there.z < here.z)
            {
                in++;
            }
        }
            
        
        llSay(456685, (string)in);
    }
    
    no_sensor() 
    { 
        
        llSay(456685, "0");
        
    }
}
