// Jopsy's Particle System Template v4 - Jan 18 2004
// -- inspired/derived from Ama Omega's 3-6-2004
//
// DEFAULT settings are commented at the end of each line, eg:
// varibletype  SETTINGNAME = Sample-Setting; // default-setting
// 
// For more on particles, visit the Particle Labratory in Teal!
 
mySetParticles() {
    // Part-1 - APPEARANCE - Settings for how each particle LOOKS
    vector   START_SCALE = < 0.2, 0.2, 0.2 >; // < 1.0, 1.0, 0.0 >
    vector     END_SCALE = < 0.1, 0.1, 0.1 >; // < 1.0, 1.0, 0.0 >
    vector   START_COLOR = < 1.0, 1.0, 0.0 >; // < 1.0, 1.0, 1.0 >
    vector     END_COLOR = < 1, 0.2, 0.0 >; // < 1.0, 1.0, 1.0 >
    float    START_ALPHA = 0.7; // 1.00 
    float      END_ALPHA = 0.0; // 1.00
    integer INTERP_COLOR = TRUE; // FALSE
    integer INTERP_SCALE = TRUE; // FALSE
    integer     EMISSIVE = TRUE; // FALSE 
    string       TEXTURE = ""; // ""
    // START/END: refers to the lifespan of each particle.
    // SCALE: particle height/width, from 0.04 to 10.0. (no depth)
    // ALPHA: sets transparency, from invis = 0.0 to opaque = 1.0
    //       START_ALPHA is ignored if it is less than END_ALPHA
    // COLOR: vectors <Red,Green,Blue>, each 0.00 to 1.00
    // INTERP_COLOR: enables/disables END_COLOR and END_ALPHA
    // INTERP_SCALE: enables/disables END_SCALE 
    // EMISSIVE: enables/diables particle 'glow'
    // TEXTURE: name of a texture in the emitter-prim's inventory 
    //          or the asset id key of any texture
    
    // Part-2 - FLOW - These settings affect how Many, how Quickly, 
    //                  and for how Long particles are present
    float     AGE = 0.6; // 10.00
    float    RATE = 0.0; // 0.10
    integer COUNT = 1;    // 1
    float    LIFE = 0.0;  // 0.0
    // AGE: How many seconds each particle lives, 0.1 to 60
    // RATE: Seconds between particle bursts, 0.0 to 60
    // COUNT: Number of particles per burst, 1 to 4096
    // LIFE Number of seconds to wait before shutting off 0.1 to 60
    //       0.0 never stops
    
    // Part-3 - 3    PLACEMENT -- Where are new particles created, and what
    //                     direction  are they facing?
    integer   PATTERN = PSYS_SRC_PATTERN_ANGLE; // PSYS_SRC_PATTERN_DROP
    float      RADIUS = 0.00; // 0.00
    float ANGLE_BEGIN = 0.10; // 0.00
    float   ANGLE_END = 0.10; // 0.00
    vector      OMEGA = < 0.00, 0.01, 1.00 >; // < 0.00, 0.00, 0.00 >
    //float  INNERANGLE = 0.00; // 0.00
    //float  OUTERANGLE = 0.00; // 0.00
    // PATTERN: must be set to one of the following:
    //      PSYS_SRC_PATTERN_EXPLODE sends particles in all directions
    //      PSYS_SRC_PATTERN_DROP  ignores minSpeed and maxSpeed.  
    //      PSYS_SRC_PATTERN_ANGLE_CONE use ANGLE settings to make rings/cones
    //      PSYS_SRC_PATTERN_ANGLE use innerangle/outerangle to make flat
    //      wedges
    // RADIUS: distance between emitter and each new particle,  0.0 to 64?
    // ANGLE_BEGIN: for both ANGLE patterns, 0 to PI(3.14159)
    // ANGLE_END: for both for ANGLE patterns,  0 to PI.
    // OMEGA: How much to rotate the emitter around the <X,Y,Z> axises 
    //         after each burst.  Set OMEGA to all 0's to reset/disable it.
    // INNER/OUTER ANGLE:  Depreciated. Old versions of ANGLE_BEGIN/_END.
    //    Can still be used to make lop-sided angle displays though.

    //  Part-4 - MOVEMENT - How do the particles move once they're created?
    integer      FOLLOW_SRC = FALSE; // FALSE
    integer FOLLOW_VELOCITY = TRUE; // FALSE
    integer            WIND = TRUE; // FALSE
    integer          BOUNCE = TRUE; // FALSE 
    float         SPEED_MIN = 0.3; // 1.00
    float         SPEED_MAX = 0.9; // 1.00
    vector            ACCEL = < 0.00, 0.00, 0.00 >; // < 0.00, 0.00, 0.00 >
    integer      TARGET_POS = FALSE; // FALSE
    key              TARGET = llGetKey(); // llGetKey();
    // FOLLOW_SRC: moves particles when emitter moves. It will disable RADIUS!
    // FOLLOW_VELOCITY:  Particles rotate towards their heading
    // WIND: Sim's Wind will push particles 
    // BOUNCE: Make particles bounce above the Z altitude of emitter
    // SPEED_MIN: 0.01 to ?, slowest speed of new particles, 1.0(*)
    // SPEED_MAX: 0.01 to ?, fastest speed of new particle, 1.0(*)
    //      SPEED_ is ignored for the DROP pattern.
    // ACCEL: a continuous force pushed on particles, 
    //             use SMALL settings for long lived particles
    // TARGET_POS: If FALSE(*), TARGET value is ignored.
    // TARGET: Select a target for particles to arrive at when they die
    //      key TARGET = llGetKey(); // particles return to the emitter
    //      key TARGET = llGetOwner(); // particles home in on owner
    //      You can have another object llSay(999,llGetKey); 
    //      and grab the key with this object by using the listen() 
    //      event handler.
                     
    list particle_parameters = [
            PSYS_PART_FLAGS,( 
                ( EMISSIVE * PSYS_PART_EMISSIVE_MASK ) | 
                ( BOUNCE * PSYS_PART_BOUNCE_MASK ) | 
                ( INTERP_COLOR * PSYS_PART_INTERP_COLOR_MASK ) | 
                ( INTERP_SCALE * PSYS_PART_INTERP_SCALE_MASK ) | 
                ( WIND * PSYS_PART_WIND_MASK ) | 
                ( FOLLOW_SRC * PSYS_PART_FOLLOW_SRC_MASK ) | 
                ( FOLLOW_VELOCITY * PSYS_PART_FOLLOW_VELOCITY_MASK ) | 
                ( TARGET_POS * PSYS_PART_TARGET_POS_MASK ) ),
            PSYS_PART_START_COLOR, START_COLOR,
            PSYS_PART_END_COLOR, END_COLOR,
            PSYS_PART_START_ALPHA, START_ALPHA,
            PSYS_PART_END_ALPHA, END_ALPHA,
            PSYS_PART_START_SCALE, START_SCALE,
            PSYS_PART_END_SCALE, END_SCALE, 
            PSYS_SRC_PATTERN, PATTERN,
            PSYS_SRC_BURST_PART_COUNT, COUNT,
            PSYS_SRC_BURST_RATE, RATE,
            PSYS_PART_MAX_AGE, AGE,
            PSYS_SRC_ACCEL, ACCEL,
            PSYS_SRC_BURST_RADIUS, RADIUS,
            PSYS_SRC_BURST_SPEED_MIN, SPEED_MIN,
            PSYS_SRC_BURST_SPEED_MAX, SPEED_MAX,
            PSYS_SRC_TARGET_KEY, TARGET,
            PSYS_SRC_ANGLE_BEGIN, ANGLE_BEGIN, 
            PSYS_SRC_ANGLE_END, ANGLE_END,
            PSYS_SRC_OMEGA, OMEGA,
            PSYS_SRC_MAX_AGE, LIFE,
            PSYS_SRC_TEXTURE, TEXTURE
        ];
        
    llParticleSystem( particle_parameters ); // Turns on the particle hose!
        
    
}

default
{
    state_entry() {
        mySetParticles();
        // llSetTimerEvent(60); // uncomment to set auto-off for 60 seconds
    }
    
   
    
    touch(integer i) {
        mySetParticles(); // touch to reset/turn on the particles
        // llSetTimerEvent(60); // reset the alarm clock
    }
}
