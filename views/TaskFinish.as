/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png


*/
class TaskFinish extends MyNode
{
    const INITX = -287;
    const ENDX = 0;
    const WIDTH = 327;
    const HEIGHT = 66;
    
    var right;
    function TaskFinish(words)
    {
        trace("taskFinish", words);
        bg = node().pos(94, 328).size(WIDTH, HEIGHT).clipping(1);
        init();

        right = bg.addsprite("taskBack.png").pos(INITX, 0).addaction(sequence(moveto(600, ENDX, 0), delaytime(1500), fadeout(600)));
        bg.addsprite("taskLeft.png");

        right.addlabel(words, null, 22).pos(35, 15).color(39, 23, 23);
        right.addlabel(getStr("finishTask", null), null, 22).pos(297, 15).color(17, 71, 18).anchor(100, 0);
    }
    const FINISH_TIME = 2600;
    var passTime = 0;
    function update(diff)
    {
        passTime += diff;
        if(passTime >= FINISH_TIME)
        {
            removeSelf();
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}
