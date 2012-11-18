class GlobalController
{
    var timer;
    var touchManager;
    var director;
    var controller;
    var user;
    var myAction;
    var staticScene = null;
    var map = null;
    var msgCenter;
    var sensorController;
    var httpController;
    var friendController;
    var taskModel;
    var mailController;
    var fightModel;
    var bannerController;
    var paramController;
    var pictureManager;
    var staticClass;
    function GlobalController()
    {
        staticClass = getclass("com.liyong.testTime.TestTime");
        //trace(staticClass.getfunc("floor"), staticClass.getfunc("ceil"), staticClass.get("ceil")(1.5), staticClass.getfunc("getTime"), staticClass.getfunc("getTime")(10));
    }
}
var global = new GlobalController();
