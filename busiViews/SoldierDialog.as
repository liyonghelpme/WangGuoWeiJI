/*
初始化view 代码
bg = 
init
bg.add

替换旧的SoldierDialog 对话框
*/
class SoldierDialog extends MyNode
{
    var views;
    var title;
    var titPic = ["dialogSoldierTitle.png", "dialogSoldierDead.png", "dialogSoldierTrans.png"];
    function SoldierDialog(viewId)
    {
        bg = node();
        init();
        bg.addsprite("back.png").anchor(0, 0).pos(0, 0).size(800, 480);
        bg.addsprite("diaBack.png").anchor(0, 0).pos(38, 10).size(705, 64);
        var but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);
        bg.addsprite("rightBack.png").anchor(0, 0).pos(254, 79).size(514, 387);
        bg.addsprite("leftBack.png").anchor(0, 0).pos(34, 79).size(197, 386);

        bg.addsprite("infoBack.png").anchor(0, 0).pos(33, 265).size(199, 130).color(100, 100, 100, 47);

        bg.addsprite("dialogSoldier.png").anchor(0, 0).pos(71, 10).size(174, 62);
        but0 = new NewButton("roleNameBut0.png", [113, 42], getStr("allSoldier", null), null, 20, FONT_NORMAL, [100, 100, 100], switchView, 0);
        but0.bg.pos(412, 43);
        addChild(but0);
        but0 = new NewButton("violetBut.png", [113, 42], getStr("deadSoldier", null), null, 20, FONT_NORMAL, [100, 100, 100], switchView, 1);
        but0.bg.pos(532, 43);
        addChild(but0);
        but0 = new NewButton("blueButton.png", [113, 42], getStr("waitTransfer", null), null, 20, FONT_NORMAL, [100, 100, 100], switchView, 2);
        but0.bg.pos(652, 43);
        addChild(but0);
        views = [new AllSoldier(this), new DeadSoldier(this), new TransferSoldier(this)];

        title = bg.addsprite("dialogSoldierTitle.png").anchor(50, 50).pos(513, 112).size(171, 33);

        switchView(viewId);
    }
    var selected = null;
    function switchView(viewId)
    {
        if(selected != null)
        {
            views[selected].removeSelf();
        }
        selected = viewId;
        addChild(views[selected]);
        title.texture(titPic[selected], UPDATE_SIZE);
    }
    
    function closeDialog()
    {
        global.director.popView();
    }
}
