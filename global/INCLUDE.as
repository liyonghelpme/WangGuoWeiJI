//注意这些文件是倒序编译的，所以其排序和依赖关系相反

//构造初始化的建筑物分布时，需要初始化一个河流相关的冲突图
import global.User;

import views.FriendScene;
import views.FriendMenu;
import views.VisitDialog;

import views.RankDialog;
import views.HeroRank;
import views.GroupRank;
import views.NewRank;


import views.LoginDialog;
import views.SettingDialog;
import views.TaskDialog;
import views.TipDialog;
import views.MakeDrugDialog;
import views.ScoreDialog;

import views.SoldierDialog;
import views.AllSoldier;
import views.DeadSoldier;
import views.TransferSoldier;
import views.DrugDialog;

//经营页面
import views.CastlePage;
import views.BuildLand;
import views.SoldierMax;

import views.FallGoods;
import views.FallObj;

import views.DialogController;

//菜单
import views.MenuLayer;



//商店
import views.Store;
import views.Choice;
import views.Goods;

import views.RoleName;


//人物对话框
import views.SoldierStore;
import views.BusiSoldier;
import views.TrainBanner;
import views.ProfessionIntroDialog;

//成功提示
import views.SucBanner;
import views.ResourceBanner;


import views.SoldierMenu;
import views.DetailDialog;
import views.ChildMenuLayer;
import views.MailDialog;
import views.GiftView;

import views.BreakDialog;




//大地图
import views.CastleScene;
//建筑物
//采用组合的方式 将farm相关的行为 实现在farm中
import views.Building;
import views.BuildMenu;
import views.BuildWorkMenu;

import views.SellDialog;
import views.AccDialog;
import views.FriendDialog;

import views.FlowScene;
import views.FlowMenu;

import views.MyWarningDialog;



import views.GloryDialog;

import views.Farm;
import views.PlantChoose;
import views.House;
import views.FuncBuild;

//经营页面场景飞行的银币
import views.FlyObject;

import views.MapScene;
import views.MapLayer;
import views.FlyLayer;
import views.LevelSelectLayer;

import views.BattleScene;

//闯关地图
import views.Map;
import views.Soldier;
import views.CloseSoldier;
import views.CloseAttackEffect;

import views.Arrow;
import views.Magic;
import views.MoveObject;
import views.MapPause;

import views.MapDefense;

import views.Loading;
import views.LevupDialog;


//菜单使用的按钮对象
import views.Button;
import global.MessageCenter;


import global.SensorController;
import global.Director;
import global.Controller;
import views.QuitBanner;
import global.Timer;
import views.Dark;
import views.StandardTouchHandler;
import global.MyAnimate;
import global.MyNode;
import global.TouchManager;
import util.Util;

import global.Global;
//import data.String;
import data.constant;
import data.Static;


import data.String;

global.msgCenter = new MessageCenter();
global.director = new Director();
global.touchManager = new TouchManager();
global.timer = new Timer(1000);
global.controller = new Controller();
global.myAction = new MyAction();

//global.staticScene = new CastleScene();
global.user = new User();
global.sensorController = new SensorController();



