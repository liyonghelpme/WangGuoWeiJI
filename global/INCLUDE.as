//注意这些文件是倒序编译的，所以其排序和依赖关系相反

//构造初始化的建筑物分布时，需要初始化一个河流相关的冲突图
import global.User;

//经营页面
import views.CastlePage;
import views.BuildLand;

import views.FallGoods;
import views.FallObj;

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

//成功提示
import views.SucBanner;
import views.ResourceBanner;


import views.SoldierMenu;
import views.ChildMenuLayer;


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
import views.MoveObject;

import views.MapDefense;

import views.Loading;


//菜单使用的按钮对象
import views.Button;


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
import data.String;
import data.Static;

import data.String;

global.director = new Director();
global.touchManager = new TouchManager();
global.timer = new Timer(1000);
global.controller = new Controller();
global.myAction = new MyAction();

//global.staticScene = new CastleScene();
global.user = new User();



