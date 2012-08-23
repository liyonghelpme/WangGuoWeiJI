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
    function SoldierAnimate(d, a0, a1, b, f, col)
    {
        bg = b;
        duration = d;
        ani0 = a0;
        ani1 = a1;
        accTime = 0;
        fea = f;
        colFea = col;
    }
    function enterScene()
    {
        global.myAction.addAct(this);
    }
    function update(diff)
    {
        accTime += diff;
        accTime %= duration;
        var curFrame = accTime*len(ani0)/duration;
        bg.texture(ani0[curFrame], ARGB_8888, UPDATE_SIZE);
        fea.texture(ani1[curFrame], ARGB_8888, colFea, UPDATE_SIZE);
    }
    function stop()
    {
        global.myAction.removeAct(this);
        accTime = 0;
    }
    function exitScene()
    {
        global.myAction.removeAct(this);
    }
}
