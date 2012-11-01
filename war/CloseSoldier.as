class OtherSoldier
{
    var sol;
    function OtherSoldier(s)
    {
        sol = s;
    }
    function doAttack()
    {
        var fakeTar = sol.tar;
        if(sol.kind == FLY_BOMB)
            sol.map.addChildZ(new FlyAndBomb(sol, fakeTar), MAX_BUILD_ZORD);
        else if(sol.kind == ROLL_BALL)
            sol.map.addChildZ(new RollBall(sol, fakeTar), MAX_BUILD_ZORD);
        else if(sol.kind == MAKE_FLY)
            sol.map.addChildZ(new MakeFly(sol, fakeTar), MAX_BUILD_ZORD);
        else if(sol.kind == MAKE_FLY_ROLL)
            sol.map.addChildZ(new MakeFlyRoll(sol, fakeTar), MAX_BUILD_ZORD);
        else if(sol.kind == FULL_STAGE)
            sol.map.addChildZ(new FullStage(sol, fakeTar), MAX_BUILD_ZORD);
        else if(sol.kind == GROUND_BOMB)
            sol.map.addChildZ(new GroundBomb(sol, fakeTar), MAX_BUILD_ZORD);
        else if(sol.kind == EARTH_QUAKE)
            sol.map.addChildZ(new EarthQuake(sol, fakeTar), 0);//地裂出现敌人脚下
        else if(sol.kind == MAGIC)
            sol.map.addChildZ(new Magic(sol, fakeTar), MAX_BUILD_ZORD);
        else if(sol.kind == ROCKET)
            sol.map.addChildZ(new Rocket(sol, fakeTar), MAX_BUILD_ZORD);
        else if(sol.kind == LONG_DISTANCE)
            sol.map.addChildZ(new Arrow(sol, fakeTar), MAX_BUILD_ZORD);
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
            /*
            //关闭近战特效
            if(sol.data.get("attSpe") != -1)//攻击特效 不为-1表示存在
            {
                sol.map.addChildZ(new CloseAttackEffect(sol), 0);
            }
            */
            var hurt = calHurt(sol, sol.tar);
            sol.tar.changeHealth(sol, -hurt);
        }
    }
}
