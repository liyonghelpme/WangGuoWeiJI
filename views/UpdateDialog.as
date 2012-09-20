/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png

>= 当前等级的 未购买的物品

show update 
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
        bg = sprite("dialogUpdate.png").anchor(50, 50).pos(global.director.disSize[0]/2, global.director.disSize[1]/2);
        init();
        var data = getData(kind, id);
bg.addlabel(data.get("name"), "fonts/heiti.ttf", 25, FONT_BOLD).pos(267, 26).anchor(50, 50).color(33, 33, 40);
        var w;
        if(kind == SOLDIER)
            w = getStr("buySol", ["[NAME]", data.get("name")]);
        if(kind == BUILD)
            w = getStr("buyBuild", ["[NAME]", data.get("name")] );
        if(kind == EQUIP)
            w = getStr("buyEquip", ["[NAME]", data.get("name")] );

        var pic = bg.addsprite(replaceStr(KindsPre[kind], ["[ID]", str(id)])).anchor(50, 50).pos(435, 255);
        var sca = getSca(pic, [170, 220]);
        pic.scale(sca);

bg.addlabel(w, "fonts/heiti.ttf", 19, FONT_BOLD).anchor(50, 50).pos(267, 80).color(0, 0, 0);
var word = bg.addlabel(getStr("richThing", null), "fonts/heiti.ttf", 19, FONT_NORMAL, 273, 0, ALIGN_LEFT).color(28, 16, 4).pos(74, 124);
        var wSize = word.prepare().size();

        bg.addsprite("heartPlus.png").pos(74, 124+wSize[1]+5).anchor(0, 0).scale(50);
            
        var but0 = bg.addsprite("blueButton.png").anchor(50, 50).pos(123, 342).setevent(EVENT_TOUCH, onBuy);
but0.addlabel(getStr("buyIt", null), "fonts/heiti.ttf", 26).anchor(50, 50).pos(65, 23);

        but0 = bg.addsprite("roleNameBut0.png").anchor(50, 50).pos(280, 342).size(130, 47).setevent(EVENT_TOUCH, onOk);
but0.addlabel(getStr("ok", null), "fonts/heiti.ttf", 26).anchor(50, 50).pos(65, 23);
    }
    function onBuy()
    {
        global.director.popView();
        var st;
        if(kind == SOLDIER)
            global.director.pushView(new SoldierStore(global.director.curScene), 1, 0);
        else if(kind == BUILD)
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
