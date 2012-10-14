class VisitDialog extends MyNode
{
    var friendScene;
    var tipWord;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("visitBack.jpg").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        temp = bg.addsprite().anchor(50, 50).pos(403, 274).size(290, 130).color(100, 100, 100, 100).addaction(repeat(animate(2000, "visitAni0.png", "visitAni1.png", "visitAni2.png", "visitAni3.png", "visitAni4.png", "visitAni5.png", "visitAni6.png", "visitAni7.png", "visitAni8.png", "visitAni9.png", "visitAni8.png", "visitAni7.png", UPDATE_SIZE)));

        var tid = global.user.getNextTip();
        tipWord = bg.addlabel(getStr("tips"+str(tid), null), "fonts/heiti.ttf", 17).anchor(50, 50).pos(405, 366).color(100, 100, 100);

        var prW = new BackWord(this, getStr("flying", null), 37, 15, [66, 46, 28], 800, 0, 4, null, FONT_BOLD);
        prW.setPos([342, 59]);
        addChild(prW);
        //瞬时命令立即执行
        var cmd = [
            [SET_TIME, 4],
            [BEGIN_REPEAT, [-1, -1]],//循环次数 循环结束进入的下一条语句位置
            [SET_CURPOS, [0, 2]],
            [PRINT, 6],
            [END_REPEAT, -1],//循环开始位置 
        ];
        prW.setCommand(cmd);
    }
    function VisitDialog(fc)
    {
        friendScene = fc;
        initView();
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    /*
    访问好友或者挑战好友 获取数据成功之后关闭对话框
    等待界面 如果没有用则由场景主动控制关闭
    但是要避免弹出其它对话框
    */
    var passTime = 0;
    function update(diff)
    {
        if(friendScene != null)
        {
            if(friendScene.initOver == 1)
            {
                global.director.popView();
            }
        }
        passTime += diff;
        if(passTime >= 3000)
        {
            passTime -= 3000;
            var tid = global.user.getNextTip();
            tipWord.text(getStr("tips"+str(tid), null));
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
    //231 247
}
