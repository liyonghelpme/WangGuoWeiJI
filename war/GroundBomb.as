
//从地面长出 爆炸的地刺攻击
class GroundBomb extends EffectBase
{
    function GroundBomb(s, t)
    {
        sol = s;
        tar = t;

        var p = sol.getPos();
        
        var off = getEffectOff(sol, tar);

        var groundBomb = getEffectAni(sol.id);
        var ani = pureMagicData[groundBomb[2]];

        bg = sprite().anchor(50, 100).pos(p[0]+off[0], p[1]+off[1]).scale(sol.data["arrSca"]);
        init();
        shiftAni = moveto(0, 0, 0);
        initState();

    }
    override function initState()
    {
        state = BOMB_NOW;
        setDir();
        initBombState();
        updateTime();
    }
    function initBombState()
    {
        var groundBomb = getEffectAni(sol.id);
        var ani = pureMagicData[groundBomb[2]];
        cus = new OneAnimate(ani[1], ani[0], bg, "", 0);
        timeAll[BOMB_NOW] = ani[1];
        bg.pos(tar.getPos());
    }
    

    //两个阶段 不同动画
    //第一阶段 抛物线移动
    //第二阶段 爆炸
    override function switchState()
    {
        if(state == BOMB_NOW)
            doHarm();
    }
    override function enterScene()
    {
        super.enterScene();
        sol.map.myTimer.addTimer(this);
        cus.enterScene();
    }
    override function exitScene()
    {
        cus.exitScene();
        sol.map.myTimer.removeTimer(this);
        super.exitScene();
    }
}
