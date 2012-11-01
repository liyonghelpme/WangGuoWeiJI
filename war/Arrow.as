//不同的是3个阶段 有无
//3个阶段的处理函数
//相同重复的代码可以 提取称标准函数



//弓箭射击的是敌方的中部位置
//统一名字
//统一速度 200
//统一 init函数名字 初始当前状态
//统一update 根据当前状态
//状态有3中初始化 方法 
//初始 生成状态  初始 飞行状态 初始 爆炸状态

//统一attack 是flyTime
//得到当前阶段数 
class Arrow extends EffectBase
{
    function Arrow(s, t)
    {
        sol = s;
        tar = t;
        var id = sol.id;
        var p = sol.getPos();
        var off = getEffectOff(sol, tar);

        //soldier anchor 50 100 
        //-50 -50
        //单张弓箭图片  弓箭图片 弓箭缩放比例尺寸
        var ani = getArrowData(sol.id);
        bg = sprite("s"+str(id)+"e0.png").anchor(50, 50).pos(p[0]+off[0], p[1]+off[1]).scale(ani[3]);
        init();
        shiftAni = moveto(0, 0, 0);
        initState();
    }
    
    override function initState()
    {
        state = FLY_NOW;
        setDir();
        initFlyState();
    }
    function initFlyState()
    {
        var tPos = tar.getPos();
        var dist = abs(bg.pos()[0]-tPos[0]);
        timeAll[FLY_NOW] = dist*1000/speed;

        shiftAni = moveto(timeAll[FLY_NOW], tPos[0], bg.pos()[1]);
        bg.addaction(shiftAni);
        updateTime();
    }
    
    
    //切换状态
    //doHarm 直接就计算了战斗伤害 并且 清理了 状态应该由 EffectBase 来管理
    override function switchState()
    {
        if(state == FLY_NOW)
        {
            doHarm();
        }
    }

    override function enterScene()
    {
        super.enterScene();
        sol.map.myTimer.addTimer(this);
    }
    override function exitScene()
    {
        sol.map.myTimer.removeTimer(this);
        super.exitScene();
    }

}
