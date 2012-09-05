

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

    不是800 480 大小的图片 不适合做scene


    场景 --->map ----> 士兵 ---> 黑色图层--->士兵位置
*/

class SelectHero extends MyNode
{
    //var touchDelegate;
    var dia0;
    var dia1;
    var cmd = [];
    var curCmd = 0;
    var initYet = 0;
    var menuLayer = null;
    var heros = [440, 480, 550, 590];
    //var dirs = [-100, -100, 100, -100];
    var heroPic = [];
    var mapNode;
    var map;
    function getMapNormalScale()
    {
        return 810*100/1200;
    }
    function SelectHero()
    {
        //bg = sprite("battleEnd.jpg");
        bg = node();
        init();

        mapNode = new MyNode();
        map = sprite("battleEnd.jpg", ARGB_8888);
        mapNode.bg = map;
        //bg.add(map, 1);
        addChildZ(mapNode, 1);
        for(var i = 0; i < len(heros); i++)
        {
            var hid = heros[i];
            //var h = map.addsprite("hero"+str(hid)+"n.png", ARGB_8888).pos(HeroPos.get(hid)).anchor(50, 100).scale(dirs[i], 100);
            var h = map.addsprite("hero"+str(hid)+"l.png", ARGB_8888).pos(HeroPos.get(hid)).scale(HeroDir.get(hid), 100).anchor(50, 100);
            heroPic.append(h);

        }
        dia0 = map.addsprite("dialogBack0.png").pos(592, 138).visible(0);
        dia1 = map.addsprite("dialogBack1.png").pos(637, 243).visible(0);
        
        //dia0.addlabel(getStr("dearKing", null), null, 21, FONT_BOLD, 176, 0, ALIGN_LEFT).color(0, 0, 0).pos(23, 27);
        //dia1.addlabel(getStr("dearSuo", null), null, 21, FONT_BOLD, 245, 0, ALIGN_LEFT).color(0, 0, 0).pos(25, 25);

        //touchDelegate = new StandardTouchHandler();
        setCommand();
    }
    //0 1 dialogPanel
    function setCommand()
    {
        var NORMAL = getMapNormalScale();
        //cmd.append([SETPOS, [600, 360]]);
        cmd.append([CLOSEUP, [0, [0, 0], NORMAL]]);
        cmd.append([WAIT, 2000]);
        cmd.append([CLOSEUP, [2000, [237, 64], 100]]);
        cmd.append([SPEAK_NOW, [2000, "kingWeBack", 0]]);

        cmd.append([CLOSEUP, [1000, [0, 0], NORMAL]]);
        cmd.append([CLOSEUP, [1000, [285, 141], 100]]);
        cmd.append([SPEAK_NOW, [2000, "rebuildHome", 1]]);
        cmd.append([CLOSEUP, [1000, [0, 0], NORMAL]]);
        cmd.append([DARK_BACK]);
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
        //bg.pos(px, py);
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
   



    var curStep = 0;
    function updateMenu()
    {
    }


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
                            w = dia1.addlabel(getStr(c[1][1], null), null, 21, FONT_BOLD, 256, 0, ALIGN_LEFT).color(0, 0, 0).pos(20, 17);
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
                else if(c[0] == DARK_BACK)
                {
                    for(var i = 0; i < len(heroPic); i++)
                    {
                        heroPic[i].removefromparent();
                    }
                    menuLayer = new SelectMenu(this, curStep);
                    addChildZ(menuLayer, 2);
                    curCmd++;
                }
            }
            else
            {
                
            }
        }
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
