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


SPEAK_NOW waitTime 动作并行处理
ATTACK---->soldierId soldierId soldierId soldiers = [0, 1, 2, 3, 4 ,5 ,6]
SHOW_WORD---> time
WAIT 
SHOW_WORD which pos
WAIT
SHOW_WORD

*/

class SpeakSoldier extends MyNode
{
    const SOL_DIR = dict([
        [190, -1],
        [30, 1],
        [2, 1],
    ]);
    const SOL_SCALE = dict([
        [190, 60*100/90],
        [30, 75*100/90],
        [2, 70*100/90],
    ]);
    const SOL_POS = dict([
        [190, 
            [[277, 257],
            [277, 291],
            [277, 340]]],
        [30, 
            [[650, 192],
            [650, 213],
            [650, 248],
            [650, 281]]],

        [2,
            [[650, 345],
            [650, 379],
            [650, 412],
            [650, 451]]],
    ]);
    var id;
    var attAni;
    function SpeakSoldier(k, p)
    {
        id = k;
        load_sprite_sheet("soldiera"+str(id)+".plist");
        load_sprite_sheet("soldiera"+str(id)+".plist");
        var sca = SOL_SCALE.get(id);
        var dir = SOL_DIR.get(id);
        var po = SOL_POS.get(id)[p];

        bg = sprite("soldiera"+str(id)+".plist/ss"+str(id)+"a0.png").anchor(50, 100).scale(sca*dir, sca).pos(po);
        init();

        attAni = animate(1500, "soldiera"+str(id)+".plist/ss"+str(id)+"a0.png", "soldiera"+str(id)+".plist/ss"+str(id)+"a1.png","soldiera"+str(id)+".plist/ss"+str(id)+"a2.png","soldiera"+str(id)+".plist/ss"+str(id)+"a3.png","soldiera"+str(id)+".plist/ss"+str(id)+"a4.png","soldiera"+str(id)+".plist/ss"+str(id)+"a5.png","soldiera"+str(id)+".plist/ss"+str(id)+"a6.png", "soldiera"+str(id)+".plist/ss"+str(id)+"a0.png",  UPDATE_SIZE);

    }
    function showAttack()
    {
        bg.addaction(attAni);
    }
}
class NewBattle extends MyNode
{
    var soldiers = dict();
    //var touchDelegate;
    var dia0;
    var dia1;
    var cmd = [];
    var curCmd = 0;
    var initYet = 0;
    var map;
    var words = dict();
    var dialogController;
    const SOL_KIND = [
        [190, 0],
        [190, 1],
        [190, 2],

        [30, 0],
        [30, 1],
        [30, 2],
        [30, 3],

        [2, 0],
        [2, 1],
        [2, 2],
        [2, 3],
    ];

    const WORD_POS = [
        [250, 239, "wu.png"],
        [241, 140, "haha.png"],
        [170, 362, "sok.png"],
        [733, 302, "kill0.png"],
        [711, 210, "kill1.png"],
        [603, 331, "kill2.png"],
        [596, 187, "kill3.png"],
        [315, 351, "question.png"],
    ];

    const WORD_TIME = 500;
    function NewBattle()
    {
        bg = node();
        init();
        dialogController = new DialogController(this);
        addChild(dialogController);


        map = bg.addsprite("battleBegin0.jpg");

        dia0 = bg.addsprite("dialogBack0.png").pos(98, 85).visible(0);
        dia1 = bg.addsprite("dialogBack1.png").pos(495, 111).visible(0);

        
        /*
        for(var i = 0; i < len(SOL_KIND); i++)
        {
            var so = new SpeakSoldier(SOL_KIND[i][0], SOL_KIND[i][1]);
            soldiers.update(i, so);
            map.add(so.bg, so.getPos()[1]);
        }
        for(i = 0; i < len(WORD_POS); i++)
        {
            var w = sprite(WORD_POS[i][2]).pos(WORD_POS[i][0], WORD_POS[i][1]).visible(0);
            bg.add(w, MAX_BUILD_ZORD);
            words.update(i, w);
        }
        */
        setCommand();
    }
    //0 1 dialogPanel
    //1200 720 --> 800 480
    function setCommand()
    {
        //var NORMAL = 810*100/1200;
        var NORMAL = 100;
        cmd.append([CLOSEUP, [0, [0, 0], NORMAL]]);//缩放到正常大小 屏幕中心对齐背景中心
        cmd.append([WAIT, 2000]);
        cmd.append([SPEAK_NOW, [3000, "dearKing", 0]]);

        /*
        cmd.append([MON_ATTACK, 0]);
        cmd.append([MON_ATTACK, 1]);
        cmd.append([MON_ATTACK, 2]);
        cmd.append([MON_SPEAK, 0]);
        cmd.append([WAIT, WORD_TIME]);


        cmd.append([MON_SPEAK, 1]);
        cmd.append([WAIT, WORD_TIME]);
        cmd.append([MON_SPEAK, 2]);
        cmd.append([WAIT, WORD_TIME]);
        cmd.append([MON_SPEAK, 7]);
        */

        cmd.append([SPEAK_NOW, [3000, "fightNow", 1]]);

        /*
        cmd.append([MON_SPEAK, 5]);
        cmd.append([MON_ATTACK, 3]);
        cmd.append([MON_ATTACK, 4]);
        cmd.append([MON_ATTACK, 5]);
        cmd.append([MON_ATTACK, 6]);
        cmd.append([MON_ATTACK, 7]);
        cmd.append([MON_ATTACK, 8]);
        cmd.append([MON_ATTACK, 9]);
        cmd.append([MON_ATTACK, 10]);
        cmd.append([WAIT, WORD_TIME]);

        cmd.append([MON_SPEAK, 6]);
        cmd.append([WAIT, WORD_TIME]);
        cmd.append([MON_SPEAK, 4]);
        cmd.append([WAIT, WORD_TIME]);
        cmd.append([MON_SPEAK, 3]);
        cmd.append([WAIT, WORD_TIME]);
        */


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
                //trace("command", cmd[curCmd], curCmd);
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
                            w = dia0.addlabel(getStr(c[1][1], null), "fonts/heiti.ttf", 17, FONT_NORMAL, getParam("dia0Width"), 0, ALIGN_LEFT).anchor(0, 0).pos(getParam("dia0X"), 20).color(0, 0, 0);

                            dia0.stop();
                            dia0.addaction(sequence(itintto(100, 100, 100, 100), delaytime(2000), fadeout(1000)));
                        }
                        else if(c[1][2] == 1)
                        {
                            dia1.visible(1);
                            w = dia1.addlabel(getStr(c[1][1], null), "fonts/heiti.ttf", 17, FONT_NORMAL, 188, 0, ALIGN_LEFT).anchor(0, 0).pos(getParam("dia1X"), 21).color(0, 0, 0);
                            dia1.stop();
                            dia1.addaction(sequence(itintto(100, 100, 100, 100), delaytime(2000), fadeout(1000)));
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
                else if(c[0] == MON_ATTACK)
                {
                    var so = soldiers.get(c[1]);
                    so.showAttack();
                    curCmd++;
                }
                else if(c[0] == MON_SPEAK)
                {
                    var w1 = words.get(c[1]);
                    w1.visible(1);
                    w1.addaction(sequence(delaytime(2000), fadeout(1000)));
                    curCmd++;
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
