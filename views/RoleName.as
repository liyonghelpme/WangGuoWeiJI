class RoleName extends MyNode
{
    var scene;
    var soldier;
    var inputView;
    var preName = ["李", "王", "赵", "张", "谢", "司马", "诸葛", "南宫", "东方", "西门", "相里"];
    var midName = ["白", "天", "彩虹", "腾", "逊", "无极"];
    var warnText;
    function RoleName(s, sol)
    {
        scene = s;
        soldier = sol;
        bg = sprite("roleName.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        bg.addlabel(getStr("nameSol", null), null, 25).pos(273, 29).anchor(50, 50).color(0, 0, 0);

        var solPng = bg.addsprite("soldier"+str(sol.id)+".png").pos(109, 137).anchor(50, 50);
        var bsize = solPng.prepare().size(); 
        var sca = min(90*100/bsize[0], 90*100/bsize[1]);
        solPng.scale(sca);

        //526 34
        init();
        bg.prepare();
        var bSize = bg.size();
        //bg.addsprite("roleNameClose.png").pos(526, 34).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        //bg.addsprite("roleNameDia.png").pos(141, 115);
        inputView = v_create(V_INPUT_VIEW, global.director.disSize[0]/2-bSize[0]/2+165, global.director.disSize[1]/2-bSize[1]/2+100, 218, 35);
        warnText = bg.addlabel(getStr("nameNotNull", null), null, 20).anchor(0, 0).pos(165, 150).color(100, 0, 0).visible(0);

        var but = bg.addsprite("roleNameBut0.png").size(145, 46).pos(152, 265).anchor(50, 50).setevent(EVENT_TOUCH, randomName);
        but.addlabel(getStr("rand", null), null, 25).anchor(50, 50).color(100, 100, 100).pos(90, 32);
        but = bg.addsprite("roleNameBut0.png").size(145, 46).pos(370, 265).anchor(50, 50).setevent(EVENT_TOUCH, nameIt);
        but.addlabel(getStr("ok", null), null, 25).anchor(50, 50).color(100, 100, 100).pos(90, 32);

        randomName();

    }
    function randomName()
    {
        var i = rand(len(preName));
        var j = rand(len(midName));
        inputView.text(preName[i]+midName[j]);
    }
    function nameIt()
    {
        var n = inputView.text();
        if(n == "")
        {
            warnText.visible(1);
            return;
        }
        scene.nameSoldier(soldier, inputView.text());
        global.director.popView();
    }

    function closeDialog()
    {
        global.director.popView();
    }
    override function enterScene()
    {
        super.enterScene();
        v_root().addview(inputView);
    }

    override function exitScene()
    {
        inputView.removefromparent();
        //v_root().remove(inputView);
        super.exitScene();
    }
}
