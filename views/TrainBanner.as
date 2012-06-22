class TrainBanner extends MyNode
{
    function TrainBanner(nPos, exp)
    {
        bg = sprite("exp.png").pos(nPos).size(30, 30).anchor(50, 100);

        init();
        bg.addaction(sequence(delaytime(2000), callfunc(removeSelf)));
        //var flowExp = global.director.curScene.addsprite("exp.png").pos(nPos).anchor(50, 100).addaction(delaytime(1000), callfunc(flowRemove)).size(30, 30);
        bg.addlabel(str(exp), null, 25).anchor(0, 50).pos(50, 15).color(0, 0, 0);
    }

}
