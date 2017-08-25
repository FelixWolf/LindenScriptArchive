default
{
    link_message(integer sender, integer num, string message, key id)
    {
        if(num)
        {
            llSetPrimitiveParams([PRIM_MATERIAL, PRIM_MATERIAL_LIGHT]);
        }
        else
        {
            llSetPrimitiveParams([PRIM_MATERIAL, PRIM_MATERIAL_GLASS]);
        }
    }
}
