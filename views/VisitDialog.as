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
    */
    function update(diff)
    {
        if(friendScene.initOver == 1)
        {
//            trace("popVisit");
            global.director.popView();
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
    //231 247
}
