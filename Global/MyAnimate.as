class MyAction
{
    var cus;
    var lastTime;
    var actions;
    function MyAction()
    {
        actions = [];
        //lastTime = time();
        lastTime = 0;
        //cus = customaction(MAX_INT, start, update);
        cus = c_addtimer(50, update, null, 0, -1);
        //getscene().addaction(cus);
    }
    function stop()
    {
        cus.stop();
    }
    function removeAct(obj)
    {
        for(var i = 0; i < len(actions); i++)
        {
            if(actions[i][0] == obj)
            {
                actions[i][1] = 1;
            }
        }
    }
    function addAct(obj)
    {
        actions.append([obj, 0]);
    }
    function start()
    {
    }
    function update()
    {
        var now = time();
        var diff;
        if(lastTime == 0)
            diff = 0;
        else
            diff = now - lastTime;
        lastTime = now;
        for(var i = 0; i < len(actions);)
        {
            if(actions[i][1] == 1)
            {
                actions.pop(i);
            }
            else
            {
                actions[i][0].update(diff);
                i++;
            }
        }
    }
}
class MyAnimate
{
    var bg;
    //var cus;
    var ani;
    //var lastTime;
    var accTime;
    var duration;

    var realAni = null;
    //循环播放动画
    function MyAnimate(d, a, b)
    {
        bg = b;
        duration = d;
        ani = a;
        accTime = 0;

        realAni = repeat(animate(duration, ani, ARGB_8888, UPDATE_SIZE));
    }
    function setAni(a)
    {
        ani = a[0];
        duration = a[1];
        accTime = 0;
        realAni.stop();
        realAni = repeat(animate(duration, ani, ARGB_8888, UPDATE_SIZE));
    }
    function enterScene()
    {
        global.myAction.addAct(this);
        bg.addaction(realAni);
    }
    function update(diff)
    {
        accTime += diff;
        accTime %= duration;
    }
    function exitScene()
    {
        realAni.stop();
        global.myAction.removeAct(this);
    }
}
//选择英雄页面 英雄的 闪光动画  英雄图片上面有一个贴层 用于显示全闪光 也就是分离size 和 图内容， 但是动画的时候 需要调整这个背景的size和图内容
//一次性动画
class LightAnimate
{
    var bg;
    var ani;
    var accTime;
    var duration;
    var restore = 0;
    var oldTexture;
    var callback;//动画结束调用回调函数 处理

    var realAni = null;
    function LightAnimate(d, a, b, old, re, cb)
    {
        restore = re;
        bg = b;
        oldTexture = old;
        duration = d;
        ani = a;
        accTime = 0;
        callback = cb;
        realAni = animate(duration, ani, ARGB_8888, UPDATE_SIZE);
    }

    function setAni(a, re)
    {
        restore = re;
        ani = a[0];
        duration = a[1];
        accTime = 0;

        realAni.stop();
        realAni = animate(duration, ani, ARGB_8888, UPDATE_SIZE);
    }
    function enterScene()
    {
        global.myAction.addAct(this);
        bg.addaction(realAni);
    }
    function update(diff)
    {
        accTime += diff;
        //动画显示最后一张
        if(accTime >= duration)
        {
            exitScene();
            if(restore)
                bg.texture(oldTexture, ARGB_8888, UPDATE_SIZE);
            else
                bg.texture(ani[len(ani)-1], ARGB_8888, UPDATE_SIZE);
            if(callback != null)
                callback();
            return;
        }
    }
    function exitScene()
    {
        realAni.stop();
        global.myAction.removeAct(this);
    }
}
//传入数组动画 ani 
class OneAnimate
{
    var bg;
    var ani;
    var accTime;
    var duration;
    var restore = 0;
    var oldTexture;

    var realAni = null;
    function OneAnimate(d, a, b, old, re)
    {
        restore = re;
        bg = b;
        oldTexture = old;
        duration = d;
        ani = a;
        accTime = 0;
        realAni = animate(duration, ani, ARGB_8888, UPDATE_SIZE);
    }

    function setAni(a, re)
    {
        restore = re;

        ani = a[0];
        duration = a[1];
        accTime = 0;
        realAni.stop();
        realAni = animate(duration, ani, ARGB_8888, UPDATE_SIZE);
    }
    function enterScene()
    {
        global.myAction.addAct(this);
        realAni.stop();
        bg.addaction(realAni);
    }
    function update(diff)
    {
        accTime += diff;
        //动画显示最后一张
        if(accTime >= duration)
        {
            exitScene();
            if(restore)
                bg.texture(oldTexture, ARGB_8888, UPDATE_SIZE);
            else
                bg.texture(ani[len(ani)-1], ARGB_8888, UPDATE_SIZE);
            return;
        }
    }
    function exitScene()
    {
        realAni.stop();
        global.myAction.removeAct(this);
    }
}
