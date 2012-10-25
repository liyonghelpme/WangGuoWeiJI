class VisitDialog extends MyNode
{
    var friendScene;
    function VisitDialog(fc)
    {
        friendScene = fc;
        bg = sprite("dialogVisitFriend.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        bg.addsprite().pos(231, 247).anchor(50, 50).addaction(repeat(animate(2000, "visitAni0.png", "visitAni1.png", "visitAni2.png", "visitAni3.png", "visitAni4.png", "visitAni5.png", "visitAni6.png", "visitAni7.png", "visitAni8.png", "visitAni9.png", "visitAni8.png", "visitAni7.png")));

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
        passTime += diff;
        if(friendScene != null)
        {
            if(friendScene.initOver == 1 && passTime >= 5000)
            {
                global.director.popView();
            }
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
    //231 247
}
