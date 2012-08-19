import Global.INCLUDE;


//显示场景
global.director.replaceScene(new CastleScene());
global.director.pushView(new Loading(), 1, 0);//DarkNod

//初始化场景数据 数据初始化结束之后 取出loading页面
global.user.initData();


