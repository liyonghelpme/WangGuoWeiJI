function getEffectOff(sol, tar)
{
    var p = sol.getPos();
    var difx = tar.getPos()[0]-p[0];
    var offY = sol.data.get("arrpy");

    var offX = sol.data.get("arrpx");
    if(difx > 0)
    {
        offX = -offX;
    }
    return [offX, offY];
}


function getEarthQuake(mapKind, id)
{
    var ani = magicAnimate.get(id);
    ani = copy(ani);
    for(var i = 0; i < len(ani); i++)
    {
        if(ani[i] != -1)
        {
            ani[i] %= 1000000;
            ani[i] += mapKind*1000000;
            load_sprite_sheet("s"+str(ani[i])+"e.plist");
        }
    }
    return ani;
}
function getEffectAni(id)
{
    var ani = magicAnimate.get(id);
    trace("getEffectAni", id, ani);
    for(var i = 0; i < len(ani); i++)
        if(ani[i] != -1)
            load_sprite_sheet("s"+str(ani[i])+"e.plist");
    return ani;
}

function getArrowData(id)
{
    var ani = magicAnimate.get(id);
    return ani;
}
