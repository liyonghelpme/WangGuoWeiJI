class TransformAnimate
{
    var soldier;
    var bg;
    var ani0;
    var accTime;
    var duration;
    //动画时间 动画序列0 

    var realAni = null;
    function TransformAnimate(d, a0, b, sol)
    {
        soldier = sol;
        bg = b;
        duration = d;
        ani0 = a0;
        accTime = 0;
        //trace("TransformAnimate", a0, accTime, duration);
        realAni = animate(duration, ani0, ARGB_8888, UPDATE_SIZE);//一次性动画
    }
    //进入场景开始动画 stop停止动画
    function enterScene()
    {
        global.myAction.addAct(this);
        bg.addaction(realAni);
    }
    function update(diff)
    {
        accTime += diff;
        //var curFrame;
        //trace("TransformAnimate", a0, accTime, duration);
        if(accTime >= duration)
        {
            //curFrame = len(ani0)-1;
            clearAnimation();//先停止动画再变身
            //bg.texture(ani0[curFrame], ARGB_8888, UPDATE_SIZE);
            soldier.finishTransform();
        }
        else
        {
            //curFrame = accTime*len(ani0)/duration;
            //bg.texture(ani0[curFrame], ARGB_8888, UPDATE_SIZE);
        }

    }
    function clearAnimation()
    {
        realAni.stop();
        global.myAction.removeAct(this);
        accTime = 0;
    }
    function exitScene()
    {
        realAni.stop();
        global.myAction.removeAct(this);
    }
}
