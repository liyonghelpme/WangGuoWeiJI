
class MagicSoldier
{
    var sol;
    function MagicSoldier(s)
    {
        sol = s;
    }
    function doAttack()
    {
        sol.map.addChildZ(new Magic(sol, sol.tar), MAX_BUILD_ZORD);
    }
}
class LongDistanceSoldier
{
    var sol;

    function LongDistanceSoldier(s)
    {
        sol = s;
    }
    function doAttack()
    {
        sol.map.addChildZ(new Arrow(sol, sol.tar), MAX_BUILD_ZORD);
    }
}
class CloseSoldier 
{
    var sol;
    var cus;
    function CloseSoldier(s)
    {
        sol = s;
    }
    function doAttack()
    {
        if(sol.tar != null)
        {
            if(sol.data.get("attSpe") != -1)//攻击特效 不为-1表示存在
            {
                sol.map.addChildZ(new CloseAttackEffect(sol), 0);
            }
            var hurt = calHurt(sol, sol.tar);
            sol.tar.changeHealth(sol, -hurt);
        }
    }
}
