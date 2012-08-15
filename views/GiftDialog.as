//赠送邻居礼物
class GiftDialog extends MyNode
{
    var cl;
    var flowNode;
    const OFFY = 72;
    const ROW_NUM = 5;
    const HEIGHT = OFFY*ROW_NUM;
    const ITEM_NUM = 1;

    var data;

    var neiborUid;

    const KIND_ITEM = 0;

    const EQUIP_ITEM = 2;
    const DRUG_ITEM = 3;
    const HERB_ITEM = 4;
    const TREASURE_ITEM = 5;
    const MAGIC_ITEM = 6;

    var map = dict([
        [EQUIP_ITEM, EQUIP],
        [DRUG_ITEM, DRUG],
        [HERB_ITEM, HERB],
        [TREASURE_ITEM, TREASURE_STONE],
        [MAGIC_ITEM, MAGIC_STONE],
        ]
    );

    function initData()
    {
        var key;
        var i;
        data = [
        [KIND_ITEM, EQUIP_ITEM, 0],
        [KIND_ITEM, DRUG_ITEM, 0],
        [KIND_ITEM, HERB_ITEM, 0],
        [KIND_ITEM, TREASURE_ITEM, 0],
        [KIND_ITEM, MAGIC_ITEM, 0],
        ];

    }
    //s 操作士兵对象 k 药品或者 武器 复活药水
    function GiftDialog(u)
    {
        neiborUid = u;
        bg = sprite("dialogFriend.png");
        init();
        initData();
        bg.addsprite("sendGiftTitle.png").anchor(50, 50).pos(169, 41);

        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);

        cl = bg.addnode().pos(46, 90).size(703, 357).clipping(1);
        flowNode = cl.addnode();

        updateTab();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
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
    function updateTab()
    {
//        trace("init Drug Dialog View");
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i);
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
                if(data[i][1] == EQUIP_ITEM)
                {
                    num = global.user.getAllEquipNum();
                }
                else if(data[i][1] == DRUG_ITEM)
                {
                    num = global.user.getAllDrugNum();
                }
                else if(data[i][1] == HERB_ITEM)
                {
                    num = global.user.getAllHerbNum();
                }
                else if(data[i][1] == TREASURE_ITEM)
                {
                    num = global.user.getAllGoodsNum(TREASURE_STONE);
                }
                else if(data[i][1] == MAGIC_ITEM)
                {
                    num = global.user.getAllGoodsNum(MAGIC_STONE);
                }

                obj = panel.addsprite(replaceStr(KindsPre[map.get(data[i][1])], ["[ID]", str(0)])).pos(36, 35).anchor(50, 50);

                co = [14, 64, 26];
                if(num == 0)//没有物品则关闭状态
                {
                    data[i][2] = 0;
                    co = [99, 42, 47];
                }
                panel.addlabel(str(num), null, 20).pos(69, 65).anchor(0, 100).color(co[0], co[1], co[2]);
                if(num > 0 )
                {
                    panel.addlabel(getStr("moreThings", null), null, 18, FONT_NORMAL, 390, 55, ALIGN_LEFT).pos(135, 10).color(59, 56, 56);

                    if(data[i][2] == 0)
                    {
                        but1 = panel.addsprite("roleNameBut0.png").pos(650, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onView, i);
                        but1.addlabel(getStr("viewAll", null), null , 18).pos(34, 18).anchor(50, 50);
                    }
                    else
                    {
                        but1 = panel.addsprite("roleNameBut0.png").pos(650, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onClose, i);
                        but1.addlabel(getStr("closeAll", null), null , 18).pos(34, 18).anchor(50, 50);
                    }
                }
                else
                    panel.addlabel(getStr("noThing", null), null, 18, FONT_NORMAL, 390, 55, ALIGN_LEFT).pos(135, 10).color(59, 56, 56);

            }
            //Detail objects 
            //EQUIP_ITEM eid name level desc 赠送 
            else
            {
                if(data[i][0] == EQUIP_ITEM)
                {
                    ed = global.user.getEquipData(data[i][1]);
                    id = ed.get("kind");
                    objData = getData(EQUIP, id);

                    obj = panel.addsprite(replaceStr(KindsPre[map.get(data[i][0])], ["[ID]", str(id)])).pos(36, 35).anchor(50, 50);
                    //trace("equipName", map.get(data[i][0]), data[i], ed);
                    if(ed.get("owner") != -1)
                    {
                        var solData = global.user.getSoldierData(ed.get("owner"));
                        var solName = solData.get("name");
                        panel.addlabel(solName, null, 15).pos(69, 35).anchor(0, 100).color(0, 100, 0);
                    }
                    
                    var eqLevel = ed.get("level");
                    panel.addlabel(getStr("eqLevel", ["[LEV]", str(eqLevel)]), null, 15).pos(69, 65).anchor(0, 100).color(0, 100, 0);

                    but0 = panel.addsprite("roleNameBut0.png").pos(650, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onSend, i);
                    but0.addlabel(getStr("sendIt", null), null, 18).pos(34, 18).anchor(50, 50);
                }
                //只显示数量非零的物品
                else
                {
                    id = data[i][1];
                    obj = panel.addsprite(replaceStr(KindsPre[map.get(data[i][0])], ["[ID]", str(data[i][1])])).pos(36, 35).anchor(50, 50);
                    objData = getData(map.get(data[i][0]), id);

                    num = global.user.getGoodsNum(map.get(data[i][0]), id);

                    co = [14, 64, 26];
                    if(num == 0)
                        co = [99, 42, 47];
                    panel.addlabel(str(num), null, 20).pos(69, 65).anchor(0, 100).color(co[0], co[1], co[2]);
                    if(num > 0)
                    {
                        but0 = panel.addsprite("roleNameBut0.png").pos(650, 34).size(butWidth, butHeight).anchor(50, 50).setevent(EVENT_TOUCH, onSend, i);
                        but0.addlabel(getStr("sendIt", null), null, 18).pos(34, 18).anchor(50, 50);
                    }
                }
                
                panel.addlabel(objData.get("name")+" "+objData.get("des"), null, 18, FONT_NORMAL, 390, 55, ALIGN_LEFT).pos(135, 10).color(59, 56, 56);
            }

            var sca = getSca(obj, [64, 60]);
            obj.scale(sca, sca);
        }
    }
    function onSend(n, e, p, x, y, points)
    {
        var k = data[p][0];
        var giftId = global.user.getNewGiftId();
        var num = 0;
        if(k == EQUIP_ITEM)
        {
            global.httpController.addRequest("goodsC/sendEquip", dict([["uid", global.user.uid], ["fid", neiborUid], ["eid", data[p][1]], ["ti", giftId]]), null, null);
            global.user.sellEquip(data[p][1]);//只是删除用户装备数据
        }
        else 
        {

            if(k == DRUG_ITEM)
            {
                global.httpController.addRequest("goodsC/sendDrug", dict([["uid", global.user.uid], ["fid", neiborUid], ["did", data[p][1]], ["ti", giftId]]), null, null);
            }
            else if(k == HERB_ITEM)
            {
                global.httpController.addRequest("goodsC/sendHerb", dict([["uid", global.user.uid], ["fid", neiborUid], ["tid", data[p][1]], ["ti", giftId]]), null, null);
            }
            else if(k == TREASURE_ITEM)
            {
                global.httpController.addRequest("goodsC/sendTreasureStone", dict([["uid", global.user.uid], ["fid", neiborUid], ["tid", data[p][1]], ["ti", giftId]]), null, null);
            }
            else if(k == MAGIC_ITEM)
            {
                global.httpController.addRequest("goodsC/sendMagicStone", dict([["uid", global.user.uid], ["fid", neiborUid], ["tid", data[p][1]], ["ti", giftId]]), null, null);
            }

            global.user.changeGoodsNum(map.get(k), data[p][1], -1);
            num = global.user.getGoodsNum(map.get(k), data[p][1]);
        }

        if(num == 0)
            data.pop(p);
        updateTab();
    }
    //查看所有装备
    function onView(n, e, p, x, y, points)
    {
        var i;
        if(data[p][0] == KIND_ITEM)
        {
            data[p][2] = 1;
            if(data[p][1] == EQUIP_ITEM)
            {
                var allEquips = global.user.getAllEquip(); 

                for(i = 0; i < len(allEquips); i++)//在
                {
                    data.insert(p+1, [EQUIP_ITEM, allEquips[i]]);
                }
            }
            else if(data[p][1] == DRUG_ITEM)
            {
                var allDrugs = global.user.getAllDrug();
                for(i = 0; i < len(allDrugs); i++)//在
                {
                    data.insert(p+1, [DRUG_ITEM, allDrugs[i]]);
                }
            }
            else if(data[p][1] == HERB_ITEM)
            {
                var allHerbs = global.user.getAllHerb();
                for(i = 0; i < len(allHerbs); i++)//在
                {
                    data.insert(p+1, [HERB_ITEM, allHerbs[i]]);
                }
            }
            else if(data[p][1] == TREASURE_ITEM)
            {
                var allGoods = global.user.getAllGoods(TREASURE_STONE);
                for(i = 0; i < len(allGoods); i++)//在
                {
                    data.insert(p+1, [TREASURE_ITEM, allGoods[i]]);
                }
            }
            else if(data[p][1] == MAGIC_ITEM)
            {
                allGoods = global.user.getAllGoods(MAGIC_STONE);
                for(i = 0; i < len(allGoods); i++)//在
                {
                    data.insert(p+1, [MAGIC_ITEM, allGoods[i]]);
                }
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
    /*
    function receiveMsg(para)
    {
        var msgId = para[0];
        if(msgId == UPDATE_EQUIP)
        {
            updateTab(); 
        }
        else if(msgId == UPDATE_TREASURE)//变更宝石数量
        {
            
        }
    }
    */
    override function enterScene()
    {
        super.enterScene();
        //if(kind == EQUIP)
        //    global.msgCenter.registerCallback(UPDATE_EQUIP, this);
    }
    override function exitScene()
    {
        //if(kind == EQUIP)
        //    global.msgCenter.removeCallback(UPDATE_EQUIP, this);
        super.exitScene();
    }
}
