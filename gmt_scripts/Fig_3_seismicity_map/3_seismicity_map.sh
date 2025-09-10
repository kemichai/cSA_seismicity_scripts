#!/usr/bin/env bash

out=FIG_3_map.eps

gmt set FORMAT_GEO_MAP D
gmt set FONT_ANNOT_PRIMARY Helvetica
gmt set FONT_ANNOT_PRIMARY 10
gmt set FONT_LABEL Helvetica
gmt set LABEL_FONT_SIZE 9
gmt set MAP_FRAME_TYPE plain
gmt set MAP_FRAME_PEN 0.7p,black


R=-R169/171/-44.2/-42.5r
topodir="/path2grdfile"



north=-43.34
south=-43.7
east=170.55
west=170
proj='-JM6i'

echo Creating basemap with or withouth grid...
gmt psbasemap -R$west/$east/$south/$north $proj -B0.1WSen -P -K > $out

echo Make cpts for topography and seismicity ...
gmt makecpt -Cdevon -T0/14/2 > seis.cpt

echo Using this clipped grid ....
gmt grdimage -R -J $topodir/clipped_topo.grd -CFrance3.cpt -I$topodir/SAMBA_relief.grd  -O -K >> $out

echo Plotting faults...
gmt psxy -R -J $topodir/activefaults.xy -W1.4p,gray25 -O -K  >> $out

echo Plotting lakes...
gmt psxy -R -J $topodir/nz.gmt -W0.05,black -Gwhite -O -K >> $out
gmt pscoast -A0/0/1 -W1/0.05 -Df -Swhite -J -R -K -O -N1/0.25p  >> $out
gmt psxy -R -J $topodir/glaciers_outline_2016.gmt -W0.1p,dodgerblue -Gsnow -t35 -O -K >> $out

gmt psxy -R -J $topodir/main_divide_WGS84.gmt  -W2.5p,red,-. -O -K >> $out

echo Plot earthquake epicenters...
awk '{print $1, $2, 3}' ../catalog_A_B_outside.dat | gmt psxy -Sci -i0,1,2s0.018 -W.7,black -R -J -B -O -K -t50 >> $out
awk '{if ($6>1) print $1, $2, $3, ($5+2)**1.5}' ../catalog_inside_GC.dat  | gmt psxy -i0,1,2,3s0.035 -Sc -W0.1,black  -R -J -O -K  -Cseis.cpt >> $out

gmt psxy ../polygon.txt -R -J -W1.9,gray30,. -O -K  >> $out

echo Plotting seismic stations...
awk '{print $3, $2}' ../sta_SAMBA.txt |
    gmt psxy -R -J -Si.4 -W.9p,gray25 -Gred -O -K  >> $out
 awk '{print $3, $2}' ../sta_SAMBA_new.txt |
   gmt psxy -R -J -Si.4 -W.9p,gray25 -Gred -O -K  >> $out
awk '{print $3, $2}' ../sta_GEONET.txt |
    gmt psxy -R -J -Si.35 -W.8p,gray25 -Gorange -O -K  >> $out


gmt pscoast -A0/0/1 -W1/0.05 -Df -Swhite -J -R -K -O -N1/0.25p -L170.3/-43.68/-42./10+l+u >> $out
echo Plotting Lake names...
gmt pstext -R -J -O -K  -F+f6p,Helvetica,navy+jBL+a0 -Gwhite >> $out << END
170.5 -43.9 Lake
170.46 -43.95 Tekapo
170.12 -44.05 Lake
170.08 -44.1 Pukaki
END


echo Plotting Alpine Fault...
gmt pstext -R -J -O -K  -F+f10p,Helvetica,gray10+jBL+a32  >> $out << END
170.076 -43.876 Alpine Fault
END

gmt psxy -R -J -W0.5,black -O -K -Gwhite >> $out << END
170.045  -43.412
170.139 -43.375
170.139 -43.347
170.008 -43.347
170.008  -43.412
170.045  -43.412
END

# Scale for the magnitudes
gmt psxy -i0,1,2,3s0.033 -Sc -R -J -O -K  -W.25 -Cseis.cpt >> $out << END
170.015 -43.393 5.0 8.0 # 2
170.015 -43.399 5.0 5.2  # 1
170.015 -43.4032 5.0 2.8  # 0
170.015 -43.406 5.0 1.0  # -1
END
gmt pstext -R -J -O -K  -F+f9p,Helvetica,gray10+jBL+a0  >> $out << END
170.02 -43.395 M=2
170.02 -43.409 M=-1
END
# Plot color scale
gmt psscale -Dx0.39/13.1+o0/0i+w1.3i/0.08i+h+e -R -J -Cseis.cpt -Bx4f2 -Bx+l"Depth (km)" -O -K --FONT_ANNOT_PRIMARY=9p >> $out


####################################################
echo Plotting Toponyms as squares...
gmt psxy -R -J -Ss.1 -W1p -Gblack -O -K  >> $out << END
170.56 -43.15
170.96 -42.71
170.017778 -43.464444
170.181944  -43.389167
170.814167 -42.895833 #ross
170.36 -43.262   # whataroa
169.042222 -43.881111 #haast
170.0963 -43.7343 # mount cook village
END


gmt set FONT_ANNOT_PRIMARY 9

# parallel 1
echo Plotting cross section lines...
start_lon_par='170.02'
start_lat_par='-43.59'
end_lon_par='170.39'
end_lat_par='-43.38'

gmt psxy << END -R -J -O -W1.5,black,4_2 -K>> $out
$start_lon_par $start_lat_par
$end_lon_par $end_lat_par
END

gmt pstext -R -J -D0/0.23 -O -K -F+f11p,Helvetica,gray10+jB  -Gwhite -W0.1 >> $out << END
$start_lon_par $start_lat_par A1
$end_lon_par $end_lat_par A1'
END

# parallel 2
echo Plotting cross section lines...
start_lon_par='170.07'
start_lat_par='-43.64'
end_lon_par='170.45'
end_lat_par='-43.415'

gmt psxy << END -R -J -O -W1.5,black,4_2 -K>> $out
$start_lon_par $start_lat_par
$end_lon_par $end_lat_par
END

gmt pstext -R -J -D0/0.23 -O -K -F+f11p,Helvetica,gray10+jB  -Gwhite -W0.1 >> $out << END
$start_lon_par $start_lat_par A2
$end_lon_par $end_lat_par A2'
END

# parallel 3
echo Plotting cross section lines...
start_lon_par='170.2'
start_lat_par='-43.65'
end_lon_par='170.45'
end_lat_par='-43.495'

gmt psxy << END -R -J -O -W1.5,black,4_2 -K>> $out
$start_lon_par $start_lat_par
$end_lon_par $end_lat_par
END

gmt pstext -R -J -D0/0.23 -O -K -F+f11p,Helvetica,gray10+jB  -Gwhite -W0.1 >> $out << END
$start_lon_par $start_lat_par A3
$end_lon_par $end_lat_par A3'
END

# perpendicular 1
start_lon_per='170.12'
start_lat_per='-43.4'
end_lon_per='170.4'
end_lat_per='-43.6'

gmt psxy << END -R -J -O -W1.5,black,4_2 -K>> $out
$start_lon_per $start_lat_per
$end_lon_per $end_lat_per
END

gmt pstext -R -J -D0/0.23 -O -K -F+f11p,Helvetica,gray10+jB  -Gwhite -W0.1 >> $out << END
$start_lon_per $start_lat_per B1
$end_lon_per $end_lat_per B1'
END

# perpendicular 2
start_lon_per='170.04'
start_lat_per='-43.447'
end_lon_per='170.32'
end_lat_per='-43.647'

gmt psxy << END -R -J -O -W1.5,black,4_2 -K >> $out
$start_lon_per $start_lat_per
$end_lon_per $end_lat_per
END

gmt pstext -R -J -D0/0.23 -O -K -F+f11p,Helvetica,gray10+jB  -Gwhite -W0.1 >> $out << END
$start_lon_per $start_lat_per B2
$end_lon_per $end_lat_per B2'
END

#Mount Cook
gmt psxy -R -J -St.45 -W1.4p,black -Ggray -O -K  >> $out << END
170.1410417 -43.5957472
#170.262024 -43.603768 #Mt Johnson
END

gmt pstext -R -J -O -K  -F+f11p,Helvetica-Bold,darkorange+jBL+a0 -Gwhite -W1.4,darkorange -TO >> $out << END
170.329 -43.612 MG
END
gmt pstext -R -J -O -K  -F+f11p,Helvetica-Bold,hotpink+jBL+a0 -Gwhite -W1.4,hotpink -TO >> $out << END
170.06 -43.525 FG
END
gmt pstext -R -J -O -K  -F+f11p,Helvetica-Bold,green4+jBL+a0 -Gwhite -W1.4,green4 -TO >> $out << END
170.19 -43.61 TG
END
gmt pstext -R -J -O -K  -F+f11p,Helvetica-Bold,lightskyblue3+jBL+a0 -Gwhite -W1.4,lightskyblue3 -TO >> $out << END
170.27 -43.5 UTG
END
gmt pstext -R -J -O -K  -F+f11p,Helvetica-Bold,darkmagenta+jBL+a0 -Gwhite -W1.4,darkmagenta -TO >> $out << END
170.186 -43.465  FJG
END

gmt psxy -R -J -Wthinner,red -O -K  >> $out << END
168.65 -44.2
168.65 -42.5
171.8 -42.5
171.8  -44.2
168.65 -44.2
END


gmt psxy -R -J -T -O >> $out
gmt psconvert -Tf -A $out
gmt psconvert -Tg -A+r -E500 $out
evince ${out%.*}.pdf
rm ${out%.*}.eps