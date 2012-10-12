import test.INCLUDE;


//初始化经营页面
//获取用户数据---->发送消息给经营页面----》初始化经营页面---》
//newState

//如果数据---》新手---》  不发送消息给经营页面数据-- -》 替换经营页面场景----》则压入新手欢迎页面
//新手结束-----》重新压入经营页面----》重新初始化经营页面数据 initData--->

//global.director.pushScene(new SelectHero());

//global.director.pushScene(new WelcomeDialog());
//global.director.pushScene(new SelectHero());
//global.director.pushScene(new NewBattle());


//显示场景
//global.director.replaceScene(new CastleScene());
//global.director.pushView(new Loading(), 1, 0);//DarkNod

//初始化场景数据 数据初始化结束之后 取出loading页面
global.user.initData();

//var b = new Building(null, getData(BUILD, 208), null);
//global.director.pushView(new LoveDialog(b), 1, 0);

//global.director.pushView(new UpdateDialog(BUILD, 0), 1, 0);

//global.director.pushScene(new BattleEnd());


//global.director.pushView(new LevelChoose(null, 0), 1, 0);
//global.director.pushScene(new MapScene());

//global.director.pushView(new LoginDialog(dict([["loginDays", 5]])), 1, 0);

//global.director.pushView(new LiveHeartDialog(), 1, 0);
//global.director.pushView(new LoveDialog(null), 1, 0);
//global.director.pushView(new LoveUpgradeDialog(null), 1, 0);
//global.director.pushView(new UpdateDialog(EQUIP, 0), 1, 0);



//global.director.pushView(new VisitDialog(null), 1, 0);
class TestNeiborScene
{
    function TestNeiborScene()
    {
        global.msgCenter.registerCallback(INIT_NEIBOR_OVER, this);
    }
    function receiveMsg(para)
    {
        var msgId = para[0];
        if(msgId == INIT_NEIBOR_OVER)
        {
            var nei = global.friendController.neibors[0];
            var fri = new FriendScene(nei["id"], 0, VISIT_NEIBOR, nei["crystal"], nei);
            global.director.pushScene(fri);
        }
    }
}


