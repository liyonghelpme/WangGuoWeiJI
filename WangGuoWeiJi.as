import Global.INCLUDE;

//global.director.pushView(new Store(null), 0, 0);
//global.director.pushView(new FallGoods(null), 0, 0);
//global.director.pushView(new CastlePage(), 0, 0);
//global.director.pushView(new MenuLayer(null), 0, 0);

//显示场景
global.director.replaceScene(new CastleScene());
global.director.pushView(new Loading(), 1, 0);//DarkNod

//初始化场景数据 数据初始化结束之后 取出loading页面
global.user.initData();



//global.director.pushView(new FriendMenu(), 1, 0);
//global.director.pushView(new RankDialog(), 1, 0);
//global.director.pushView(new LoginDialog(), 1, 0);
//global.director.pushView(new SettingDialog(), 1, 0);
//global.director.pushView(new VisitDialog(), 1, 0);
/*
        var func1 = ;
        var func2 = ["train", "gather"];
        if(inspire == INSPIRE)
            func2 = ;
*/
//global.director.pushView(new SoldierMenu(new BusiSoldier(null, getData(SOLDIER, 0)), ["photo", "drug", "equip"], ["inspire", "train", "gather"] ), 1, 0);

//global.director.pushView(new SoldierStore(null), 0, 0);

//global.director.pushScene(new MapScene());

//global.director.pushView(new CastlePage(), 0, 0);
//global.director.pushView(new MenuLayer(), 0, 0);
//global.director.replaceScene(new CastleScene());
//global.director.pushView(new PlantChoose(null), 0, 0);
//global.director.pushView(new CastlePage(), 0, 0);

//color kind
/*
global.director.pushScene(new BattleScene(0, 
[[0, 0], [1, 10], [0, 20], [1, 30], [0, 40], [1, 50], [0, 60], [1, 70], [0, 80], [1, 90], [0, 100], [1, 110], [0, 120], [1, 130], [0, 140], [1, 150], [0, 160], [1, 170], [0, 180], [1, 190]]

        ));
*/
//global.director.pushView(new BuildWorkMenu(new Building(null, getBuild(0)), ["photo"], ["acc", "sell"]), 0, 0);
