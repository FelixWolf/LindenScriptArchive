// Kart with Scripted Camera
//
// by Ben
// Some help from Casval and Dave


//
// This is a simple, fun vehicle meant for offroading. 
// 
// It is meant as an example to use in making your own vehicle.
//
//
rotation rot;
key owner;

// Defining the Parameters of the normal driving camera.
// This will let us follow behind with a loose camera.
list drive_cam =
[
        CAMERA_ACTIVE, TRUE,
        CAMERA_BEHINDNESS_ANGLE, 0.0,
        CAMERA_BEHINDNESS_LAG, 0.5,
        CAMERA_DISTANCE, 3.0,
        CAMERA_PITCH, 10.0,

        // CAMERA_FOCUS,
        CAMERA_FOCUS_LAG, 0.05,
        CAMERA_FOCUS_LOCKED, FALSE,
        CAMERA_FOCUS_THRESHOLD, 0.0,

        // CAMERA_POSITION,
        CAMERA_POSITION_LAG, 0.3,
        CAMERA_POSITION_LOCKED, FALSE,
        CAMERA_POSITION_THRESHOLD, 0.0, 
        
        CAMERA_FOCUS_OFFSET, <0,0,1>
 
       
];

list jump_cam =
[
        CAMERA_ACTIVE, TRUE,
        CAMERA_BEHINDNESS_ANGLE, 0.0,
        CAMERA_BEHINDNESS_LAG, 0.5,
        CAMERA_DISTANCE, 3.0,
        CAMERA_PITCH, 10.0,

        // CAMERA_FOCUS,
        CAMERA_FOCUS_LAG, 0.05,
        CAMERA_FOCUS_LOCKED, FALSE,
        CAMERA_FOCUS_THRESHOLD, 0.0,

        // CAMERA_POSITION,
        CAMERA_POSITION_LAG, 0.5,
        CAMERA_POSITION_LOCKED, FALSE,
        CAMERA_POSITION_THRESHOLD, 0.0, 
        
        CAMERA_FOCUS_OFFSET, <0,0,1>

       
];


reset()
{
    vector pos = llGetPos();
    pos.z = pos.z + 2.0;
    llMoveToTarget(pos, 0.3);
    llRotLookAt(rot, 0.1, 1.0);
    llSleep(1.0);
    llStopLookAt();
    llStopMoveToTarget();
}
     

default
{    


    state_entry()
    {
        llSetSoundQueueing(FALSE);
        llPassCollisions(TRUE);

        llSetSitText("Ride");
        
        llSitTarget(<-0.2, 0.0, 0.5>, <0.00000, -0.25882, 0.00000, 0.96593>);
        llSetCameraEyeOffset(<-6.0, 0.0, 2.00>);
        llSetCameraAtOffset(<0.0, 0.0, 1.0>);
        
        llSetVehicleType(VEHICLE_TYPE_CAR);
        
        llSetVehicleFlags(VEHICLE_FLAG_NO_DEFLECTION_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY | VEHICLE_FLAG_LIMIT_MOTOR_UP);
        
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.01);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.15);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 1000.0);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.1);
        
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.1);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.1);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.1);
        
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1000, 1000, 1000.0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <100.0, 100.0, 100>);
        
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.0);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1000);
        
        llSetVehicleFloatParam(VEHICLE_BUOYANCY, 0);
        llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 0.0);
        llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 3.0);
        
        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 0);
        llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 0.01);
        llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 1.0);
        
        llCollisionSound("", 0.0);
    }
    
    on_rez(integer param)
    {
        if(owner == llGetOwner())
        {
            owner = llGetOwner();
            llGiveInventory(owner, "GO KART Instructions");
        }
    }
    
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            
            if (agent)
            {
                if (agent != llGetOwner())
                {
                    llSay(0, "You aren't the owner");
                    llUnSit(agent);
                    llPushObject(agent, <0,0,100>, ZERO_VECTOR, FALSE);
                }
                else
                {
                    llSetStatus(STATUS_PHYSICS, TRUE);

                    llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA);
        
                    llMessageLinked(LINK_SET, 0, "on", "");
                    llSetTimerEvent(1.0);
                }
        }
            else
            {
                llSetStatus(STATUS_PHYSICS, FALSE);
                llReleaseControls();
                //llStopAnimation("motorcycle_sit");

                llMessageLinked(LINK_SET, 0, "off", "");
                llSetTimerEvent(0.0);
                llStopSound();
            }
        }
        
    }
    
    run_time_permissions(integer perm)
    {
        if (perm)
        {
            //llStartAnimation("motorcycle_sit");
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_UP | CONTROL_DOWN, TRUE, FALSE);
            llSetCameraParams(drive_cam);
        }
    }
    
    control(key id, integer level, integer edge)
    {
        vector angular_motor;
        if((edge & CONTROL_FWD) && !(level & CONTROL_FWD))
        {
            llMessageLinked(LINK_SET, 0, "stop", "");
        }
        if((edge & CONTROL_FWD) && (level & CONTROL_FWD))
        {
            llMessageLinked(LINK_SET, 0, "burst", "");
        }
        if(level & CONTROL_FWD)
        {   
            vector pos = llGetPos();
            if(( pos.z - llGround(ZERO_VECTOR) ) < 2.0)
            {
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <50,0,0>);
            }
        }
        if(level & CONTROL_BACK)
        {
            //llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, <0,0,1,0>);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <-40,0,0>);
        }
        if(!(level & CONTROL_BACK))
        {
            llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, <0,0,0,1>);
        }
        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            
            angular_motor.z = -PI * 0.5;
            
        }
        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
           
            angular_motor.z = PI * 0.5;
            
        }
        if(level & (CONTROL_DOWN))
        {
            reset();
        }
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
    }
    
    timer()
    {
        vector pos = llGetPos();
        if(( pos.z - llGround(ZERO_VECTOR) ) < 0.8)
        {
            rot = llGetRot();
            llSetCameraParams(drive_cam);
        }
        else
        {
            llSetCameraParams(jump_cam);
        }
            
    }
    
    touch_start(integer detected)
    {
        vector pos = llGetPos();
        llSay(0, (string)(pos.z - llGround(ZERO_VECTOR)));
    }
        
    
}
