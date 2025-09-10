#######################################################################################################################
# Description: Map showing the seismic networks used
#
# KM
# ACT
# 2025
#######################################################################################################################
# ------------------------------------------------------------------------------------------------------------------- #
# Output name
out=FIG_1_map.eps
gmt set FORMAT_GEO_MAP D
gmt set FONT_ANNOT_PRIMARY Helvetica
gmt set FONT_ANNOT_PRIMARY 10
gmt set FONT_LABEL Helvetica
gmt set LABEL_FONT_SIZE 9
gmt set MAP_FRAME_TYPE plain
gmt set MAP_FRAME_PEN 0.7p,black


R=-R169/171/-44.2/-42.5r
topodir="/path2grdfile"

# Define the limits of the region
north=-43.
south=-44
east=171.15
west=169.4
proj='-JM6i'

echo Creating basemap with or withouth grid...
gmt psbasemap -R$west/$east/$south/$north $proj -B0.2WSen -P -K > $out

gmt makecpt -Cgray -Z -T0/5000/200 -I > topo.cpt

echo Using this clipped grid ....
gmt grdimage -R -J $topodir/clipped_topo.grd -CFrance3.cpt -I$topodir/SAMBA_relief.grd  -O -K >> $out

echo Plotting faults...
gmt psxy -R -J $topodir/activefaults.xy -W1.4p,gray25 -O -K  >> $out

echo Plotting lakes...
gmt psxy -R -J $topodir/nz.gmt -W0.05,black -Gwhite -O -K >> $out
# Overlay coastlines
gmt pscoast -A0/0/1 -W1/0.05 -Df -Swhite -J -R -K -O -N1/0.25p -L169.6/-43.44/-42./20+l+u >> $out
# Plot glaciers
gmt psxy -R -J $topodir/glaciers_outline_2016.gmt -W0.1p,dodgerblue -Gsnow -t15 -O -K >> $out

# Topography colorscale
gmt psscale -Dx4.3/11.5+o0/0i+w1.3i/0.08i+h+e -R -J -CFrance3.cpt -Bx1000f500 -Bx+l"Topography (m)" -O -K --FONT_ANNOT_PRIMARY=9p >> $out

echo Plotting seismic stations...
awk '{print $3, $2}' ../sta_SAMBA.txt |
    gmt psxy -R -J -Si.33 -W.8p,gray25 -Gred -O -K  >> $out
awk '{print $3, $2}' ../sta_SAMBA_new.txt |
    gmt psxy -R -J -Si.33 -W.8p,gray25 -Gred -O -K  >> $out
awk '{print $3, $2}' ../sta_GEONET.txt |
    gmt psxy -R -J -Si.25 -W.8p,gray25 -Gorange -O -K  >> $out
awk '{print $1, $2}' ../rainfall_stations.txt |
    gmt psxy -R -J -Sd.2 -W0.8p -Ggray -O -K  >> $out


gmt psxy -R -J -Wthin,black -O -K  >> $out << END
170.09770 -43.73633 MC EWS
170.07 -43.745
END

gmt psxy -R -J -Sd.2 -W0.8p -Ggray -O -K >> $out << END
170.07 -43.745
END

awk '{print $1, $2}' ../flow_stations.txt |
    gmt psxy -R -J -Sc.2 -W1p -Ggray -O -K   >> $out

# Plot limits of SAMBA network
gmt psxy ../polygon.txt -R -J -W1.9,gray30,. -O -K  >> $out

echo Plotting Lake names...
gmt pstext -R -J -O -K  -F+f6p,Helvetica,dodgerblue+jBL+a0 -Gwhite >> $out << END
170.5 -43.9 Lake
170.475 -43.922 Tekapo
170.12 -43.95 Lake Pukaki
170.08 -44.1 Pukaki
END

echo Plotting Alpine Fault...
gmt pstext -R -J -O -K  -F+f10p,Helvetica,gray10+jBL+a32  >> $out << END
169.41 -43.8 Alpine Fault
END
gmt pstext -R -J -O -K  -F+f10p,Helvetica,gray10+jBL+a0 -Gwhite >> $out << END
# 171.45 -42.7 Hope Fault
171.65 -42.7 HF
END

#Mount Cook
gmt psxy -R -J -St.3 -W1.1p,black -Ggray -O -K  >> $out << END
170.1410417 -43.5957472
#170.262024 -43.603768 #Mt Johnson
END

echo Plotting GeoNet seimic site names ...
gmt pstext -R -J -O -K -F+f6p,Helvetica,gray10+jB -Gwhite >> $out << END
170.71 -43.064 WVZ
169.79 -43.52 FOZ
171.03 -43.704 RPZ
END

##############################################################################
#Toponyms
##############################################################################
#echo Plotting Toponym labels...
gmt pstext -R -J -O -K -F+f7p,Helvetica,gray9+jB -Gwhite >> $out << END
# gmt pstext -R -J -O -K -F+f12p,Times-Italic+jLM -Gwhite >> $out << END
170.46 -43.14 Harihari

170.0 -43.41 F.J. Glacier
169.9 -43.45 Fox
169.9 -43.47 Glacier

170.28 -43.25 Whataroa
170.091 -43.77 MCV
END

####################################################
echo Plotting Toponyms as squares...
gmt psxy -R -J -Ss.15 -W1p,gray36 -Gblack -O -K  >> $out << END
170.56 -43.15
170.96 -42.71
170.017778 -43.464444
170.181944  -43.389167
170.814167 -42.895833 #ross
170.36 -43.262   # whataroa
169.042222 -43.881111 #haast
170.0963 -43.7343 # mount cook village
END


echo Create legend...
gmt set FONT_ANNOT_PRIMARY 9
gmt pslegend <<END -R -J -Dx4.9i/3.i+w0i/0.0i/TC -C0.1i/0.1i -F+gwhite+pthin -P -O -K >> $out
G -0.05i
G .04i
S .05i i .12i red 0.8p,gray25 .2i SAMBA
G .07i
S .05i i .12i orange 0.8p,gray25 .2i GeoNet
G .07i
S .05i c .06i gray 0.8p,black .2i Water flow
G .07i
S .05i d .065i gray 0.8p,black .2i Rainfall
G .07i
S .05i R .1i snow 1.3p,dodgerblue .2i Glaciers
G .07i
S .05i - .15i black thick 0.2i Active fault
G .07i
S .04i s .07i black 0.9p,gray36 0.18i Townships
G 0.05i
END


gmt psxy -R -J -Wthinner,black -O -K  >> $out << END
170 -43.7
170 -43.34
170.55 -43.34
170.55 -43.7
170 -43.7
END




#--------------------------------------------------------   
# Inset map of New Zealand showing study area
#--------------------------------------------------------

# dir="/home/konstantinos/Desktop/gmt"
region2="-R165/180/-48/-34."
projection2='-JM1.5i'
boundaries2="-Bnsew"

gmt pscoast -A0/0/1 $region2 $projection2 $boundaries2 -W0.5 -X0.01 -Y7.23 -Swhite -Df -K -O -P -N1/0.05p,black >> $out
gmt psxy -R -J $topodir/PB_UTIG_Transform.xy  -W0.8,gray25 -O -K  >> $out

gmt pstext -R -J -O -K -F+f9p,Helvetica,gray10+jBL >> $out << END
176.1 -46.5 PA
167   -38 AU
END
gmt pstext -R -J -O -K -F+f8p,Helvetica,gray10+jBL+a16 >> $out << END
175. -44.2 38 mm/yr
END
gmt psxy -SV0.01/0.1/0.1 -Wthinnest -GBlack -O -K -R -J >> $out << END
179.5 -43.8 -105 1.5
END
#study area
gmt psxy -R -J -Wthick,red -O -K  >> $out << END
169.4 -44
171.15, -44
171.15, -43
169.4 -43
169.4 -44
END

gmt psxy -R -J -T -O >> $out
gmt psconvert -Tf -A $out
gmt psconvert -Tg -A+r -E500 $out
evince ${out%.*}.pdf
rm ${out%.*}.eps