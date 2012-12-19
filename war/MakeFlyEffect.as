class MakeFlyEffect extends MyNode
{
    function MakeFlyEffect(ft, startPos, endPos, dir, particleId)
    {
        bg = node();
        init();

        var pData = getData(PARTICLES, particleId);
        var metor2 = dict([
                      ["duration", ft], //["gravity_x",200], 
                      ["speed", getParam("arrowSpeed")], ["speedVar", getParam("arrowSpeedVar")], ["angle",90], ["angle_var",360], 
                      ["particle_life",1000], ["particle_life_var",200], 
                      //["start_color_red", pData["start_color_red"]], ["start_color_green", pData["start_color_green"]], ["start_color_blue", pData["start_color_blue"]], 
                      ["start_color_red", 255], ["start_color_green", 255], ["start_color_blue", 255], 
                      ["start_color_alpha",255], 

                      ["finish_color_red", 255], ["finish_color_green", 255], ["finish_color_blue", 50], 
                      ["finish_color_alpha", 255], 

                      //["start_color_var_blue",51], ["start_color_var_alpha",26], ["finish_color_alpha ",255],
                      ["start_particle_size", pData["startSize"]], 
                      ["start_particle_size_var", pData["startSizeVar"]], 
                      ["finish_particle_size", 0], 
                      ["blend_additive", pData["blend_additive"]],
                      //["finish_color_alpha", 0],
                      ["emission_rate", 20],
                        ["max_particles", 100],
                      ]);

        var p42 = bg.addparticle(metor2).texture("s"+str(particleId)+"e"+str(dir)+".png").pos(startPos);//.anchor(50, 50);
        p42.addaction(moveto(ft, endPos[0], endPos[1]));
        p42.start();
    }
}
