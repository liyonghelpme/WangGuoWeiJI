//赠送邻居礼物
class GiftDialog extends MyNode
{
    var cl;
    var flowNode;

    const OFFY = 75;
    const ROW_NUM = 5;
    const ITEM_NUM = 1;
    const WIDTH = 710;
    const HEIGHT = 375;
    const PANEL_WIDTH = 703;
    const PANEL_HEIGHT = 72;
    const INIT_X = 46;
    const INIT_Y = 90;

    var data;

    var neiborUid;

    const KIND_ITEM = 0;

    const EQUIP_ITEM = 2;
    const DRUG_ITEM = 3;
    const HERB_ITEM = 4;
    const TREASURE_ITEM = 5;
    const MAGIC_ITEM = 6;
    const NO_GIFT = 7;//没有足够的 物品
    const EMPTY_GIFT = 8;

    var map = dict([
        [EQUIP_ITEM, EQUIP],
        [DRUG_ITEM, DRUG],
        ]
    );

    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
temp = bg.addsprite("back.png", ARGB_8888).anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
temp = bg.addsprite("diaBack.png", ARGB_8888).anchor(0, 0).pos(38, 10).size(705, 64).color(100, 100, 100, 100);
        but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);
temp = bg.addsprite("loginBack.png", ARGB_8888).anchor(0, 0).pos(30, 79).size(739, 386).color(100, 100, 100, 100);

temp = bg.addsprite("giftTitle.png", ARGB_8888).anchor(50, 50).pos(161, 40).size(174, 73).color(100, 100, 100, 100);
    }
    function onGiftTip()
    {
    }
    function initData()
    {
        var key;
        var i;
        var allObjs;
        data = [];

        allObjs = global.user.getAllGoods(map[EQUIP_ITEM]);
        for(i = 0; i < len(allObjs); i++)
        {
            data.append([EQUIP_ITEM, allObjs[i]]);
        }

        allObjs = global.user.getAllGoods(map[DRUG_ITEM]);
        for(i = 0; i < len(allObjs); i++)
        {
            data.append([DRUG_ITEM, allObjs[i]]);
        }



        while(len(data) < 5)
            data.append([EMPTY_GIFT, -1]);

    }
    //s 操作士兵对象 k 药品或者 武器 复活药水
    function GiftDialog(u)
    {
        neiborUid = u;
        initView();

        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        flowNode = cl.addnode();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);

        initData();
        updateTab();
    }

    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = len(data);
        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }
    /*
    药品存储药品的类型ID
    装备存储装备的 eid
    */
    const kind2Str = dict([
        [EQUIP, "equip"],
        [DRUG, "drug"],
    ]);
    function updateTab()
    {
//        trace("init Drug Dialog View");
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        var sca;
        var temp;
        for(var i = rg[0]; i < rg[1]; i++)
        {
var panel = flowNode.addsprite("dialogMakeDrugBanner.png", ARGB_8888).pos(0, OFFY * i);
            panel.put(i);
            if(data[i][0] == EMPTY_GIFT)
                continue;
            var id;

            //药品装备的类型ID 没有装备的eid
            var ed;
            var obj;
            var objData;
            var co;
            var but0;
            var but1;
            var num = 0;

            var butWidth = 69;
            var butHeight = 36;
            //类型显示数量
            if(data[i][0] == KIND_ITEM)
            {
                num = global.user.getAllGoodsNum(map[data[i][1]]);
                var minId = 0;
                if(data[i][1] == EQUIP_ITEM)
                    minId = min(equipData.keys());
                else if(data[i][1] == DRUG_ITEM)
                    minId = min(drugData.keys());
obj = panel.addsprite(replaceStr(KindsPre[map.get(data[i][1])], ["[ID]", str(minId)]), ARGB_8888).anchor(50, 50).pos(45, 35).color(100, 100, 100, 100);
                if(num == 0)
                    data[i][2] = 0;

                if(data[i][2] == 0)
                {
                    if(num > 0)
                    {
panel.addlabel(getStr("openEquip", ["[NUM]", str(num), "[KIND]", getStr(kind2Str[map[data[i][1]]], null)]), getFont(), 20).anchor(0, 50).pos(96, 36).color(0, 0, 0);
temp = panel.addsprite("retractArrow.png", ARGB_8888).anchor(50, 50).pos(674, 33).size(22, 23).color(100, 100, 100, 100);
                    }
                    else
                    {
                        but0 = new NewButton("roleNameBut0.png", [121, 39], getStr("buyGift", null), null, 20, FONT_NORMAL, [100, 100, 100], onBuyGift, i);
                        but0.bg.pos(620, 36);
                        panel.add(but0.bg);
panel.addlabel(getStr("noGift", null), getFont(), 21).anchor(50, 50).pos(308, 37).color(47, 43, 43);
                    }
                }
                else
                {
panel.addlabel(getStr("closeGift", ["[NUM]", str(num), "[KIND]", getStr(kind2Str[map[data[i][1]]], null)]), getFont(), 20).anchor(0, 50).pos(96, 36).color(0, 0, 0);
temp = panel.addsprite("retractArrow.png", ARGB_8888).anchor(50, 50).pos(674, 33).size(22, 23).color(100, 100, 100, 100);
                    temp.scale(100, -100);
                }

            }
            //Detail objects 
            //EQUIP_ITEM eid name level desc 赠送 
            else
            {
                if(data[i][0] == EQUIP_ITEM)
                {
                    ed = global.user.getEquipData(data[i][1]);
                    id = ed.get("kind");
                }
                else
                {
                    id = data[i][1];
                }
                trace("objData", data[i][0], id);
                objData = getData(map[data[i][0]], id);
                
                //装备描述没有名字 药水描述有名字？Potion
temp = panel.addlabel(replaceStr(objData.get("des"), ["[NAME]", objData.get("name")]), getFont(), 18, FONT_NORMAL, 467, 0, ALIGN_LEFT).anchor(0, 0).pos(91, 19).color(56, 52, 52);

                if(data[i][0] == EQUIP_ITEM)
                {
obj = panel.addsprite(replaceStr(KindsPre[map.get(data[i][0])], ["[ID]", str(id)]), ARGB_8888).anchor(50, 50).pos(45, 35).color(100, 100, 100, 100);
                    but0 = new NewButton("roleNameBut0.png", [72, 36], getStr("sendIt", null), null, 18, FONT_NORMAL, [100, 100, 100], onSendIt, i);
                    but0.bg.pos(629, 35);
                    panel.add(but0.bg);
                }
                //只显示数量非零的物品
                else
                {
obj = panel.addsprite(replaceStr(KindsPre[map.get(data[i][0])], ["[ID]", str(data[i][1])]), ARGB_8888).pos(36, 35).anchor(50, 50);
                    objData = getData(map.get(data[i][0]), id);

                    num = global.user.getGoodsNum(map.get(data[i][0]), id);

panel.addlabel(str(num), getFont(), 20).anchor(0, 50).pos(63, 52).color(8, 61, 20);
                    if(num > 0)
                    {
                        but0 = new NewButton("roleNameBut0.png", [72, 36], getStr("sendIt", null), null, 18, FONT_NORMAL, [100, 100, 100], onSendIt, i);
                        but0.bg.pos(629, 35);
                        panel.add(but0.bg);
                    }
                }
                
            }

            sca = getSca(obj, [68, 56]);
            obj.scale(sca);
        }
    }
    function onBuyGift(p)
    {
        var store = new Store(global.director.curScene);
        global.director.pushView(store,  1, 0);
    }
    function onSendIt(p)
    {
        var k = data[p][0];
        var giftId = global.user.getNewGiftId();
        var num = 0;
        var kind = map[k];
        var objId = data[p][1];
        if(k == EQUIP_ITEM)
        {
            var ed = global.user.getEquipData(data[p][1]);
            objId = ed["kind"];
            global.httpController.addRequest("goodsC/sendEquip", dict([["uid", global.user.uid], ["fid", neiborUid], ["eid", data[p][1]], ["gid", giftId]]), null, null);
            global.user.sellEquip(data[p][1]);//只是删除用户装备数据
        }
        else 
        {

            if(k == DRUG_ITEM)
            {
                global.httpController.addRequest("goodsC/sendDrug", dict([["uid", global.user.uid], ["fid", neiborUid], ["did", data[p][1]], ["gid", giftId]]), null, null);
            }

            global.user.changeGoodsNum(map.get(k), data[p][1], -1);
            num = global.user.getGoodsNum(map.get(k), data[p][1]);
        }

        var objData = getData(kind, objId);
        global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("sendOver", ["[NAME]", objData["name"]]), [100, 100, 100], null));
        if(num == 0)
            data.pop(p);
        updateTab();

        global.taskModel.doAllTaskByKey("sendGift", 1);
    }
    //查看所有装备
    function onView(n, e, p, x, y, points)
    {
        var i;
        if(data[p][0] == KIND_ITEM)
        {
            data[p][2] = 1;
            var allObjs = global.user.getAllGoods(map[data[p][1]]);
            for(i = 0; i < len(allObjs); i++)
            {
                data.insert(p+1, [data[p][1], allObjs[i]]);
            }
        }
        updateTab();
    }
    function onClose(n, e, p, x, y, points)
    {
        if(data[p][0] == KIND_ITEM)
        {
            var removeKind = data[p][1];
            data[p][2] = 0;
            for(var i = p+1; i < len(data);)
            {
                if(data[i][0] == removeKind)
                {
                    data.pop(i);
                }
                else
                    break;
            }
        }
        updateTab();
    }

    var lastPoints;
    var accMove;
    function touchBegan(n, e, p, x, y, points)
    {
        lastPoints = n.node2world(x, y);
        accMove = 0;
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var dify = lastPoints[1]-oldPos[1];
        var curPos = flowNode.pos();
        curPos[1] += dify;
        flowNode.pos(curPos);

        accMove += abs(dify);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);
        if(accMove < 10)
        {
            var child = checkInChild(flowNode, newPos);
            if(child != null)
            {
                var selectNum = child.get();
                if(data[selectNum][0] == KIND_ITEM)//未开启类型
                {
                    if(data[selectNum][2] == 0)
                        onView(null, null, selectNum, null, null, null);
                    else
                        onClose(null, null, selectNum, null, null, null);
                }
            }
        }
        var curPos = flowNode.pos();
        var rows = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT, curPos[1]));
        flowNode.pos(curPos);
        updateTab();
    }
    function closeDialog()
    {
        global.director.popView();
    }

    //升级装备 降级装备
    function receiveMsg(para)
    {
        var msgId = para[0];
        if(msgId == UPDATE_EQUIP)
        {
            updateTab(); 
        }
        else if(msgId == UPDATE_DRUG)//变更宝石数量
        {
            updateTab(); 
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.msgCenter.registerCallback(UPDATE_DRUG, this);
        global.msgCenter.registerCallback(UPDATE_EQUIP, this);
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(UPDATE_EQUIP, this);
        global.msgCenter.removeCallback(UPDATE_DRUG, this);
        super.exitScene();
    }
}
