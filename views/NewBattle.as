/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png


剧本://等待两秒 应该是异步的---》callback
    wait(2000)

控制镜头：
    800 480 镜头大小 镜头距离100  正常大小
    镜头中坐标: bg.pos()
    镜头相对物体坐标 12 215---》 物体相对镜头坐标----》
    物体scale 150
    bg.size()*150/100;

    场景背景 和 map背景是不同的两个node
*/
class NewBattle extends MyNode
{
    //var touchDelegate;
    var dia0;
    var dia1;
    var cmd = [];
    var curCmd = 0;
    var initYet = 0;
    var map;
    function NewBattle()
    {
        //bg = sprite("battleBegin.jpg");
        bg = node();
        init();
        map = bg.addsprite("battleBegin.jpg");

        dia0 = map.addsprite("dialogBack0.png").pos(115, 157).visible(0);
        dia1 = map.addsprite("dialogBack1.png").pos(793, 232).visible(0);

        
        //dia0.addlabel(getStr("dearKing", null), null, 21, FONT_BOLD, 176, 0, ALIGN_LEFT).color(0, 0, 0).pos(23, 27);
        //dia1.addlabel(getStr("dearSuo", null), null, 21, FONT_BOLD, 245, 0, ALIGN_LEFT).color(0, 0, 0).pos(25, 25);

        //touchDelegate = new StandardTouchHandler();
        setCommand();
    }
    //0 1 dialogPanel
    //1200 720 --> 800 480
    function setCommand()
    {
        var NORMAL = 810*100/1200;
        //cmd.append([SETPOS, [600, 360]]);
        cmd.append([CLOSEUP, [0, [0, 0], NORMAL]]);//缩放到正常大小 屏幕中心对齐背景中心
        cmd.append([WAIT, 3000]);
        cmd.append([CLOSEUP, [2000, [7, 150], 100]]);
        cmd.append([SPEAK_NOW, [2000, "dearKing", 0]]);
        cmd.append([CLOSEUP, [1000, [0, 0], NORMAL]]);
        cmd.append([CLOSEUP, [1000, [388, 141], 100]]);
        cmd.append([SPEAK_NOW, [2000, "dearSuo", 1]]);
        cmd.append([SPEAK_NOW, [2000, "fightNow", 1]]);
        initYet = 1;
    }
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
    }
    override function exitScene()
    {
        global.myAction.removeAct(this);
        super.exitScene();
    }
    //将p点至于屏幕中心
    function setpos(p)
    {
        //var px = global.director.disSize[0]/2-p[0];
        //var py = global.director.disSize[1]/2-p[1];
        //map.pos(px, py);
    }
    //当前位置 特写到莫个位置 
    //镜头拉近 12 215 位置 在 1.5倍后的位置
    //bg 移动的距离是？
    //镜头位置， 镜头缩放比率， 动作时间

    function closeUp(t, p, rate)
    {
        map.addaction(moveto(t, -p[0], -p[1]));
        map.addaction(scaleto(t, rate, rate));
    }
    var w;
    var passTime = 0;
    //命令结束时 将计时器清0
    function update(diff)
    {
        if(initYet == 1)
        {

            if(curCmd < len(cmd))
            {
                trace("command", cmd[curCmd], curCmd);
                var c = cmd[curCmd];
                if(c[0] == SETPOS)
                {
                    setpos(c[1]);
                    curCmd++;
                }
                else if(c[0] == WAIT)
                {
                    passTime += diff;
                    if(passTime >= c[1])
                    {
                        passTime = 0;
                        curCmd++;
                    }
                }
                else if(c[0] == CLOSEUP)
                {
                    if(passTime == 0)
                    {
                        closeUp(c[1][0], c[1][1], c[1][2]);
                    }
                    passTime += diff;
                    if(passTime > c[1][0])
                    {
                        passTime = 0;
                        curCmd++;
                    }
                }
                else if(c[0] == SPEAK_NOW)
                {
                    var kind = c[1][2];
                    if(passTime == 0)
                    {
                        if(c[1][2] == 0)
                        {
                            dia0.visible(1);
                            w = dia0.addlabel(getStr(c[1][1], null), null, 21, FONT_BOLD, 176, 0, ALIGN_LEFT).color(0, 0, 0).pos(23, 27);
                        }
                        else if(c[1][2] == 1)
                        {
                            dia1.visible(1);
                            w = dia1.addlabel(getStr(c[1][1], null), null, 21, FONT_BOLD, 245, 0, ALIGN_LEFT).color(0, 0, 0).pos(25, 25);
                        }
                    }
                    passTime += diff;
                    if(passTime > c[1][0])
                    {
                        if(kind == 0)
                            dia0.visible(0);
                        else if(kind == 1)
                            dia1.visible(0);
                        w.removefromparent();
                        w = null;
                        passTime = 0;
                        curCmd++;
                    }
                }
            }
            else
            {
                //global.director.popScene();
                global.director.replaceScene(new BattleEnd());
            }
        }
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
