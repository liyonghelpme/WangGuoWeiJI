class GalaxyFireBall extends MyNode
{
    function GalaxyFireBall(ft, startPos, endPos, dir, particleId)
    {
        bg = node();
        init();

        var pData = getData(PARTICLES, particleId);

        var galaxy2 = dict([
                     ["duration", ft], ["speed",-60], ["radial_accel",-100], ["tangent_accel", 10], ["angle",90], ["angle_var",360], ["particle_life",4000], ["particle_life_var",1000], 
                      ["start_color_red", 105], ["start_color_green",10], ["start_color_blue",10], ["start_color_alpha",255],
                      ["finish_color_alpha ",255],
                     ["start_particle_size",37], ["start_particle_size_var",10], ["finish_particle_size",-1], ["blend_additive",1],
                      ["emission_rate", 20],
                        ["max_particles", 100],
        ]);
        var p42 = bg.addparticle(galaxy2).texture("s"+str(particleId)+"e"+str(dir)+".png");//.pos(startPos);//.anchor(50, 50);
        bg.pos(startPos);
        //快速移动 到目的地停止
        bg.addaction(moveto(ft/pData["flyCoff"], endPos[0], endPos[1]));
        p42.start();
    }
}
