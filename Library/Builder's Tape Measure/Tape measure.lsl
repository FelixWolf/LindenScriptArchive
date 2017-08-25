integer count = 0;

vector MEASURING_TAPE= <1,.5,1>;
vector AVATAR_HEIGHT = <1.45, .05, 2.1>;
vector DOOR_SIZE_HEIGHT = <1.45, .05, 2.8>;
vector CEILING_HEIGHT = <1.45, .05, 3.8>;
vector SECOND_FLOOR_HEIGHT = <1.45, .05, 7.6>;

float groundpos;

list scalelist = [MEASURING_TAPE,AVATAR_HEIGHT,DOOR_SIZE_HEIGHT, CEILING_HEIGHT, SECOND_FLOOR_HEIGHT];
list stringlist = ["Measuring Tape","Average Avatar height", "Door height and width", "First floor ceiling height", "Second floor ceiling height"];
list soundlist =[ "tape out", "tape in"];
change(integer which)
{ 
    // Update scale 
    vector newscale = llList2Vector(scalelist, which);
    llSetScale(newscale);

    // Update our position according to the scale so
    // that we are just touching the ground.
    vector newpos = llGetPos();
    //float groundpos = llGround(<0.0,0.0,0.0>);
    newpos.z = groundpos + .5 * newscale.z;
    llSetPos(newpos);

    // Update the texture and tell the user
    string size_name = llList2String(stringlist, which);
    llPlaySound("tape out", 0.5);
    llWhisper(0, size_name );
    llSetTexture(size_name , 1);
    llSetTexture(size_name , 3);
}

init()
{
   count = 0;
   vector pos = llGetPos();
   vector scale = llGetScale();
   groundpos = pos.z - scale.z/2.0;
   change( count );
}

default
{
    state_entry()
    {
        init();
    }

    on_rez( integer start_param )
    {
        init();
    }

    touch_start(integer total_number)
    {
        count++;
        if( count >= llGetListLength( scalelist ) )
        {
            count = 0;
        }
        change(count);
    }
}
