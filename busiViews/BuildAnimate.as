
class BuildAnimate extends MyNode
{
    var cus;
    var build;
    //pics pos time kind anchor
    function BuildAnimate(b)
    {
        build = b;
        var ani = getAni(build.data.get("id"));
        trace("buildAnimate", ani);
        if(build.data["hasPlist"]){
            load_sprite_sheet(ani[5]);
        }

        var aniKind = ani[3];
//        trace("building animate", ani);
        if(aniKind != BUILD_ANI_ANI)
        {
bg = sprite(ani[0][0], ARGB_8888).pos(ani[1][0], ani[1][1]).anchor(ani[4][0], ani[4][1]);
        }
        else
            bg = node();
        init();
        cus = null;

        if(aniKind == BUILD_ANI_OBJ)
        {
            cus = new MyAnimate(ani[2], ani[0], bg);
        }
        else if(aniKind == BUILD_ANI_ROT)
        {
            bg.addaction(repeat(rotateby(ani[2], 360)));
        }
        else if(aniKind == BUILD_ANI_ANI)
        {
            cus = new MyAnimate(ani[2], ani[0], build.bg);
        }
            
    }
    /*
    切换帧动画的位置播放
    切换旋转动画的纹理和旋转方向

    建筑物菜单也可以旋转建筑物

    deprecate 不需要变换动画的位置了 
    function changeDir()
    {
        var ani = getAni(build.data.get("id")+build.dir);
        var aniKind = ani[3];
        if(aniKind == BUILD_ANI_OBJ)
        {
            bg.pos(ani[1][0], ani[1][1]);
        }
        else if(aniKind == BUILD_ANI_ROT)
        {
            bg.texture(ani[0][0]); 
            var deg = 360;
            if(build.dir == 1)
                deg = -360;
            bg.addaction(sequence(stop(), repeat(rotateby(ani[2], deg)))); 
        }

        //global.httpController.addRequest("buildingC/changeDir", dict([["uid", uid], ["bid", bid]]), null, null);


    }
    */

    override function enterScene()
    {
//        trace("animate enter scene");
        super.enterScene();
        if(cus != null)
            cus.enterScene();

    }
    override function exitScene()
    {
        if(cus != null)
            cus.exitScene();
        super.exitScene();
    }
}
