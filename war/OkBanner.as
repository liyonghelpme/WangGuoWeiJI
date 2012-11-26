/*
普通闯关页面: 怪兽倍率
挑战好友其它人: 人物实际属性
*/
class OkBanner extends MyNode
{
    var scene;
    var cl;
    var flowNode;
    var controlSoldier = null;

    const INIT_X = 80;
    const INIT_Y = 402;
    
    const OFFX = 80;
    const ITEM_NUM = 8;

    const WIDTH = 640;
    const HEIGHT = 80;

    const PANEL_WIDTH = 71;
    const PANEL_HEIGHT = 70;

    var data;
    
    var leftArr;
    var rightArr;
    var shadowWord;
    var words;

    var okBut;
    var randomBut;

    /*
    将剩余士兵尽量全部放置到地面上
    每行一个逐个放置直到没有
    */
    var inputView = null;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        
        temp = bg.addsprite("mapMenuCancel.png").anchor(0, 0).pos(624, 35).size(59, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onCancel);
        okBut = bg.addsprite("mapMenuOk.png").anchor(0, 0).pos(546, 35).size(59, 59).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onOk);

        //inputView = v_create(V_INPUT_VIEW, 20, 20, 233, 50);
        //v_root().addview(inputView);
    }
    override function enterScene()
    {
        super.enterScene();
    }
    override function exitScene()
    {
        //inputView.removefromparent();
        super.exitScene();
    }

    function OkBanner(sc)
    {
        scene = sc;
        initView();
    }

    function onOk()
    {
        /*
        var ret = scene.map.checkMySoldier();
        if(ret == 0)
        {
            global.director.curScene.addChild(new UpgradeBanner(getStr("noSol", null), [100, 100, 100], null));
            return;
        }int(inputView.text())
        */
        scene.finishArrange(0);
    }
    function onCancel()
    {
        global.director.popScene();
    }
}
