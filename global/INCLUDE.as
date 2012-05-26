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
import views.ChildMenuLayer;
import views.Button;

//商店
import views.Store;
import views.Choice;
import views.Goods;

//人物对话框
//import views.SoldierStore;
//import views.BusiSoldier;

//大地图
import views.MapScene;
import views.MapLayer;
import views.FlyLayer;
import views.LevelSelectLayer;


//建筑物
//采用组合的方式 将farm相关的行为 实现在farm中
import views.Building;
import views.BuildMenu;
import views.BuildWorkMenu;

import views.Farm;
import views.PlantChoose;

import views.FlyObject;
import views.House;

/*
//闯关地图
import views.Map;
import views.MoveObject;
*/


import global.Timer;
import global.Director;
import views.Dark;


import views.StandardTouchHandler;

import global.MyAnimate;
import global.MyNode;
import global.Controller;
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



