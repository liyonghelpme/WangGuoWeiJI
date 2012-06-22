class VisitDialog extends MyNode
{
    function VisitDialog()
    {
        bg = sprite("dialogVisitFriend.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        init();
        bg.addsprite().pos(231, 247).anchor(50, 50).addaction(repeat(animate(2000, "visitAni0.png", "visitAni1.png", "visitAni2.png", "visitAni3.png", "visitAni4.png", "visitAni5.png", "visitAni6.png", "visitAni7.png", "visitAni8.png", "visitAni9.png", "visitAni8.png", "visitAni7.png")));

    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    var passTime = 0;
    function update(diff)
    {
        passTime += diff;
        if(passTime >= 3000)
        {
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
