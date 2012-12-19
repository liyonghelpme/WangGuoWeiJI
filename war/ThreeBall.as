//飞行阶段 动画
class ThreeBall extends EffectBase
{
    //三头地狱犬的三个火球
    //冥界球
    function ThreeBall(s, t)
    {
        sol = s;
        tar = t;
        var p = sol.getPos();
        var off = getEffectOff(sol, tar);
        var magic = getEffectAni(sol.id);
        trace("magicAni", sol.id, magic);
        var ani = pureMagicData[magic[1]];
        bg = sprite().anchor(50, 50).pos(p[0]+off[0], p[1]+off[1]).scale(sol.data["arrSca"]);//起始位置和人物位置和体积 高度相关
        init();
        shiftAni = moveto(0, 0, 0);
        initState();


    }
    override function initState()
    {
        state = FLY_NOW;
        setDir();
        initFlyState();
        updateTime();
    }
    //3 个粒子id 但是 用的图片相同只是颜色不同
    function initFlyState()
    {
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        timeAll[FLY_NOW] = dist*1000/speed;        

        shiftAni = moveto(timeAll[FLY_NOW], tPos[0], bg.pos()[1]);
        bg.addaction(shiftAni);

        var p = sol.getPos();
        var off = getEffectOff(sol, tar);
        //组合粒子特效的实现
        var startPos = [p[0]+off[0], p[1]+off[1]+sol.data["arrFlyOffY"]];
        var endPos = [tar.getPos()[0], p[1]+off[1]+sol.data["arrFlyOffY"]];
        var dir = getDir(); 
        var arrowTrail = new ThreeTrail(timeAll[FLY_NOW], startPos, endPos, dir);
        sol.map.addChildZ(arrowTrail, MAX_BUILD_ZORD);
    }
    override function switchState()
    {
        if(state == FLY_NOW)
            removeSelf();
    }
    override function enterScene()
    {
        super.enterScene();
        sol.map.myTimer.addTimer(this);
        //cus.enterScene();
    }
    override function exitScene()
    {
        //cus.exitScene();
        sol.map.myTimer.removeTimer(this);
        super.exitScene();
    }
}
