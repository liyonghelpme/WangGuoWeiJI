class TransformAnimate
{
    var soldier;
    var bg;
    var ani0;
    var accTime;
    var duration;
    //动画时间 动画序列0 
    function TransformAnimate(d, a0, b, sol)
    {
        soldier = sol;
        bg = b;
        duration = d;
        ani0 = a0;
        accTime = 0;
        //trace("TransformAnimate", a0, accTime, duration);
    }
    //进入场景开始动画 stop停止动画
    function enterScene()
    {
        global.myAction.addAct(this);
    }
    function update(diff)
    {
        accTime += diff;
        var curFrame;
        if(accTime >= duration)
        {
            curFrame = len(ani0)-1;
            bg.texture(ani0[curFrame], ARGB_8888, UPDATE_SIZE);
            clearAnimation();
            soldier.finishTransform();
        }
        else
        {
            curFrame = accTime*len(ani0)/duration;
            bg.texture(ani0[curFrame], ARGB_8888, UPDATE_SIZE);
        }

    }
    function clearAnimation()
    {
        global.myAction.removeAct(this);
        accTime = 0;
    }
    function exitScene()
    {
        global.myAction.removeAct(this);
    }
}
