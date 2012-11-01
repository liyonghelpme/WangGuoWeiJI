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

function getArrowData(id)
{
    var ani = magicAnimate.get(id);
    return pureMagicData[ani];
}
//
function getMakeFlyRoll(id)
{
    var ani = magicAnimate.get(id);
    load_sprite_sheet("s"+str(ani[0])+"e.plist");
    return ani;
}
function getFullStage(id)
{
    var ani = magicAnimate.get(id);
    for(var i = 0; i < len(ani); i++)
        load_sprite_sheet("s"+str(ani[i])+"e.plist");
    return ani;
}
function getGroundBomb(id)
{
    var ani = magicAnimate.get(id);
    for(var i = 0; i < len(ani); i++)
        if(ani[i] != -1)
            load_sprite_sheet("s"+str(ani[i])+"e.plist");
    return ani;
}
//根据地图类型计算图片id 00 00 xxx
function getEarthQuake(mapKind, id)
{
    var ani = magicAnimate.get(id);
    ani += mapKind*1000000;
    load_sprite_sheet("s"+str(ani)+"e.plist");
    return ani;
}
//进行深度数组才行拷贝ani = [-1, -1, xxx]
function getAttackAnimte(id)
{
    var ani = magicAnimate.get(id);
    for(var i = 0; i < len(ani); i++)
        if(ani[i] != -1)
            load_sprite_sheet("s"+str(ani[i])+"e.plist");
    return ani;
}

/*
不同ID 士兵 可能对应相同的技能数据
*/
function getMagicAnimate(id)
{
    var ani = magicAnimate.get(id);
    trace("loadMagic", ani);
    load_sprite_sheet("s"+str(ani)+"e.plist");
    return pureMagicData[ani];
    //return ani;
}
//FlyBomb ---> animate xxx xxx
function getFlyAndBombAni(id)
{
    var ani = magicAnimate.get(id);
    for(var i = 0; i < len(ani); i++)
        load_sprite_sheet("s"+str(ani[i])+"e.plist");
    return ani;
}
function getMakeAndFly(id)
{
    var ani = magicAnimate.get(id);
    for(var i = 0; i < len(ani); i++)
        load_sprite_sheet("s"+str(ani[i])+"e.plist");
    return ani;
}


