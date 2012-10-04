/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png

>= 当前等级的 未购买的物品

show update 

bg.addsprite("haha.png").anchor(0, 0).pos(0, 0).size(800, 480);
bg.addsprite("back.png").anchor(0, 0).pos(150, 91).size(520, 312);
bg.addsprite("loginBack.png").anchor(0, 0).pos(169, 135).size(481, 252);
bg.addsprite("whiteBoard.png").anchor(0, 0).pos(184, 175).size(314, 182);
bg.addsprite("scroll.png").anchor(0, 0).pos(223, 114).size(374, 57);
bg.addsprite("diaBack.png").anchor(0, 0).pos(201, 63).size(418, 57);
bg.addlabel(getStr("objName", null), "fonts/heiti.ttf", 35).anchor(50, 50).pos(418, 92).color(32, 33, 40);
bg.addlabel(getStr("richCon", null), "fonts/heiti.ttf", 93).anchor(0, 0).pos(212, 220).color(28, 15, 4);
bg.addlabel(getStr("rich", null), "fonts/heiti.ttf", 25).anchor(50, 50).pos(415, 145).color(43, 25, 9);
bg.addsprite("heartPlus.png").anchor(0, 0).pos(355, 267).size(37, 34);
bg.addsprite("object.png").anchor(50, 50).pos(574, 266).size(133, 181);
bg.addsprite("最小尺寸.png").anchor(0, 0).pos(538, 216).size(73, 101);
bg.addsprite("绿巨人.png").anchor(50, 50).pos(575, 270).size(116, 163);
var but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("buy", null), null, 18, FONT_NORMAL, [100, 100, 100], , null);
but0.bg.pos(299, 402);
addChild(but0);
but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("ok", null), null, 18, FONT_NORMAL, [100, 100, 100], , null);
but0.bg.pos(519, 402);
addChild(but0);
bg.addlabel(getStr("招 募", null), "fonts/heiti.ttf", 34).anchor(0, 0).pos(267, 388).color(100, 100, 100);
bg.addlabel(getStr("确 定", null), "fonts/heiti.ttf", 33).anchor(0, 0).pos(489, 389).color(100, 100, 100);


*/
class UpdateDialog extends MyNode
{
    var kind;
    var id;
    //人物
    //装备
    //装饰
    
    //每周周一 第一次登录的时候 弹出更新对话框
    function UpdateDialog(k, i)
    {
        kind = k;
        id = i;
        
        //等级
        //转职等级
        //是否拥有
        //备选

        bg = node();
        bg.add(showFullBack());
        init();
        bg.addsprite("back.png").anchor(0, 0).pos(150, 91).size(520, 312);
        bg.addsprite("loginBack.png").anchor(0, 0).pos(169, 135).size(481, 252);
        bg.addsprite("whiteBoard.png").anchor(0, 0).pos(184, 175).size(314, 182);
        bg.addsprite("scroll.png").anchor(0, 0).pos(223, 114).size(374, 57);
        bg.addsprite("smallBack.png").anchor(0, 0).pos(201, 63).size(418, 57);
        var data = getData(kind, id);
        bg.addlabel(data["name"], "fonts/heiti.ttf", 35).anchor(50, 50).pos(418, 92).color(32, 33, 40);

        bg.addsprite("leftBalloon.png").anchor(0, 0).pos(41, 73).size(136, 302);
        bg.addsprite("rightBalloon.png").anchor(0, 0).pos(665, 40).size(120, 342);

        var w;
        if(kind == SOLDIER)
            w = getStr("buySol", ["[NAME]", data.get("name")]);
        if(kind == BUILD)
            w = getStr("buyBuild", ["[NAME]", data.get("name")] );
        if(kind == EQUIP)
            w = getStr("buyEquip", ["[NAME]", data.get("name")] );
        bg.addlabel(w, "fonts/heiti.ttf", 20).anchor(50, 50).pos(415, 145).color(43, 25, 9);

        var pic = bg.addsprite(replaceStr(KindsPre[kind], ["[ID]", str(id)]), ARGB_8888).anchor(50, 50).pos(575, 270);
        var sca = getSca(pic, [116, 163]);
        pic.scale(sca);


        var word = bg.addlabel(getStr("richThing", null), "fonts/heiti.ttf", 21, FONT_NORMAL, 260, 0, ALIGN_LEFT).anchor(0, 0).pos(212, 220).color(28, 15, 4);
        var wSize = word.prepare().size();

        bg.addsprite("heartPlus.png").anchor(0, 0).pos(212, 220+wSize[1]+5).size(37, 34);

        var but0;
        //士兵只有确定按钮
        if(kind == SOLDIER)
        {
            but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("ok", null), null, 33, FONT_NORMAL, [100, 100, 100], onOk, null);
            but0.bg.pos((299+519)/2, 402);
            addChild(but0);
        }
        else
        {
            but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("buyIt", null), null, 33, FONT_NORMAL, [100, 100, 100], onBuy, null);
            but0.bg.pos(299, 402);
            addChild(but0);
            but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("ok", null), null, 33, FONT_NORMAL, [100, 100, 100], onOk, null);
            but0.bg.pos(519, 402);
            addChild(but0);
        }
            
    }
    //如果没有这个建筑物 则 只是虚拟建筑物的数据
    //从当前的buildLayer 中找到合适的兵营
    //招募士兵 问题还是比较多 
    function onBuy()
    {
        global.director.popView();
        var st;
        /*
        if(kind == SOLDIER)
        {
            var allBuildings = global.user.buildingsi.items();
            for(var i = 0; i < len(allBuildings); i++)
            {
                var k = allBuildings[i][0];
                var v = allBuildings[i][1];
                var bData = getData(BUILD, v["id"]);
                if(bData["funcs"] == CAMP && v["state"] == PARAMS["buildFree"])
                {
                    var newB = new Building(null, bData, v); 
                    newB.setBid(k);
                    global.director.pushView(new CallSoldier(newB), 1, 0);
                    return;
                }
            }
            global.director.curScene.addChild(new UpgradeBanner(getStr("noCamp", null), [100, 100, 100]));
            //global.director.pushView(new SoldierStore(global.director.curScene), 1, 0);
        }
        */
        if(kind == BUILD)
        {
            st = new Store(global.director.curScene);
            st.changeTab(st.BUILD_PAGE);
            global.director.pushView(st, 1, 0);
        }
        else if(kind == EQUIP)
        {
            st = new Store(global.director.curScene);
            st.changeTab(st.EQUIP_PAGE);
            global.director.pushView(st, 1, 0);
        }
    }
    function onOk()
    {
        global.director.popView();
    }

    function closeDialog()
    {
        global.director.popView();
    }
}
