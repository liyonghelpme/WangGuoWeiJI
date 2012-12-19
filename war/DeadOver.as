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
        changeDirNode.texture("soldier"+str(soldier.id)+"dead.png", UPDATE_SIZE);

        /*
                delaytime(getParam("deadWaitTime")),
                expout(moveby(getParam("jumpUpTime"), 0, getParam("jumpHeight"))), 
                spawn(expout(rotateby(getParam("rotateTime"), dir)), expout(moveby(getParam("rotateTime"), 0, 5+cs[1]/2))), 
                itexture("soldier"+str(soldier.id)+"dead.png", UPDATE_SIZE), 
                irotateby(-dir),
        */
        changeDirNode.addaction(
            sequence(
                tintto(getParam("twinkleTime"), 0, 0, 0, 0),
                tintto(getParam("twinkleTime"), 100, 100, 100, 100),
                tintto(getParam("twinkleTime"), 0, 0, 0, 0),
                tintto(getParam("twinkleTime"), 100, 100, 100, 100),
                tintto(getParam("twinkleTime"), 0, 0, 0, 0)
            )
        );

        var feaFil = FEA_BLUE;
        if(soldier.color == ENECOLOR)
            feaFil = FEA_RED;
        fea.texture("soldier"+str(soldier.id)+"deadFea.png", feaFil, UPDATE_SIZE);

        /*
        fea.addaction(
            sequence(
                delaytime(getParam("deadWaitTime")+getParam("jumpUpTime")+getParam("rotateTime")),
                itexture("soldier"+str(soldier.id)+"deadFea.png", feaFil, UPDATE_SIZE)
            )
        );
        */

        //横向调整 血液位置
        /*
        var blood = sprite("blood0.png").anchor(50, 50).pos(cs[0]/2, cs[1]);
        soldier.bg.add(blood, -1);
        blood.addaction( 
            sequence(
                //itintto(0, 0, 0, 0), 
                //delaytime(getParam("deadWaitTime")+getParam("jumpUpTime")+getParam("rotateTime")),
                itintto(100, 100, 100, 100), 
                delaytime(getParam("twinkleTime")*5),
                fadeout(getParam("bloodDisappearTime"))
            )
        );
        */
    }
}
