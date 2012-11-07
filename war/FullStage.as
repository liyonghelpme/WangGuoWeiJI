//生成 飞行 爆炸阶段 其中 飞行 和 爆炸比较重要
//这里是生成  飞行 旋转

//生成 飞行 爆炸三个阶段都有的动画序列
class FullStage extends EffectBase
{

    function FullStage(s, t)
    {
        sol = s;
        tar = t;


        var p = sol.getPos();
        
        var off = getEffectOff(sol, tar);
        //位置 scale 图片之后 再设置相对位置
        //50 100
        // 45 
        var fullStage = getEffectAni(sol.id);
        var ani = pureMagicData[fullStage[0]];

        bg = sprite().anchor(50, 50).pos(p[0]+off[0], p[1]+off[1]).scale(ani[3]);//起始位置和人物位置和体积 高度相关
        init();
        shiftAni = moveto(0, 0, 0);
        initState();
    }
    override function initState() 
    {
        state = MAKE_NOW;
        setDir();
        initMakeState();
        updateTime();
    }
    function initMakeState()
    {
        var fullStage = getEffectAni(sol.id);
        var ani = pureMagicData[fullStage[0]];
        cus = new MyAnimate(ani[1], ani[0], bg);
        timeAll[MAKE_NOW] = ani[1];
    }

    function clearAnimate()
    {
        shiftAni.stop();
    }
    function initFlyState()
    {
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        timeAll[FLY_NOW] = dist*1000/speed;        


        var fullStage = getEffectAni(sol.id);
        var ani = pureMagicData[fullStage[1]];
        cus = new MyAnimate(ani[1], ani[0], bg);
        cus.enterScene();

        shiftAni = moveto(timeAll[FLY_NOW], tPos[0], bg.pos()[1]);
        bg.addaction(shiftAni);
    }
    function initBombState()
    {
        var fullStage = getEffectAni(sol.id);
        var ani = pureMagicData[fullStage[2]];
        timeAll[BOMB_NOW] = ani[1];
        cus = new MyAnimate(ani[1], ani[0], bg);
        cus.enterScene();

    }
    override function switchState()
    {
        if(state == MAKE_NOW)
        {
            state = FLY_NOW;
            cus.exitScene();
            clearAnimate();

            initFlyState();
        }
        else if(state == FLY_NOW)
        {
            state = BOMB_NOW;
            cus.exitScene();
            clearAnimate();
            initBombState();
        }
        else if(state == BOMB_NOW)
        {
            doHarm();
        }
        updateTime();
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
