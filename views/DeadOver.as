/*
人物 changeDirNode anchor -->50 50
人物位置 移动 cs = changeDirNode.size()    curPos = changeDirNode.pos()   curPos[0] curPos[1]-cs[1]/2
人物 跳起 moveTo(curPos[0], curPos[1]-cs[1]/2-20) 
人物 旋转 -90 +90
人物 落下
人物 出现 血迹
*/
class DeadOver extends MyNode
{
    var soldier;
    var cs;
    const FALL_TIME = 700;
    var changeDirNode;
    function DeadOver(sol)
    {
        soldier = sol;
        bg = node();
        init();

        changeDirNode = soldier.changeDirNode;
        //cs = changeDirNode.prepare().size();
        cs = sol.bg.size();//bg Size
        var curPos = changeDirNode.pos();
        var dir = soldier.getDir();
        if(dir < 0)
            dir = -90
        else
            dir = 90;
//        trace("changeDirNode", cs, curPos, dir, "soldier"+str(soldier.id)+"dead.png");
        changeDirNode.anchor(50, 50).pos(curPos[0], curPos[1]-cs[1]/2);

        changeDirNode.addaction(
            sequence(
                moveby(200, 0, -30), 
                spawn(rotateby(500, dir), moveby(500, 0, 20+cs[1]/2)), 
                itexture("soldier"+str(soldier.id)+"dead.png", UPDATE_SIZE), 
                irotateby(-dir),
                fadeout(1000)) 
        );

        var blood = sprite("blood.png").anchor(50, 50).pos(cs[0]/2, cs[1]);
        soldier.bg.add(blood, -1);
        blood.addaction( 
            sequence(
                itintto(0, 0, 0, 0), 
                delaytime(FALL_TIME), 
                itintto(100, 100, 100, 100), 
                fadeout(2000))
        );
    }
}
class SpeakDialog extends MyNode
{
    var words;
    var soldier;
    var randWord;
    var curWord = 0;
    function SpeakDialog(s)
    {
        soldier = s;
        randWord = [getStr("myNameIs", ["[NAME]", soldier.myName]), getStr("letFight", null)];
        bg = sprite("speakBack.png").anchor(50, 100);
        words = bg.addlabel(randWord[curWord], null, 20).anchor(50, 50).pos(79, 25).color(0, 0, 0);
        init();
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
        if(passTime >= 5000)
        {
            passTime = 0;
            curWord ++;
            curWord %= len(randWord);
            words.text(randWord[curWord]);
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}

