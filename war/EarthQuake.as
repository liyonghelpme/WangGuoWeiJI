//从地面长出 爆炸的地刺攻击
//随着地图不同 地面有不同的 地裂效果
//map 很重要
class EarthQuake extends EffectBase
{

    function EarthQuake(s, t)
    {
        sol = s;
        tar = t;

        var p = sol.getPos();
        

        var off = getEffectOff(sol, tar);

        var earthQuake = getEarthQuake(sol.map.kind, sol.id);

        var ani = pureMagicData[earthQuake[2]];

        //50 50 出现在敌人脚下
        bg = sprite().anchor(50, 50).pos(p[0]+off[0], p[1]+off[1]).scale(ani[3]);
        init();
        shiftAni = moveto(0, 0, 0);
        initState();


    }
    override function initState()
    {
        state = BOMB_NOW;
        setDir();
        initBombState();
    }

    function initBombState()
    {
        var earthQuake = getEarthQuake(sol.map.kind, sol.id);
        var ani = pureMagicData[earthQuake[2]];
        cus = new MyAnimate(ani[1], ani[0], bg);
        timeAll[BOMB_NOW] = ani[1];
        bg.pos(tar.getPos());
        updateTime();
    }
        
    //直接使用 贝塞尔曲线描述
    // 水平速度是确定的
    // 运行轨迹确定
    // 旋转自主制造
    // 0 1 2 3
    //从敌人足部出现攻击体
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
