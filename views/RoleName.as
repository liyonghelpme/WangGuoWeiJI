class RoleName extends MyNode
{
    //var scene;
    var soldier;
    var inputView;
    //var preName = ["李", "王", "赵", "张", "谢", "司马", "诸葛", "南宫", "东方", "西门", "相里"];
    //var midName = ["白", "天", "彩虹", "腾", "逊", "无极"];
    var warnText;
    var male;
    function RoleName(s, sol)
    {
        //scene = s;
        soldier = sol;
        male = soldier.data.get("maleOrFemale");

        bg = sprite("roleName.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
bg.addlabel(getStr("nameSol", null), "fonts/heiti.ttf", 25).pos(243, 29).anchor(50, 50).color(0, 0, 0);

        var solPng = bg.addsprite("soldier"+str(sol.id)+".png").pos(109, 137).anchor(50, 50);
        var bsize = solPng.prepare().size(); 
        var sca = min(90*100/bsize[0], 90*100/bsize[1]);
        solPng.scale(sca);

        //526 34
        init();

        var bSize = bg.prepare().size();
        //bg.addsprite("roleNameClose.png").pos(526, 34).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        //bg.addsprite("roleNameDia.png").pos(141, 115);
        var oriX = global.director.disSize[0]/2-bSize[0]/2+165;
        var oriY = global.director.disSize[1]/2-bSize[1]/2+100;
//        trace("inputView", oriX, oriY, 220, 29);


        inputView = v_create(V_INPUT_VIEW, 327, 214, 220, 50);
        warnText = bg.addlabel(getStr("nameNotNull", null), "fonts/heiti.ttf", 20).anchor(0, 0).pos(165, 157).color(100, 0, 0).visible(0);

        var but = bg.addsprite("roleNameBut0.png").size(145, 46).pos(152, 265).anchor(50, 50).setevent(EVENT_TOUCH, randomName);
but.addlabel(getStr("rand", null), "fonts/heiti.ttf", 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);
        but = bg.addsprite("roleNameBut0.png").size(145, 46).pos(350, 265).anchor(50, 50).setevent(EVENT_TOUCH, nameIt);
but.addlabel(getStr("ok", null), "fonts/heiti.ttf", 25).anchor(50, 50).color(100, 100, 100).pos(72, 23);
        
        var solVal = global.user.soldiers.values();
        for(var j = 0; j < len(solVal); j++)
        {
            var solN = solVal[j]["name"];
            for(var i = 0; i < len(soldierName);)
            {
                var tempName = getStr(soldierName[i][0], null);
                if(tempName == solN)
                {
                    soldierName.pop(i);
                }
                else
                    i++;
            }
        }
        randomName();
    }
    function randomName()
    {
        if(len(soldierName) <= 0)
            return;
        var i = rand(len(soldierName));
        var times = 0;
        while(soldierName[i][1] != male && times < 10)
        {
            i = rand(len(soldierName));
            times += 1;
        }
        inputView.text(getStr(soldierName[i][0], null));
    }
    function nameIt()
    {
        var n = inputView.text();
        if(n == "")
        {
            warnText.text(getStr("nameNotNull", null));
            warnText.visible(1);
            return;
        }
        if(LANGUAGE == 0)
        {
            if(len(n) > 12)//3*4
            {
                warnText.text(getStr("nameTooLong", null));
                warnText.visible(1);
                return;
            }
        }
        else
        {
            if(len(n) > 15)
            {
                warnText.text(getStr("nameTooLong", null));
                warnText.visible(1);
            }
        }
        var allSoldier = global.user.soldiers;
        var val = allSoldier.values();
        for(var i = 0; i < len(val); i++)
        {
            if(val[i]["name"] == n)
            {
                warnText.text(getStr("nameSame", null));
                warnText.visible(1);
                return;
            }
        }

        //scene.nameSoldier(soldier, inputView.text());
        soldier.setName(inputView.text());
        soldier.finishName();//结束士兵的命名状态
        global.msgCenter.sendMsg(FINISH_NAME, soldier);
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
