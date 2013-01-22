//人物图层 特征色图层
//动画列表
class SoldierAnimate
{
    var bg;
    var fea;
    var ani0;
    var ani1;
    var accTime;
    var duration;
    var colFea;
    var start = 0;
    var realAni = null;
    function SoldierAnimate(d, a0, a1, b, f, col)
    {
        bg = b;
        duration = d;
        ani0 = a0;
        ani1 = a1;
        accTime = 0;
        fea = f;
        colFea = col;

        realAni = repeat(animate(duration, ani0, ARGB_8888, UPDATE_SIZE)); 
    }
    function enterScene()
    {
        global.myAction.addAct(this);
        if(!start)
        {
            bg.addaction(realAni);
        }
        start = 1;
    }
    function update(diff)
    {
        accTime += diff;
        accTime %= duration;
        //var curFrame = accTime*len(ani0)/duration;
        //bg.texture(ani0[curFrame], ARGB_8888, UPDATE_SIZE);
        //fea.texture(ani1[curFrame], ARGB_8888, colFea, UPDATE_SIZE);
    }
    function clearAnimation()
    {
        start = 0;
        realAni.stop();
        global.myAction.removeAct(this);
        accTime = 0;
    }
    function exitScene()
    {
        start = 0;
        realAni.stop();
        global.myAction.removeAct(this);
    }
}
