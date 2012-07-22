
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
            /*
            //var coff = getSoldierKindCoff(sol.kind, sol.tar.getKind());
            var phyHurt = sol.physicAttack - sol.tar.physicDefense;
            var magHurt = sol.magicAttack - sol.tar.magicDefense;
            phyHurt = max(phyHurt, sol.physicAttack/10);
            magHurt = max(magHurt, sol.magicAttack/10);

            //var hurt = coff*(sol.attack-sol.tar.defense)/100;
            //hurt = max(hurt, sol.attack/10);//伤害最小是攻击力的1/10
            hurt = phyHurt+magHurt;
            */
            var hurt = calHurt(sol, sol.tar);
            sol.tar.changeHealth(sol, -hurt);
        }
    }
}
