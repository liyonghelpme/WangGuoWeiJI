//注意这些文件是倒序编译的，所以其排序和依赖关系相反

import core.SceneMaker;
import scene.OperationScene;
import layer.OperationLayer;
import model.FallObject;
import layer.MenuLayer;
import layer.ChildMenuLayer;
import scene.MapScene;
import layer.MapLayer;
import model.ButtonDelegate;
import views.Store;
import views.Choice;

import global.Timer;
import core.SceneController;
import core.BaseDataController;
import model.ButtonModel;
import global.Director;
import views.Dark;
import global.MyNode;
import global.Controller;
import global.TouchManager;
import util.Util;
import global.Global;


global.director = new Director();
global.touchManager = new TouchManager();
global.timer = new Timer(1000);
global.controller = new Controller();
global.scene = new SceneController();
global.scene.init(new SceneMaker());
global.data = new BaseDataController();

