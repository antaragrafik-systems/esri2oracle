rem dir /a:-d /s /b "LOAD\*.shp" | find /c ":\"> output.txt
set CPL_LOG=shapelogs.txt
@echo off
@setlocal enabledelayedexpansion enableextensions

echo processing > bat_status.txt

for /F "eol=| delims=" %%I in ('dir "LOAD\*.shp" /A-D /B 2^>nul') do for /F "eol=| delims=_" %%J in ("%%~nI") do (
	set "filename=LOAD\%%I"
	call :esri_contains %filename%
	rem echo !cont_type!
	if NOT "!cont_type!" == "non" (
		ogr2ogr -sql "select OBJECTID, GLOBALID, '%%J' as BI_SEG_CODE, '0' as STATUS from %%~nI" -f OCI OCI:username/password@ip:port/NEPSTRN "LOAD\%%I" -nln !cont_type! -append -update -lco GEOMETRY_NAME=GEOMETRY
		if '%ERRORLEVEL%'=='0' (
			echo !filename! processed
		) else (
			echo %ERRORLEVEL% >> errors.txt
		)
	)
	rem echo %%I,%%J,done >> output.txt
)

rem pause
rem echo all,-,done >> output.txt
echo done > bat_status.txt

REM ********* function ***********
:esri_contains
(
	set "passed_name=%filename%"
	set "contain_var=false"
	set "cont_type=non"

	set arg[1]=BUILDING_BLOCKS
	set arg[2]=BUILDING_LINE
	set arg[3]=BUNGALOW_LINE
	set arg[4]=BUNGALOW_LOT
	set arg[5]=COMMERCIAL_AREA
	set arg[6]=COMMERCIAL_LINE
	set arg[7]=GREENARY_AREA
	set arg[8]=GREENARY_LINE
	set arg[9]=HYDROGRAPHIC
	set arg[10]=HYDROGRAPHIC_LINE
	set arg[11]=INDUSTRIAL_AREA
	set arg[12]=INDUSTRIAL_LINE
	set arg[13]=MAJOR_ROAD_CENTERLINE
	set arg[14]=MAJOR_ROAD_OUTLINE
	set arg[15]=MAJOR_ROAD_POLYGON
	set arg[16]=MINOR_ROAD_CENTERLINE
	set arg[17]=MINOR_ROAD_OUTLINE
	set arg[18]=MINOR_ROAD_POLYGON
	set arg[19]=OTHER_LOT
	set arg[20]=OTHER_LOT_LINE
	set arg[21]=PARKING_LOT
	set arg[22]=PARKING_LOT_POLYGON
	set arg[23]=POWER_CENTERLINE
	set arg[24]=POWER_OUTLINE
	set arg[25]=RAIL
	set arg[26]=RAIL_UNDERGROUND
	set arg[27]=REGION
	set arg[28]=RESIDENTIAL_LINE
	set arg[29]=RESIDENTIAL_LOT
	set arg[30]=SHOP_LINE
	set arg[31]=SHOP_LOT
	set arg[32]=UNDERGHWAY_RD_CNTRLINE
	set arg[33]=UNDERGHWAY_RD_OUTLINE
	set arg[34]=UNDERGHWAY_RD_POLYGON
	set arg[35]=UNDERG_MJR_RD_CNTRLINE
	set arg[36]=UNDERG_MJR_RD_OUTLINE
	set arg[37]=UNDERG_MJR_RD_POLYGON
	set arg[38]=UNDERG_MNR_RD_CNTRLINE
	set arg[39]=UNDERG_MNR_RD_OUTLINE
	set arg[40]=UNDERG_MNR_RD_POLYGON
	set arg[41]=UNDERHYDROGRAPHIC
	set arg[42]=UNDERHYDROGRAPHIC_LINE
	set arg[43]=HIGHWAY_ROAD_CENTERLINE
	set arg[44]=HIGHWAY_ROAD_OUTLINE

	rem if not x%filename:pooh=%==x%filename% set "contain_var=pooh"

	for /L %%i in (1,1,44) do (
		set tmp_arg=!arg[%%i]!
		rem set tmp_arg=%filename:!tmp_arg!=%
		call :esri_compare !tmp_arg! !passed_name!
		rem if "!exist!" == "1" echo !tmp_arg!
		if "!exist!" == "1" set "cont_type=!tmp_arg!"
	)
	rem echo ----
	rem if /I %filename% equ !arg[%%i]! SET "contain_var=!arg[%%i]!"	
	exit /b
)

:esri_compare
(	
	set "str1=%tmp_arg%"
	set "str2=%~2"
	set "str3=!str2:%tmp_arg%=!"

	if not "!str3!"=="!str2!" (
		set "exist=1"
	) else (
		set "exist=0"
	)
)