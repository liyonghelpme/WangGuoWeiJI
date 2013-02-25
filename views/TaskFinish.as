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
    
    const WAIT_T = 100;
    const MOVE_T = 1200;
    const DELAY_T = 2500;
    const FADE_T = 600;
    var right;
    var cli;
    function TaskFinish(words)
    {
        trace("taskFinish", words);
        bg = node().pos(94, 328);//.size(WIDTH, HEIGHT).clipping(1);
        init();

        cli = bg.addnode().size(WIDTH, HEIGHT).pos(10, 0).clipping(1);
        right = cli.addsprite("taskBack.png").pos(INITX, 0).addaction(sequence(delaytime(WAIT_T), moveto(MOVE_T, ENDX, 0), delaytime(DELAY_T), fadeout(FADE_T)));

        bg.addsprite("taskLeft.png").addaction(sequence(delaytime(WAIT_T+MOVE_T+DELAY_T), fadeout(FADE_T)));

right.addlabel(words, getFont(), 22).pos(getParam("taskOffX"), 33).color(39, 23, 23).anchor(0, 50);
right.addlabel(getStr("finishTask", null), getFont(), 22).pos(297, 33).color(17, 71, 18).anchor(100, 50);
    }
    const FINISH_TIME = MOVE_T+DELAY_T+FADE_T;
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
