class VisitDialog extends MyNode
{
    var friendScene;
    var tipWord;
    var kind;
    var back;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("dialogVisitFriend.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        back = temp;
        load_sprite_sheet("visitAni.plist");
        temp.addsprite().anchor(50, 50).pos(231, 247).addaction(repeat(animate(500, 
            ["visitAni.plist/visitAni0.png", "visitAni.plist/visitAni1.png", "visitAni.plist/visitAni2.png"]
        )));

        var tid = global.user.getLoadTip();
tipWord = back.addlabel(getStr("tip" + str(tid), null), getFont(), 18).anchor(50, 50).pos(233, 324).color(100, 100, 100);
back.addlabel(getStr("Flying", null), getFont(), 30).anchor(50, 50).pos(232, 31).color(100, 100, 100);
    }
    function VisitDialog(fc, k)
    {
        kind = k;
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

    停留在当前场景 ---》主经营页面场景 或者当前好友的场景
    等待 friendScene 初始化结束 则 replaceScene 或者 pushScene
    主经营页面则pushScene 好友页面则 replaceScene
    或者主经营页面也可以replace 而 重新进入 而初始化 数据即可
    */
    var passTime = 0;
    function update(diff)
    {
        if(friendScene != null)
        {
            if(friendScene.initOver == 1)
            {
                global.director.popView();
                friendScene.removeSelf();
                trace("pushScene");
                if(kind == FRIEND_DIA_INFRIEND)
                    global.director.replaceScene(friendScene);
                else if(kind == FRIEND_DIA_HOME)
                    global.director.pushScene(friendScene);
            }
        }
        passTime += diff;
        if(passTime >= 3000)
        {
            passTime -= 3000;
            var tid = global.user.getLoadTip();
            tipWord.text(getStr("tip"+str(tid), null));
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
    //231 247
}
