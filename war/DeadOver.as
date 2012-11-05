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

    var changeDirNode;
    var fea;
    //var deadTime = 

    const WAIT_TIME = 300;
    const ROTATE_TIME = 700;
    const FALL_TIME = ROTATE_TIME+WAIT_TIME;
    function DeadOver(sol)
    {
        soldier = sol;
        bg = node();
        init();

        changeDirNode = soldier.changeDirNode;

        fea = soldier.fea;
        cs = sol.bg.size();//bg Size
        var curPos = changeDirNode.pos();
        var dir = soldier.getDir();
        if(dir < 0)
            dir = -90
        else
            dir = 90;
        changeDirNode.anchor(50, 50).pos(curPos[0], curPos[1]-cs[1]/2);

        changeDirNode.addaction(
            sequence(
                delaytime(WAIT_TIME),
                moveby(100, 0, -15), 
                spawn(rotateby(ROTATE_TIME, dir), moveby(ROTATE_TIME, 0, 5+cs[1]/2)), 
                itexture("soldier"+str(soldier.id)+"dead.png", UPDATE_SIZE), 
                irotateby(-dir),
                tintto(200, 0, 0, 0, 0),
                tintto(200, 100, 100, 100, 100),
                tintto(200, 0, 0, 0, 0),
                tintto(200, 100, 100, 100, 100),
                tintto(200, 0, 0, 0, 0)
            )
        );

        var feaFil = FEA_BLUE;
        if(soldier.color == ENECOLOR)
            feaFil = FEA_RED;
        fea.addaction(
            sequence(
                delaytime(WAIT_TIME+100+ROTATE_TIME),
                itexture("soldier"+str(soldier.id)+"deadFea.png", feaFil, UPDATE_SIZE)
            )
        );

        //横向调整 血液位置
        var blood = sprite("blood0.png").anchor(50, 50).pos(cs[0]/2, cs[1]);
        soldier.bg.add(blood, -1);
        blood.addaction( 
            sequence(
                itintto(0, 0, 0, 0), 
                delaytime(FALL_TIME),
                itintto(100, 100, 100, 100), 
                delaytime(1000),
                fadeout(1000)
            )
        );
    }
}