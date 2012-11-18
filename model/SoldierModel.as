/*
赤裸初始化士兵能力
*/
function initAttackAndDefense(sol)
{
    var pureData = getSolPureData(sol.id, sol.level);
    trace("pureData", pureData);
    sol.health = pureData["healthBoundary"]; 
    sol.healthBoundary = pureData["healthBoundary"];
    sol.physicAttack = pureData["physicAttack"];
    sol.physicDefense = pureData["physicDefense"];
    sol.magicAttack = pureData["magicAttack"];
    sol.magicDefense = pureData["magicDefense"];
}
function getSolPureData(id, level)
{
    var sdata = getData(SOLDIER, id); 
    var healthBoundary = sdata["initHealth"]+level*sdata["addHealth"];
    var physicAttack = sdata["initPhysicAttack"]+level*sdata["addPhysicAttack"];
    var physicDefense = sdata["initPhysicDefense"]+level*sdata["addPhysicDefense"];
    var magicAttack = sdata["initMagicAttack"]+level*sdata["addMagicAttack"];
    var magicDefense = sdata["initMagicDefense"]+level*sdata["addMagicDefense"];

    return dict([["physicAttack", physicAttack], ["physicDefense", physicDefense], ["magicAttack", magicAttack], ["magicDefense", magicDefense], ["healthBoundary", healthBoundary]]);
}
function calHurt(src, tar)
{
    var phyHurt = src.physicAttack*getParam("halfHarmNum")/(getParam("halfHarmNum")+tar.physicDefense);
    var magHurt = src.magicAttack*getParam("halfHarmNum")/(getParam("halfHarmNum")+tar.magicDefense);
    
    var hurt = max(phyHurt+magHurt, 1);

    var critical = rand(100);
    var criHit = 0;
    if(critical < src.data["criticalHitRate"])
    {
        criHit = 1;
        hurt *= 2;
    }
    hurt += src.leftHurt;
    var intHurt = myFloor(hurt);
    src.leftHurt = hurt-intHurt;
    return [intHurt, criHit];
}
