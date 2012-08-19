//skill FlowBanner
//选择技能
//控制技能释放的位置
//如果英雄死亡 则 停止释放
//清空技能列表
class SkillFlowBanner extends MyNode
{
    const WIDTH = 103;
    const HEIGHT = 90;
    const COL_NUM = 5;
    const ITEM_NUM = 1;
    const PANEL_WIDTH = 90;
    const PANEL_HEIGHT = 90;
    const TOTAL_WIDTH = WIDTH*COL_NUM;

    var scene;
    var soldier = null;
    var skillList = [];
    var cl;
    var flowNode;

    var shadowWord;
    var words;
    function SkillFlowBanner(s)
    {
        scene = s;
        bg = node();
        init();
        cl = bg.addnode().size(476, 82).pos(9, 384).clipping(1);
        flowNode = cl.addnode();

        setSoldier(null);

        shadowWord = bg.addsprite("storeBlack.png").pos(10, 323).visible(0);
        words = null;
        
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }
    var accMove;
    var lastPoints;
    function update(diff)
    {
        if(soldier != null && soldier.state == MAP_SOL_DEAD)
        {
            setSoldier(null);
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
        global.msgCenter.registerCallback(UPDATE_SKILL_STATE, this);
    }
    function receiveMsg(param)
    {
        var msgId = param[0];
        if(msgId == UPDATE_SKILL_STATE)
        {
            if(param[1] == MAP_FINISH_SKILL)
            {
                shadowWord.visible(0);
                words.removefromparent();
                words = null;
                selSkill.texture("mapUnSel.png");
                selSkill = null;
            }
        }

    }

    override function exitScene()
    {
        global.msgCenter.removeCallback(UPDATE_SKILL_STATE, this);
        global.timer.removeTimer(this);
        super.exitScene();
    }
    function touchBegan(n, e, p, x, y, points)
    {
        if(selSkill == null)
        {
            accMove = 0;
            lastPoints = n.node2world(x, y);

            var child = checkInChild(flowNode, lastPoints);
            if(child != null)
            {
                child.texture("mapSel.png");
            }
        }
    }

    function touchMoved(n, e, p, x, y, points)
    {
        if(selSkill == null)
        {
            var oldPos = lastPoints;
            lastPoints = n.node2world(x, y);
            var difx = lastPoints[0]-oldPos[0];
            
            var curPos = flowNode.pos();
            curPos[0] += difx;
            flowNode.pos(curPos);

            accMove += abs(difx);
        }
    }

    var selSkill = null;
    //点击背景地图 选择技能
    function touchEnded(n, e, p, x, y, points)
    {
        if(selSkill == null)
        {
            var newPos = n.node2world(x, y);

            var child = checkInChild(flowNode, newPos);
            if(child != null && accMove >= 10)//没有选择还原按钮
            {
                child.texture("mapUnSel.png");
            }
            if(accMove < 10 && child != null)//选择 则不还原按钮
            {
                selSkill = child;
                var selectNum = child.get();
                //当前没有选择技能 则选择技能
                scene.selectSkill(soldier, skillList[selectNum][0]);
                
                words = shadowWord.addlabel(getStr("selTarget", null), null, 25);
                var wSize = words.prepare().size();
                var sSize = shadowWord.prepare().size();
                sSize[0] = max(wSize[0], sSize[0]);
                shadowWord.size(sSize);
                words.anchor(50, 50).pos(sSize[0]/2, sSize[1]/2);
            }
            
            var curPos = flowNode.pos();
            var cols = (len(data)+ITEM_NUM-1)/ITEM_NUM;
            curPos[0] = min(0, max(-cols*WIDTH+TOTAL_WIDTH, curPos[0]));
            flowNode.pos(curPos);
        }
    }

    function setSoldier(sol)
    {
        if(soldier == sol)
            return;
        soldier = sol;
        if(soldier == null)
            skillList = [];
        else
            skillList = global.user.getSolSkills(soldier.sid).items();//skillId level
        flowNode.removefromparent();
        flowNode = cl.addnode(); 
        for(var i = 0; i < len(skillList); i++)
        {
            var panel = flowNode.addsprite("mapUnSel.png").pos(i*WIDTH, 0);
            var skillPic = panel.addsprite(replaceStr(KindsPre[SKILL], ["[ID]", skillList[i][0]])).anchor(50, 50).pos(PANEL_WIDTH/2, PANEL_HEIGHT/2);
            var sca = getSca(skillPic, [PANEL_WIDTH, PANEL_HEIGHT]);
            skillPic.scale(sca);

            panel.addsprite("skillLevel.png").pos(53, 66).anchor(50, 50);
            panel.addlabel(getStr("skillLevel", ["[LEV]", str(skillList[i][1])]), null, 15).pos(53, 66).anchor(50, 50).color(100, 100, 100);

            panel.put(i);
        }
    }

}
