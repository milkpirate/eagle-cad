<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE eagle SYSTEM "eagle.dtd">
<eagle version="6.1">
<drawing>
<settings>
<setting alwaysvectorfont="yes"/>
<setting verticaltext="up"/>
</settings>
<grid distance="0.1" unitdist="inch" unit="inch" style="lines" multiple="1" display="no" altdistance="0.01" altunitdist="inch" altunit="inch"/>
<layers>
<layer number="1" name="Top" color="4" fill="1" visible="no" active="no"/>
<layer number="2" name="Route2" color="1" fill="3" visible="no" active="no"/>
<layer number="3" name="Route3" color="4" fill="3" visible="no" active="no"/>
<layer number="4" name="Route4" color="1" fill="4" visible="no" active="no"/>
<layer number="5" name="Route5" color="4" fill="4" visible="no" active="no"/>
<layer number="6" name="Route6" color="1" fill="8" visible="no" active="no"/>
<layer number="7" name="Route7" color="4" fill="8" visible="no" active="no"/>
<layer number="8" name="Route8" color="1" fill="2" visible="no" active="no"/>
<layer number="9" name="Route9" color="4" fill="2" visible="no" active="no"/>
<layer number="10" name="Route10" color="1" fill="7" visible="no" active="no"/>
<layer number="11" name="Route11" color="4" fill="7" visible="no" active="no"/>
<layer number="12" name="Route12" color="1" fill="5" visible="no" active="no"/>
<layer number="13" name="Route13" color="4" fill="5" visible="no" active="no"/>
<layer number="14" name="Route14" color="1" fill="6" visible="no" active="no"/>
<layer number="15" name="Route15" color="4" fill="6" visible="no" active="no"/>
<layer number="16" name="Bottom" color="1" fill="1" visible="no" active="no"/>
<layer number="17" name="Pads" color="2" fill="1" visible="no" active="no"/>
<layer number="18" name="Vias" color="2" fill="1" visible="no" active="no"/>
<layer number="19" name="Unrouted" color="6" fill="1" visible="no" active="no"/>
<layer number="20" name="Dimension" color="15" fill="1" visible="no" active="no"/>
<layer number="21" name="tPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="22" name="bPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="23" name="tOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="24" name="bOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="25" name="tNames" color="7" fill="1" visible="no" active="no"/>
<layer number="26" name="bNames" color="7" fill="1" visible="no" active="no"/>
<layer number="27" name="tValues" color="7" fill="1" visible="no" active="no"/>
<layer number="28" name="bValues" color="7" fill="1" visible="no" active="no"/>
<layer number="29" name="tStop" color="7" fill="3" visible="no" active="no"/>
<layer number="30" name="bStop" color="7" fill="6" visible="no" active="no"/>
<layer number="31" name="tCream" color="7" fill="4" visible="no" active="no"/>
<layer number="32" name="bCream" color="7" fill="5" visible="no" active="no"/>
<layer number="33" name="tFinish" color="6" fill="3" visible="no" active="no"/>
<layer number="34" name="bFinish" color="6" fill="6" visible="no" active="no"/>
<layer number="35" name="tGlue" color="7" fill="4" visible="no" active="no"/>
<layer number="36" name="bGlue" color="7" fill="5" visible="no" active="no"/>
<layer number="37" name="tTest" color="7" fill="1" visible="no" active="no"/>
<layer number="38" name="bTest" color="7" fill="1" visible="no" active="no"/>
<layer number="39" name="tKeepout" color="4" fill="11" visible="no" active="no"/>
<layer number="40" name="bKeepout" color="1" fill="11" visible="no" active="no"/>
<layer number="41" name="tRestrict" color="4" fill="10" visible="no" active="no"/>
<layer number="42" name="bRestrict" color="1" fill="10" visible="no" active="no"/>
<layer number="43" name="vRestrict" color="2" fill="10" visible="no" active="no"/>
<layer number="44" name="Drills" color="7" fill="1" visible="no" active="no"/>
<layer number="45" name="Holes" color="7" fill="1" visible="no" active="no"/>
<layer number="46" name="Milling" color="3" fill="1" visible="no" active="no"/>
<layer number="47" name="Measures" color="7" fill="1" visible="no" active="no"/>
<layer number="48" name="Document" color="7" fill="1" visible="no" active="no"/>
<layer number="49" name="Reference" color="7" fill="1" visible="no" active="no"/>
<layer number="50" name="dxf" color="7" fill="1" visible="no" active="no"/>
<layer number="51" name="tDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="52" name="bDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="91" name="Nets" color="2" fill="1" visible="yes" active="yes"/>
<layer number="92" name="Busses" color="1" fill="1" visible="yes" active="yes"/>
<layer number="93" name="Pins" color="2" fill="1" visible="no" active="yes"/>
<layer number="94" name="Symbols" color="4" fill="1" visible="yes" active="yes"/>
<layer number="95" name="Names" color="7" fill="1" visible="yes" active="yes"/>
<layer number="96" name="Values" color="7" fill="1" visible="yes" active="yes"/>
<layer number="97" name="Info" color="7" fill="1" visible="yes" active="yes"/>
<layer number="98" name="Guide" color="6" fill="1" visible="yes" active="yes"/>
<layer number="100" name="Parts" color="7" fill="1" visible="yes" active="yes"/>
<layer number="250" name="Descript" color="3" fill="1" visible="no" active="no"/>
<layer number="251" name="SMDround" color="12" fill="11" visible="no" active="no"/>
<layer number="254" name="cooling" color="7" fill="1" visible="no" active="yes"/>
</layers>
<schematic>
<libraries>
<library name="m-pad-2.1">
<description>&lt;h1&gt;&lt;u&gt;&lt;b&gt;M-Pad&lt;/b&gt; Library&lt;br&gt; &lt;/h1&gt;&lt;/u&gt;
&lt;br&gt;
&lt;b&gt; Version :&lt;/b&gt; 2.1 &lt;br&gt;
&lt;br&gt;
&lt;b&gt; License :&lt;/b&gt; GNU General Public License version 2 (see bottom) &lt;br&gt;
&lt;br&gt;
&lt;b&gt;Description:&lt;/b&gt;&lt;br&gt;
M-Pad library contains various parts from different manufactures.&lt;br&gt;
Some parts are used in the m-pad project at sourceforge.  &lt;a href="http://m-pad.sourceforge.net"&gt;http://m-pad.sourceforge.net&lt;/a&gt;&lt;br&gt;
M-Pad is an embedded modular multifunctional multimedia Board with Intel PXA 27x CPU and Intel 2700G Graphic Accellerator.&lt;br&gt;
&lt;br&gt;
&lt;u&gt;&lt;b&gt;Attention:&lt;/b&gt; Be awear that the devices can have bugs. Please verify the correctness of the dimension and the pin connectios.&lt;br&gt;&lt;/u&gt;
&lt;br&gt;
&lt;br&gt;

&lt;b&gt;Changes:&lt;/b&gt; 
&lt;ul&gt;
	&lt;li&gt; Changed the symbol of the ZHX2022 IRDA module
	&lt;li&gt; Added a new landpatter to L_EU and L_US (ELLATV)
	&lt;li&gt; Name and Value font size of the symbols GE28F_*
	&lt;li&gt; CON-CF changed Name and Value font size
	&lt;li&gt; Resized the SMD pads of SOT23-6L
	&lt;li&gt; Added a new landpatter to L_EU and L_US (PCC-S1)
	&lt;li&gt; Added and changed the landpattern for TPS6204x from QFN-10 to QFN10
	&lt;li&gt; Added inductors to L_EU and L_US (CDRH3D28 to CDRH8D28)
	&lt;li&gt; Minor changes on A3-MPAD and MD235
&lt;/ul&gt;

&lt;br&gt;
&lt;b&gt;Bug Fixes:&lt;/b&gt;&lt;br&gt;
&lt;ul&gt;
	&lt;li&gt; ...
&lt;/ul&gt;

&lt;br&gt;
&lt;b&gt;Add new Devices:&lt;/b&gt;
&lt;ul&gt;
	&lt;li&gt; IRF7805
	&lt;li&gt; CON-54722-0607
	&lt;li&gt; MAX1953_MAX1954
	&lt;li&gt; MT48H8M32LF
	&lt;li&gt; Si7868ADP
	&lt;li&gt; TPS5124
	&lt;li&gt; TPS6204x 
	&lt;li&gt; MC14548x
	&lt;li&gt; CON-52991-0508
	&lt;li&gt; MAX9813
	&lt;li&gt; MSM7702
	&lt;li&gt; MSM7717
	&lt;li&gt; GM-862-GPS
	&lt;li&gt; CON-HIROSE-COAXIAL
	&lt;li&gt; K9WAG08U1A 
	&lt;li&gt; K9**G08U*A
	&lt;li&gt; SMT-ANTENNA
	&lt;li&gt; CF-CARD-IDE_MODE
	&lt;li&gt; TS5A3153
	&lt;li&gt; TS5A3159
	&lt;li&gt; LM2717
	&lt;li&gt; MD8831_MD8832
	&lt;li&gt; MD253
	&lt;li&gt; TPS54550
	&lt;li&gt; FDB1*AN06A0 
	&lt;li&gt; TPS6220X
	&lt;li&gt; TPS62510
	&lt;li&gt; TPS6205x
	&lt;li&gt; TPS5410_TPS5420
	&lt;li&gt; STF203-xx
	&lt;li&gt; SCP1000
	&lt;li&gt; SCA3000
&lt;/ul&gt;

&lt;br&gt;
Please send any comments to: &lt;a href="mailto:messi@users.sourceforge.net"&gt;messi@users.sourceforge.net&lt;/a&gt;&lt;br&gt;
&lt;br&gt;
&lt;br&gt;
&lt;b&gt;Included Devices:&lt;/b&gt;
&lt;br&gt;
&lt;table width=100% border=2 &gt;
	&lt;th&gt;
		&lt;TR &gt;
			&lt;TH  bgcolor=grey align=center&gt;  &lt;i&gt;Device&lt;/i&gt;     &lt;/TH&gt;
			&lt;TH  bgcolor=grey align=center&gt;  &lt;i&gt;Package&lt;/i&gt;   &lt;/TH&gt;
			&lt;TH  bgcolor=grey align=center&gt;  &lt;i&gt;Manufacture&lt;/i&gt;   &lt;/TH&gt;
			&lt;TH  bgcolor=grey align=center&gt;  &lt;i&gt;Description&lt;/i&gt;  &lt;/TH&gt;
		&lt;/TR&gt;
	&lt;/th&gt;
		&lt;TBODY&gt;
		&lt;TR &gt;
			&lt;TD&gt;2700G_3_5&lt;/TD&gt;
			&lt;TD&gt;364-VF-BGA&lt;/TD&gt;
			&lt;TD&gt;Intel&lt;/TD&gt;
			&lt;TD&gt;Intel 2700G Multimedia Graphic Acceleration&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;2700G_7&lt;/TD&gt;
			&lt;TD&gt;364-VF-BGA&lt;/TD&gt;
			&lt;TD&gt;Intel&lt;/TD&gt;
			&lt;TD&gt;Intel 2700G7 Multimedia Graphic Acceleration with 16MB SDRAM&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD &gt;2N3906_MMBT3906_PZT3906 &lt;/TD&gt;
			&lt;TD&gt;SOT-23&lt;/TD&gt;
			&lt;TD&gt;Fairchild Semiconductor&lt;/TD&gt;
			&lt;TD&gt;PNP General Purpose Amplifier&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD &gt;2N7000KL/BS170KL &lt;/TD&gt;
			&lt;TD&gt;TO-92&lt;/TD&gt;
			&lt;TD&gt;Vishay Siliconix&lt;/TD&gt;
			&lt;TD&gt;N-Channel 60-V (D-S) MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD &gt;74*HC04 &lt;/TD&gt;
			&lt;TD&gt;SO14,SSOP14,TSSOP14&lt;/TD&gt;
			&lt;TD&gt;Ti, OnSemi, Fairchild&lt;/TD&gt;
			&lt;TD&gt;6 CMOS Hex-Inverters in one package&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;A3L-MPAD&lt;/TD&gt;
			&lt;TD&gt;None&lt;/TD&gt;
            			&lt;TD&gt;None&lt;/TD&gt;
			&lt;TD&gt;A3 Landscape Frame with textfield&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;AAT3125&lt;/TD&gt;
			&lt;TD&gt;QFN44-16&lt;/TD&gt;
                        		&lt;TD&gt;AnalogicTech&lt;/TD&gt;
			&lt;TD&gt;The AAT3125 is a USB On-the-Go (OTG) Charge Pump&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;AD723&lt;/TD&gt;
			&lt;TD&gt;TSSOP-28&lt;/TD&gt;
                        		&lt;TD&gt;Analog Devices&lt;/TD&gt;
			&lt;TD&gt;2.7 V to 5.5 V RGB-to-NTSC/PAL Encoder with Load Detect and Input Termination Switch&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;AD725&lt;/TD&gt;
			&lt;TD&gt;SOIC16W&lt;/TD&gt;
                        		&lt;TD&gt;Analog Devices&lt;/TD&gt;
			&lt;TD&gt;Low Cost RGB to NTSC/PAL Encoder with Luma Trap Port&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;AD7142&lt;/TD&gt;
			&lt;TD&gt;LFCSP-32&lt;/TD&gt;
                        		&lt;TD&gt;Analog Devices&lt;/TD&gt;
			&lt;TD&gt;Programmable Capacitance-to-Digital Converter with Environmental Compensation&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;AD7142_8WAY_SWITCH&lt;/TD&gt;
			&lt;TD&gt;C_8WAY_SWITCH&lt;/TD&gt;
                        		&lt;TD&gt;Analog Devices&lt;/TD&gt;
			&lt;TD&gt;Capacitive 8-way swicth landpattern for the AD7142&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;AD7142_BUTTON&lt;/TD&gt;
			&lt;TD&gt;C_BUTTON&lt;/TD&gt;
                        		&lt;TD&gt;Analog Devices&lt;/TD&gt;
			&lt;TD&gt;Capacitive button landpattern for the AD7142&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;AD7142_SLIDER&lt;/TD&gt;
			&lt;TD&gt;C_SLIDER&lt;/TD&gt;
                        		&lt;TD&gt;Analog Devices&lt;/TD&gt;
			&lt;TD&gt;Capacitive slider landpattern for the AD7142&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;ADV7746&lt;/TD&gt;
			&lt;TD&gt;TSSOP16&lt;/TD&gt;
                        		&lt;TD&gt;Analog Devices&lt;/TD&gt;
			&lt;TD&gt;24-Bit Capacitance-to-Digital Converter with Temperature Sensor&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;AD8614&lt;/TD&gt;
			&lt;TD&gt;SOT23-5&lt;/TD&gt;
                        		&lt;TD&gt;Analog Devices&lt;/TD&gt;
			&lt;TD&gt;Single and Quad +18 V Operational Amplifiers&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;ADV7175A_76A&lt;/TD&gt;
			&lt;TD&gt;MQFP44-2&lt;/TD&gt;
                        		&lt;TD&gt;Analog Devices&lt;/TD&gt;
			&lt;TD&gt;High Quality, 10-Bit, Digital CCIR-601 to PAL/NTSC Video Encoder&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;ADV7302A_ADV7303A&lt;/TD&gt;
			&lt;TD&gt;LQFP64&lt;/TD&gt;
                        		&lt;TD&gt;Analog Devices&lt;/TD&gt;
			&lt;TD&gt;Multiformat SD, Progressive Scan/HDTV Video Encoder with Six 11-Bit DACs&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;ATmega406&lt;/TD&gt;
			&lt;TD&gt;LQFP-48&lt;/TD&gt;
                        		&lt;TD&gt;ATMEL&lt;/TD&gt;
			&lt;TD&gt;The ATmega406 is a 8bit Microcontroller with 50KB In-System  Programmable Flash with special Functions for Smartbatteries&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;AXK3S30035&lt;/TD&gt;
			&lt;TD&gt;AXK3S30035&lt;/TD&gt;
			&lt;TD&gt;Matsushita &lt;/TD&gt;
                        		&lt;TD&gt;30pin 0.6mm NARROW-PITCH CONNECTORS FOR PC BOARDS(Socket)&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;AXK3S50035&lt;/TD&gt;
			&lt;TD&gt;AXK3S50035&lt;/TD&gt;
			&lt;TD&gt;Matsushita &lt;/TD&gt;
                        		&lt;TD&gt;50pin 0.6mm NARROW-PITCH CONNECTORS FOR PC BOARDS(Socket)&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;AXK4S30435&lt;/TD&gt;
			&lt;TD&gt;AXK4S30435&lt;/TD&gt;
			&lt;TD&gt;Matsushita &lt;/TD&gt;
                       		&lt;TD&gt;30pin 0.6mm NARROW-PITCH CONNECTORS FOR PC BOARDS(Header)&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;AXK4S50435&lt;/TD&gt;
			&lt;TD&gt;AXK4S50435&lt;/TD&gt;
			&lt;TD&gt;Matsushita &lt;/TD&gt;
                        		&lt;TD&gt;50pin 0.6mm NARROW-PITCH CONNECTORS FOR PC BOARDS(Header)&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;AXN330038S&lt;/TD&gt;
			&lt;TD&gt;AXN330038S&lt;/TD&gt;
			&lt;TD&gt;Matsushita &lt;/TD&gt;
                        		&lt;TD&gt;30pin 0.8mm NARROW-PITCH CONNECTORS FOR PC BOARDS(Socket)&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;AXN350038S&lt;/TD&gt;
			&lt;TD&gt;AXN350038S&lt;/TD&gt;
			&lt;TD&gt;Matsushita &lt;/TD&gt;
                        		&lt;TD&gt;50pin 0.8mm NARROW-PITCH CONNECTORS FOR PC BOARDS(Socket)&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;AXN430X30&lt;/TD&gt;
			&lt;TD&gt;AXN430X30S&lt;/TD&gt;
			&lt;TD&gt;Matsushita &lt;/TD&gt;
                        		&lt;TD&gt;30pin 0.8mm NARROW-PITCH CONNECTORS FOR PC BOARDS(Header)&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;AXN450X30&lt;/TD&gt;
			&lt;TD&gt;AXN450X30S&lt;/TD&gt;
			&lt;TD&gt;Matsushita &lt;/TD&gt;
                        		&lt;TD&gt;50pin 0.8mm NARROW-PITCH CONNECTORS FOR PC BOARDS(Header)&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;BLUEGIGA_WT11&lt;/TD&gt;
			&lt;TD&gt;WT11&lt;/TD&gt;
			&lt;TD&gt;BlueGiga&lt;/TD&gt;
                        		&lt;TD&gt;Embedded Bluetoothmodule  (2.0+EDR)&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;BLUEGIGA_WT12&lt;/TD&gt;
			&lt;TD&gt;WT12&lt;/TD&gt;
			&lt;TD&gt;BlueGiga&lt;/TD&gt;
                        		&lt;TD&gt;Embedded Bluetoothmodule  (2.0+EDR)&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;BQ241XX&lt;/TD&gt;
			&lt;TD&gt;QFN-20&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;LI-ION and LI-POL charge management IC&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;BQ24702/3&lt;/TD&gt;
			&lt;TD&gt;TSSOP-24,QFN-28&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;Multichemistry Battery Charger&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;BR-C30A&lt;/TD&gt;
			&lt;TD&gt;BR-C30A8&lt;/TD&gt;
			&lt;TD&gt;Blue Radio&lt;/TD&gt;
                        		&lt;TD&gt;BR-C30 Class1, Class2, and Class3 Bluetooth ver1.2 Module&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;BSS84LT1&lt;/TD&gt;
			&lt;TD&gt;SOT-23&lt;/TD&gt;
			&lt;TD&gt;On Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;Power Mosfet P-Channel 130 mA, 50 V RDS(on) = 10 Ohm&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;BSS138&lt;/TD&gt;
			&lt;TD&gt;SOT-23&lt;/TD&gt;
			&lt;TD&gt;Fairchild Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;N-Channel Logic Level Enhancement Mode Field Effect Transistor&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;CM-CHOKE-COIL&lt;/TD&gt;
			&lt;TD&gt;various&lt;/TD&gt;
			&lt;TD&gt;TDK,Murata&lt;/TD&gt;
                        		&lt;TD&gt;Common mode choke coil for DC power line&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;CMSD4448&lt;/TD&gt;
			&lt;TD&gt;SOT323&lt;/TD&gt;
			&lt;TD&gt;Central Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;Switching diode&lt;/TD&gt;
		&lt;/TR&gt;
                           &lt;TR &gt;
			&lt;TD&gt;CDRH2D18/HP&lt;/TD&gt;
			&lt;TD&gt;CDRH2D18/HP&lt;/TD&gt;
			&lt;TD&gt;Sumida&lt;/TD&gt;
                        		&lt;TD&gt;Inductor&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;CMSD4448&lt;/TD&gt;
			&lt;TD&gt;SOT323&lt;/TD&gt;
			&lt;TD&gt;Central Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;Switching diode&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;Colibri SODimm 200&lt;/TD&gt;
			&lt;TD&gt;SODimm 200&lt;/TD&gt;
			&lt;TD&gt;Toradex&lt;/TD&gt;
                        		&lt;TD&gt;SODimm 200 Connectorr&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;CON-22-12-2064&lt;/TD&gt;
			&lt;TD&gt;7478-6&lt;/TD&gt;
			&lt;TD&gt;Molex&lt;/TD&gt;
                        		&lt;TD&gt;2.54mm (.100") KK® Solid Header 7478 Right Angle Friction Lockes&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;CON-22-16-2070&lt;/TD&gt;
			&lt;TD&gt;4455-7&lt;/TD&gt;
			&lt;TD&gt;Molex&lt;/TD&gt;
                        		&lt;TD&gt;2.54mm (.100") KK® PC Board Connector 4455 Right Angle&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;CON-52991-0508&lt;/TD&gt;
			&lt;TD&gt;52991-0508&lt;/TD&gt;
			&lt;TD&gt;Molex&lt;/TD&gt;
                        		&lt;TD&gt;Low profile board to board connector 50pin, 0.5pitch&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;CON-54722-0607&lt;/TD&gt;
			&lt;TD&gt;54722-0607&lt;/TD&gt;
			&lt;TD&gt;Molex&lt;/TD&gt;
                        		&lt;TD&gt;Low profile board to board connector 60pin, 0.5pitch&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;CON-70553-0005&lt;/TD&gt;
			&lt;TD&gt;70553-0005&lt;/TD&gt;
			&lt;TD&gt;Molex&lt;/TD&gt;
                        		&lt;TD&gt;2.54mm (.100") Pitch SL Wire-to-Board Shrouded Header 70553 Single Row, .120" Pocket Right Angle, Low Profile&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;CON-COMPACT-FLASH&lt;/TD&gt;
			&lt;TD&gt;Various Packages&lt;/TD&gt;
			&lt;TD&gt;Hirose,AVX&lt;/TD&gt;
                        		&lt;TD&gt;Various Compact Flash Card Connectors&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;CON-DD1R030HA1&lt;/TD&gt;
			&lt;TD&gt;CON-DD1R030HA1&lt;/TD&gt;
			&lt;TD&gt;JAE&lt;/TD&gt;
                        		&lt;TD&gt;30 pole I/O connector&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;CON-DF17-60F&lt;/TD&gt;
			&lt;TD&gt;CON-DF17-60F&lt;/TD&gt;
			&lt;TD&gt;Hirose&lt;/TD&gt;
                        		&lt;TD&gt;DF17 series 0.5mm pitch 60pin female connector&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;CON-DF17-60M&lt;/TD&gt;
			&lt;TD&gt;CON-DF17-60M&lt;/TD&gt;
			&lt;TD&gt;Hirose&lt;/TD&gt;
                        		&lt;TD&gt;DF17 series 0.5mm pitch 60pin male connector&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-FH19-13&lt;/TD&gt;
			&lt;TD&gt;CON-FH19-13&lt;/TD&gt;
			&lt;TD&gt;Hirose&lt;/TD&gt;
           	        		&lt;TD&gt;FH19 13pin 0.5mm pitch FPC/FFC connector&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-FH19-30&lt;/TD&gt;
			&lt;TD&gt;CON-FH19-30&lt;/TD&gt;
			&lt;TD&gt;Hirose&lt;/TD&gt;
           	        		&lt;TD&gt;FH19 30pin 0.5mm pitch FPC/FFC connector&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-FH19S-18&lt;/TD&gt;
			&lt;TD&gt;CON-FH19S-18&lt;/TD&gt;
			&lt;TD&gt;Hirose&lt;/TD&gt;
           	        		&lt;TD&gt;FH19S 18pin 0.5mm pitch FPC/FFC connector&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-FH23-25S&lt;/TD&gt;
			&lt;TD&gt;CON-FH23-25S&lt;/TD&gt;
			&lt;TD&gt;Hirose&lt;/TD&gt;
           	        		&lt;TD&gt;FH23 25pin 0.3mm pitch FPC/FFC connector&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-GPS&lt;/TD&gt;
			&lt;TD&gt;MA-8-2&lt;/TD&gt;
			&lt;TD&gt;Samtec&lt;/TD&gt;
           	        		&lt;TD&gt;Double row 8 pin surface mounted connector for the GPS module Lassen IQ&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-HEADPHONE&lt;/TD&gt;
			&lt;TD&gt;Various&lt;/TD&gt;
			&lt;TD&gt;Kobiconn, CUI Inc&lt;/TD&gt;
           	        		&lt;TD&gt;3.5mm SURFACE MOUNT AUDIO JACK-STEREO&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-HIROSE-COAXIAL&lt;/TD&gt;
			&lt;TD&gt;Various&lt;/TD&gt;
			&lt;TD&gt;Hirose&lt;/TD&gt;
           	        		&lt;TD&gt;Ultra Small Surface Mount Coaxial Connectors&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-INVERTER&lt;/TD&gt;
			&lt;TD&gt;Various&lt;/TD&gt;
			&lt;TD&gt;Molex&lt;/TD&gt;
           	        		&lt;TD&gt;Micro-Miniature 1.25mm Connectors&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-MINI_USB-A&lt;/TD&gt;
			&lt;TD&gt;Various&lt;/TD&gt;
			&lt;TD&gt;Kobiconn&lt;/TD&gt;
           	        		&lt;TD&gt;Mini USB Type A Connector&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-MINI_USB-AB&lt;/TD&gt;
			&lt;TD&gt;Various&lt;/TD&gt;
			&lt;TD&gt;Hirose,Molex&lt;/TD&gt;
           	        		&lt;TD&gt;Mini USB Type A/B Connector&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;CON-PWR-JACK&lt;/TD&gt;
			&lt;TD&gt;Various&lt;/TD&gt;
			&lt;TD&gt;Kycon,Kobiconn&lt;/TD&gt;
                        		&lt;TD&gt;DC Power Jacks 2.1mm and 2.5mm&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-RJ45&lt;/TD&gt;
			&lt;TD&gt;Various Packages&lt;/TD&gt;
			&lt;TD&gt;Kycon&lt;/TD&gt;
           	        		&lt;TD&gt;Ethernet RJ45 8-pol surface mount modular jack&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-SD-MMC&lt;/TD&gt;
			&lt;TD&gt;Various Packages&lt;/TD&gt;
			&lt;TD&gt;Hirose, AVX&lt;/TD&gt;
           	        		&lt;TD&gt;SD/MMC Card Connectos&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-SPEAKER&lt;/TD&gt;
			&lt;TD&gt;Various Packages&lt;/TD&gt;
			&lt;TD&gt;Various Manufactures&lt;/TD&gt;
           	        		&lt;TD&gt;SMD/Through hole pin connectors&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-ST60-24P&lt;/TD&gt;
			&lt;TD&gt;ST60-24P&lt;/TD&gt;
			&lt;TD&gt;Hirose&lt;/TD&gt;
           	        		&lt;TD&gt;Interface Connectors for Miniature, Portable Terminal Devices&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-S-VIDEO&lt;/TD&gt;
			&lt;TD&gt;Various&lt;/TD&gt;
			&lt;TD&gt;CUI Inc&lt;/TD&gt;
           	        		&lt;TD&gt;MINIATURE CIRCULAR DIN CONNECTOR&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-TOUCHPANEL&lt;/TD&gt;
			&lt;TD&gt;FCI-SFW4R-5&lt;/TD&gt;
			&lt;TD&gt;FCI&lt;/TD&gt;
           	        		&lt;TD&gt;SMT 1mm FPC connector 4pins&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-TRACKBALL&lt;/TD&gt;
			&lt;TD&gt;Various&lt;/TD&gt;
			&lt;TD&gt;AVX,Molex/TD&gt;
           	        		&lt;TD&gt;SMT 0.5mm FPC connector 11pins&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CON-USB&lt;/TD&gt;
			&lt;TD&gt;Various&lt;/TD&gt;
			&lt;TD&gt;Assmann, Kycon,  Mill-Max&lt;/TD&gt;
           	        		&lt;TD&gt;SMT USB Type-A Connectors&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;CRSTALS&lt;/TD&gt;
			&lt;TD&gt;Various Packages&lt;/TD&gt;
			&lt;TD&gt;Epson,Citizen,ECS/TD&gt;
           	        		&lt;TD&gt;Various crystals from various manufactures&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;CTP-35009-01&lt;/TD&gt;
			&lt;TD&gt;CTP-35009-01&lt;/TD&gt;
			&lt;TD&gt;www.connect-tech-products.com&lt;/TD&gt;
           	        		&lt;TD&gt;Trough hole head phone jack&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;CTS-Crystals&lt;/TD&gt;
			&lt;TD&gt;CTS-405, CTS-406&lt;/TD&gt;
			&lt;TD&gt;CTS&lt;/TD&gt;
           	        		&lt;TD&gt;Ceramic - SM Crystal (10 - 50MHz)&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;C_US&lt;/TD&gt;
			&lt;TD&gt;various packages&lt;/TD&gt;
			&lt;TD&gt;Panasonic&lt;/TD&gt;
                        		&lt;TD&gt;Capacitors in various packages&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;D53LC&lt;/TD&gt;
			&lt;TD&gt;D53LC&lt;/TD&gt;
			&lt;TD&gt;TOKO&lt;/TD&gt;
                        		&lt;TD&gt;SURFACE MOUNT FIXED INDUCTOR&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;D518LC&lt;/TD&gt;
			&lt;TD&gt;D518LC&lt;/TD&gt;
			&lt;TD&gt;TOKO&lt;/TD&gt;
                        		&lt;TD&gt;SURFACE MOUNT FIXED INDUCTOR&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;DAC6571&lt;/TD&gt;
			&lt;TD&gt;SOT23-6&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;10-BIT DIGITAL-TO-ANALOG CONVERTER&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;DS1629&lt;/TD&gt;
			&lt;TD&gt;SOIC8&lt;/TD&gt;
			&lt;TD&gt;Maxim&lt;/TD&gt;
                        		&lt;TD&gt;2-Wire Digital Thermometer and Real Time Clock&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;DS90C363B_DS90C365_THC63LVDM63R&lt;/TD&gt;
			&lt;TD&gt;TSSOP-48&lt;/TD&gt;
			&lt;TD&gt;National Semiconductors, Thine Electronics&lt;/TD&gt;
                        		&lt;TD&gt;+3.3V Programmable LVDS Transmitter 18-Bit Flat Panel Display (FPD) Link -65 MHz&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;D_SCHOTTKY&lt;/TD&gt;
			&lt;TD&gt;various packages&lt;/TD&gt;
			&lt;TD&gt;NN&lt;/TD&gt;
                        		&lt;TD&gt;Schottky diodes in various packages&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;ECX-306&lt;/TD&gt;
			&lt;TD&gt;ECX-306&lt;/TD&gt;
			&lt;TD&gt;ECS&lt;/TD&gt;
                        		&lt;TD&gt;ISMD Tuning Frok Crystal Unit&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;EEPROM_93C46&lt;/TD&gt;
			&lt;TD&gt;DIL08, SOIC8&lt;/TD&gt;
			&lt;TD&gt;Microchip&lt;/TD&gt;
                        		&lt;TD&gt;IC SERIAL EEPROM 1K 64X16 8SOIC&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;ESDXXL&lt;/TD&gt;
			&lt;TD&gt;SOT23 Plastic&lt;/TD&gt;
			&lt;TD&gt;ST-Microelectronics&lt;/TD&gt;
                        		&lt;TD&gt;DUAL TRANSIL ARRAY FOR ESD PROTECTION&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;FA-248&lt;/TD&gt;
			&lt;TD&gt;FA-248&lt;/TD&gt;
			&lt;TD&gt;Epson&lt;/TD&gt;
                        		&lt;TD&gt;Thin SMD High Frequency Crystal Unit (12-27MHz)&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;FC-135&lt;/TD&gt;
			&lt;TD&gt;FC-135&lt;/TD&gt;
			&lt;TD&gt;Epson&lt;/TD&gt;
                        		&lt;TD&gt;Thin SMD LowFrequency Crystal Unit(32.768kHz)&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;FC-145&lt;/TD&gt;
			&lt;TD&gt;FC-145&lt;/TD&gt;
			&lt;TD&gt;Epson&lt;/TD&gt;
                        		&lt;TD&gt;Thin SMD LowFrequency Crystal Unit(32.768kHz)&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR&gt;
			&lt;TD&gt;FDB1*AN06A0&lt;/TD&gt;
			&lt;TD&gt;TO-263AB&lt;/TD&gt;
			&lt;TD&gt;Fairchild Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;N-Channel PowerTrench MOSFET 60V, 75A/65A, 10.5mOhm&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR&gt;
			&lt;TD&gt;FDC645N&lt;/TD&gt;
			&lt;TD&gt;SSOT-6&lt;/TD&gt;
			&lt;TD&gt;Fairchild Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;N-Channel PowerTrench MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR&gt;
			&lt;TD&gt;FDC6305N&lt;/TD&gt;
			&lt;TD&gt;SSOT-6&lt;/TD&gt;
			&lt;TD&gt;Fairchild Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;Dual N-Channel 2.5V Specified PowerTrench MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR&gt;
			&lt;TD&gt;FDS6670AS&lt;/TD&gt;
			&lt;TD&gt;SO-8&lt;/TD&gt;
			&lt;TD&gt;Fairchild Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;30V N-Channel PowerTrench® SyncFET&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;FDS6679Z&lt;/TD&gt;
			&lt;TD&gt;SO-8&lt;/TD&gt;
			&lt;TD&gt;Fairchild Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;30 Volt P-Channel PowerTrench MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;FDS6681Z&lt;/TD&gt;
			&lt;TD&gt;SO-8&lt;/TD&gt;
			&lt;TD&gt;Fairchild Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;30 Volt P-Channel PowerTrench MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;FDS6912A&lt;/TD&gt;
			&lt;TD&gt;SO-8&lt;/TD&gt;
			&lt;TD&gt;Fairchild Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;Dual N-Channel Logic Level PowerTrench MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;FDS6990AA&lt;/TD&gt;
			&lt;TD&gt;SO-8&lt;/TD&gt;
			&lt;TD&gt;Fairchild Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;Dual N-Channel PowerTrench SyncFET&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;FDS7079ZN3 &lt;/TD&gt;
			&lt;TD&gt;SO-8&lt;/TD&gt;
			&lt;TD&gt;Fairchild Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;-30 Volt P-Channel PowerTrench MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;FDS8928A&lt;/TD&gt;
			&lt;TD&gt;SO-8&lt;/TD&gt;
			&lt;TD&gt;Fairchild Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;Dual N &amp; P-Channel Enhancement Mode Field Effect Transistor&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;FERRIT-JUMPER&lt;/TD&gt;
			&lt;TD&gt;SPECIAL-FERRIT-JUMPER&lt;/TD&gt;
			&lt;TD&gt;Self&lt;/TD&gt;
                        		&lt;TD&gt;The ferrit jumper is a special design for current measurement. &lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;FERRITE-BEAD&lt;/TD&gt;
			&lt;TD&gt;various packages&lt;/TD&gt;
			&lt;TD&gt;NN&lt;/TD&gt;
                        		&lt;TD&gt;Ferrite beads in various packages&lt;/TD&gt;
		&lt;/TR&gt;
       	        	&lt;TR &gt;
			&lt;TD&gt;FUSE&lt;/TD&gt;
			&lt;TD&gt;various packages&lt;/TD&gt;
			&lt;TD&gt;NN&lt;/TD&gt;
                        		&lt;TD&gt;Fuse's in various packages&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;GE28F__L18_T85-VFBGA56&lt;/TD&gt;
			&lt;TD&gt;VFBGA-56&lt;/TD&gt;
			&lt;TD&gt;Intel&lt;/TD&gt;
                        		&lt;TD&gt;Wireless memory (L18) device is the latest generation of Intel StrataFlash® memory &lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;GE28F___L18T85-VFBGA79&lt;/TD&gt;
			&lt;TD&gt;VFBGA-79&lt;/TD&gt;
			&lt;TD&gt;Intel&lt;/TD&gt;
                        		&lt;TD&gt;Wireless memory (L18) device is the latest generation of Intel StrataFlash® memory &lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;GE28F___L18T85_SCSP80&lt;/TD&gt;
			&lt;TD&gt;SCSP-80&lt;/TD&gt;
			&lt;TD&gt;Intel&lt;/TD&gt;
                        		&lt;TD&gt;Wireless memory (L18) device is the latest generation of Intel StrataFlash® memory &lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;GM-862-GPS&lt;/TD&gt;
			&lt;TD&gt;52991-0508&lt;/TD&gt;
			&lt;TD&gt;Telit/Molex&lt;/TD&gt;
                        		&lt;TD&gt;50 pin board to board connector for the GSM Module GM-862-GPS with integrated GPS &lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;HAT1072H&lt;/TD&gt;
			&lt;TD&gt;LFPAK&lt;/TD&gt;
			&lt;TD&gt;Renesas&lt;/TD&gt;
                        		&lt;TD&gt;Silicon P Channel Power MOS FET&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;HM55B&lt;/TD&gt;
			&lt;TD&gt;HM55B&lt;/TD&gt;
			&lt;TD&gt;Hitachi&lt;/TD&gt;
                        		&lt;TD&gt;The Hitachi HM55B is a dual-axis magnetic field sensor&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;IDG-300&lt;/TD&gt;
			&lt;TD&gt;QFN-40&lt;/TD&gt;
			&lt;TD&gt;InvenSense&lt;/TD&gt;
                        		&lt;TD&gt;Integrated Dual-Axis Gyro&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;IRF7317&lt;&lt;/TD&gt;
			&lt;TD&gt;SO-8&lt;/TD&gt;
			&lt;TD&gt;International Rectifier&lt;/TD&gt;
                        		&lt;TD&gt;HEXFET® Power MOSFET (N-P)&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;IRF7329&lt;&lt;/TD&gt;
			&lt;TD&gt;SO-8&lt;/TD&gt;
			&lt;TD&gt;International Rectifier&lt;/TD&gt;
                        		&lt;TD&gt;HEXFET® Power MOSFET (P-P)&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;IRF7424&lt;&lt;/TD&gt;
			&lt;TD&gt;SO-8&lt;/TD&gt;
			&lt;TD&gt;International Rectifier&lt;/TD&gt;
                        		&lt;TD&gt;HEXFET® Power MOSFET (P) Low RDS-on&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;IRF7425&lt;&lt;/TD&gt;
			&lt;TD&gt;SO-8&lt;/TD&gt;
			&lt;TD&gt;International Rectifier&lt;/TD&gt;
                        		&lt;TD&gt;HEXFET® Power MOSFET (P) Low RDS-on&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;IRF7805&lt;&lt;/TD&gt;
			&lt;TD&gt;SO-8&lt;/TD&gt;
			&lt;TD&gt;International Rectifier&lt;/TD&gt;
                        		&lt;TD&gt;HEXFET® Chip-Set for DC-DC Converters&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;ISP1761&lt;&lt;/TD&gt;
			&lt;TD&gt;LQFP-128, TFBGA-128&lt;/TD&gt;
			&lt;TD&gt;Philips Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;Hi-Speed Universal Serial Bus On-The-Go controller&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;JESPER_SH-1&lt;/TD&gt;
			&lt;TD&gt;NN&lt;/TD&gt;
			&lt;TD&gt;NN&lt;/TD&gt;
                        		&lt;TD&gt;SD-Card connector&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;K4M28163PF&lt;/TD&gt;
			&lt;TD&gt;54FBGA&lt;/TD&gt;
			&lt;TD&gt;SAMSUNG&lt;/TD&gt;
                        		&lt;TD&gt;2M x 16Bit x 4 Banks Mobile SDRAM with 1.8V power supply.&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;K4M56323LE&lt;/TD&gt;
			&lt;TD&gt;90FBGA&lt;/TD&gt;
			&lt;TD&gt;SAMSUNG&lt;/TD&gt;
                        		&lt;TD&gt;2M x 32Bit x 4 Banks Mobile SDRAM with 2.5V power supply.&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;K4S28323LF&lt;/TD&gt;
			&lt;TD&gt;90FBGA&lt;/TD&gt;
			&lt;TD&gt;SAMSUNG&lt;/TD&gt;
                        		&lt;TD&gt;1M x 32Bit x 4 Banks Mobile SDRAM with 2.5V power supply&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;K4S51153PF&lt;/TD&gt;
			&lt;TD&gt;54FBGA&lt;/TD&gt;
			&lt;TD&gt;SAMSUNG&lt;/TD&gt;
                        		&lt;TD&gt;8M x 16Bit x 4 Banks Mobile SDRAM with VDD/VDDQ =1.8V/1.8V&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;K4S51323PF&lt;/TD&gt;
			&lt;TD&gt;90FBGA&lt;/TD&gt;
			&lt;TD&gt;SAMSUNG&lt;/TD&gt;
                        		&lt;TD&gt;4M x 32Bit x 4 Banks Mobile-SDRAM with VDD/VDDQ =1.8V/1.8V&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;K4S56323PF&lt;/TD&gt;
			&lt;TD&gt;90FBGA&lt;/TD&gt;
			&lt;TD&gt;SAMSUNG&lt;/TD&gt;
                        		&lt;TD&gt;2M x 32Bit x 4 Banks Mobile SDRAM with 1.8V power supply.&lt;/TD&gt;
		&lt;/TR&gt;
                 	&lt;TR &gt;
			&lt;TD&gt;K9WAG08U1A &lt;/TD&gt;
			&lt;TD&gt;TSOP48L&lt;/TD&gt;
			&lt;TD&gt;SAMSUNG&lt;/TD&gt;
                        		&lt;TD&gt;1G x 8 Bit / 2G x 8 Bit / 4G x 8 Bit NAND Flash Memory.&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;K9**G08U*A &lt;/TD&gt;
			&lt;TD&gt;52-TLGA&lt;/TD&gt;
			&lt;TD&gt;SAMSUNG&lt;/TD&gt;
                        		&lt;TD&gt;1G x 8 Bit / 2G x 8 Bit / 4G x 8 Bit NAND Flash Memory.&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;LED&lt;/TD&gt;
			&lt;TD&gt;NN&lt;/TD&gt;
			&lt;TD&gt;various packages&lt;/TD&gt;
                        		&lt;TD&gt;LED's in various packages&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;LM2717&lt;/TD&gt;
			&lt;TD&gt;TSSOP-24&lt;/TD&gt;
			&lt;TD&gt;National Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;Dual Step-Down DC/DC Converter&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;LM4888SQ&lt;/TD&gt;
			&lt;TD&gt;SQA24A&lt;/TD&gt;
			&lt;TD&gt;National Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;Dual 2.1W Audio Amplifier Plus Stereo Headphone &amp; 3D Enhancement&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;LP3470&lt;/TD&gt;
			&lt;TD&gt;SOT23-5L&lt;/TD&gt;
			&lt;TD&gt;National Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;Tiny Power On Reset Circuit&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;L_US&lt;/TD&gt;
			&lt;TD&gt;various packages&lt;/TD&gt;
			&lt;TD&gt;Sumida, TDK&lt;/TD&gt;
                        		&lt;TD&gt;Inductors in various packages&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;LTC1628&lt;/TD&gt;
			&lt;TD&gt;32QFN and SSOP-28&lt;/TD&gt;
			&lt;TD&gt;Linear Technology&lt;/TD&gt;
                        		&lt;TD&gt;High Efficiency, 2-Phase Synchronous Step-Down Switching Regulators&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;LTC1663&lt;/TD&gt;
			&lt;TD&gt;TSTOT23-5 or MSOP8&lt;/TD&gt;
			&lt;TD&gt;Linear Technology&lt;/TD&gt;
                        		&lt;TD&gt;10-Bit Rail-to-Rail Micropower DAC with 2-Wire Interface&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;LTC1702a&lt;/TD&gt;
			&lt;TD&gt;SSOP-24&lt;/TD&gt;
			&lt;TD&gt;Linear Technology&lt;/TD&gt;
                        		&lt;TD&gt;Dual 550kHz Synchronous 2-Phase Switching Regulator Controller&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;LTC1773&lt;/TD&gt;
			&lt;TD&gt;MSOP-10&lt;/TD&gt;
			&lt;TD&gt;Linear Technology&lt;/TD&gt;
                        		&lt;TD&gt;Synchronous Step-Down DC/DC Controller&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;LTC4100&lt;/TD&gt;
			&lt;TD&gt;SSOP-24&lt;/TD&gt;
			&lt;TD&gt;Linear Technology&lt;/TD&gt;
                        		&lt;TD&gt;Smart Battery Charger Controller&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX63xx&lt;/TD&gt;
			&lt;TD&gt;SOT23&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;3-Pin, Ultra-Low-Power SC70/SOT µP Reset Circuits&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX671x&lt;/TD&gt;
			&lt;TD&gt;SC70-4&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;4-Pin SC70 Microprocessor Reset Circuits with Manual Reset Input&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX811-812&lt;/TD&gt;
			&lt;TD&gt;SOT143 Reflow soldering&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;4-Pin µP Voltage Monitors with Manual Reset Input&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX1535A&lt;/TD&gt;
			&lt;TD&gt;TQFN32&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;Highly Integrated Level 2 SMBus Battery Charger&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX1586-A/B/C&lt;/TD&gt;
			&lt;TD&gt;TQFN48&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;Power Management IC for XSCAL Processors&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX1647&lt;/TD&gt;
			&lt;TD&gt;SSOP20&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;Chemistry-Independent Battery Chargers&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX1648&lt;/TD&gt;
			&lt;TD&gt;SO16&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;Chemistry-Independent Battery Chargers&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX1693/4&lt;/TD&gt;
			&lt;TD&gt;uMAX10&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;USB Current-Limited Switches with Fault Blanking&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX1946&lt;/TD&gt;
			&lt;TD&gt;QFN-8&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;USB Current-Limited Switches with Fault Blanking&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX1953_MAX1954&lt;/TD&gt;
			&lt;TD&gt;UMAX10&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;Low-Cost, High-Frequency, Current-Mode PWM Buck Controller&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX3226_MAX3227 &lt;/TD&gt;
			&lt;TD&gt;SSOP16&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;±15kV ESD-Protected, 1µA, 1Mbps, 3.0V to 5.5V, RS-232 Transceivers with AutoShutdown Plus&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;MAX3232&lt;/TD&gt;
			&lt;TD&gt;SO16&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;250kbit multichannel RS-232 line driver/receiver with ESD protection&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX3244_MAX3245 &lt;/TD&gt;
			&lt;TD&gt;SSOP28,TSSOP28&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;±15kV ESD-Protected, 1µA, 1Mbps, 3.0V to 5.5V, RS-232 Transceivers with AutoShutdown Plus&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;MAX3387E&lt;/TD&gt;
			&lt;TD&gt;TSSOP24&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;RS-232 Transceiver for PDAs and Cell Phones with ESD protection&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX4377&lt;/TD&gt;
			&lt;TD&gt;SOIC8, MSOP8&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;Dual High-Side Current-Sense Amplifier with Internal Gain&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX8713&lt;/TD&gt;
			&lt;TD&gt;TQFN24&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;Simplified Multichemistry SMBus Battery Charger&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX9702&lt;/TD&gt;
			&lt;TD&gt;TQFN28&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;1.8W, Filterless, Stereo, Class D Audio Power Amplifier and DirectDrive Stereo Headphone Amplifier&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX9812&lt;/TD&gt;
			&lt;TD&gt;SC-70&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;Tiny, Low-Cost, Single, Fixed-Gain Microphone Amplifiers with Integrated Bias&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MAX9813&lt;/TD&gt;
			&lt;TD&gt;SOT23-8&lt;/TD&gt;
			&lt;TD&gt;MAXIM&lt;/TD&gt;
                        		&lt;TD&gt;Tiny, Low-Cost, Dual-Input, Fixed-Gain Microphone Amplifiers with Integrated Bias&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MC74VHC1GT125&lt;/TD&gt;
			&lt;TD&gt;SOT23-5,SOT353&lt;/TD&gt;
			&lt;TD&gt;OnSemi&lt;/TD&gt;
                        		&lt;TD&gt;Noninverting Buffer / CMOS Logic Level Shifter with LSTTL-Compatible Inputs&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MC14548x&lt;/TD&gt;
			&lt;TD&gt;SSOP20W&lt;/TD&gt;
			&lt;TD&gt;Freescale (Motorola)&lt;/TD&gt;
                        		&lt;TD&gt;MC145481 3V PCM Codec-Filter and MC145483 13-bit linear PCM Codec-Filter&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MD253&lt;/TD&gt;
			&lt;TD&gt;115FBGA, 115-FBGA&lt;/TD&gt;
			&lt;TD&gt;M-Systems&lt;/TD&gt;
                        		&lt;TD&gt;4GBi, 8Gibt or 16Gbit  Flash Disk with MLC NAND and M-Systems x2 Technology&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MD8831_MD8832&lt;/TD&gt;
			&lt;TD&gt;69FBGA&lt;/TD&gt;
			&lt;TD&gt;M-Systems&lt;/TD&gt;
                        		&lt;TD&gt;1GBit or 2Gibt Flash Disk with MLC NAND and M-Systems x2 Technology&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MIC2171&lt;/TD&gt;
			&lt;TD&gt;TO-263-5&lt;/TD&gt;
			&lt;TD&gt;Micrel&lt;/TD&gt;
                        		&lt;TD&gt;100kHz 2.5A Switching Regulator (step-up)&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MIC2177&lt;/TD&gt;
			&lt;TD&gt;SOP20W&lt;/TD&gt;
			&lt;TD&gt;Micrel&lt;/TD&gt;
                        		&lt;TD&gt;2.5A synchronous buck (stepdown) switching regulator (DC/DC)&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MIC2178&lt;/TD&gt;
			&lt;TD&gt;SOP20W&lt;/TD&gt;
			&lt;TD&gt;Micrel&lt;/TD&gt;
                        		&lt;TD&gt;2.5A synchronous buck (stepdown) switching regulator (DC/DC)&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MIC2179&lt;/TD&gt;
			&lt;TD&gt;SSOP20W&lt;/TD&gt;
			&lt;TD&gt;Micrel&lt;/TD&gt;
                        		&lt;TD&gt;1.5A synchronous buck (stepdown) switching regulator (DC/DC)&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MIC2182&lt;/TD&gt;
			&lt;TD&gt;SOP16, SSOP16&lt;/TD&gt;
			&lt;TD&gt;Micrel&lt;/TD&gt;
                        		&lt;TD&gt;High-Efficiency Synchronous Buck Controller&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MIC2185&lt;/TD&gt;
			&lt;TD&gt;SOIC16, QSOP16&lt;/TD&gt;
			&lt;TD&gt;Micrel&lt;/TD&gt;
                        		&lt;TD&gt;Low Voltage Synchronous Boost PWM Controller IC&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MIC2185&lt;/TD&gt;
			&lt;TD&gt;SOIC16, QSOP16&lt;/TD&gt;
			&lt;TD&gt;Micrel&lt;/TD&gt;
                        		&lt;TD&gt;Low Voltage Synchronous Boost PWM Controller IC&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;MIC2196&lt;/TD&gt;
			&lt;TD&gt;SOIC8&lt;/TD&gt;
			&lt;TD&gt;Micrel&lt;/TD&gt;
                        		&lt;TD&gt;400kHz SO-8 Boost Control IC&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;MMBD4148CC&lt;/TD&gt;
			&lt;TD&gt;SOT-23&lt;/TD&gt;
			&lt;TD&gt;Fairchild&lt;/TD&gt;
                        		&lt;TD&gt;Dual Small Signal Diode&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;MMA7260Q&lt;/TD&gt;
			&lt;TD&gt;QFN-16&lt;/TD&gt;
			&lt;TD&gt;Freescale Semiconductor&lt;/TD&gt;
                        		&lt;TD&gt;±1.5g - 6g Three Axis Low-g&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;MS5534A/B&lt;/TD&gt;
			&lt;TD&gt;MS5534A/B-TOP, MS5534A/B-BOTTOM&lt;/TD&gt;
			&lt;TD&gt;Intersema Sensoric SA&lt;/TD&gt;
                        		&lt;TD&gt;Altimeter/Barometer Module&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;MSM7702&lt;/TD&gt;
			&lt;TD&gt;SSOP20-P&lt;/TD&gt;
			&lt;TD&gt;OKI&lt;/TD&gt;
                        		&lt;TD&gt;Single Rail CODEC&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;MSM7717&lt;/TD&gt;
			&lt;TD&gt;SSOP20-P&lt;/TD&gt;
			&lt;TD&gt;OKI&lt;/TD&gt;
                        		&lt;TD&gt;Single Rail CODEC&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;MT48H8M32LF&lt;/TD&gt;
			&lt;TD&gt;90FBGA&lt;/TD&gt;
			&lt;TD&gt;Micron&lt;/TD&gt;
                        		&lt;TD&gt;256Mb: 8 Meg x 32 Mobile SDRAM&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;MXD2125&lt;/TD&gt;
			&lt;TD&gt;LCC-8&lt;/TD&gt;
			&lt;TD&gt;MEMSIC&lt;/TD&gt;
                        		&lt;TD&gt;Ultra Low Noise ±3 g Dual Axis Accelerometer with Digital Outputs&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;OSCILLATORS&lt;/TD&gt;
			&lt;TD&gt;Various Packages&lt;/TD&gt;
			&lt;TD&gt;Abracon, Connor Winfield, CTS,Citizen&lt;/TD&gt;
                        		&lt;TD&gt;Various Osccilators 32kHz, 1 to 50MHz &lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;NFM46P&lt;/TD&gt;
			&lt;TD&gt;2220&lt;/TD&gt;
			&lt;TD&gt;muRata&lt;/TD&gt;
                        		&lt;TD&gt;Large rated current 3 terminal capacitor in DC power line (6A) &lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;NFM2012P&lt;/TD&gt;
			&lt;TD&gt;0805&lt;/TD&gt;
			&lt;TD&gt;muRata&lt;/TD&gt;
                        		&lt;TD&gt;Large rated current 3 terminal capacitor in DC power line (2-4A)&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;PLM250S&lt;/TD&gt;
			&lt;TD&gt;PLM250S&lt;/TD&gt;
			&lt;TD&gt;muRata&lt;/TD&gt;
                        		&lt;TD&gt;Choke Coil&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;PXA270_PBGA&lt;/TD&gt;
			&lt;TD&gt;23x23mm PBGA&lt;/TD&gt;
			&lt;TD&gt;Intel&lt;/TD&gt;
                        		&lt;TD&gt;Intel® PXA270 MultiMedia Processor&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;PXA270_VF_BGA&lt;/TD&gt;
			&lt;TD&gt;13x13mm VFBGA&lt;/TD&gt;
			&lt;TD&gt;Intel&lt;/TD&gt;
                        		&lt;TD&gt;Intel® PXA270 MultiMedia Processor&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;QuickIDE&lt;/TD&gt;
			&lt;TD&gt;BGA 196&lt;/TD&gt;
			&lt;TD&gt;Quick Logic&lt;/TD&gt;
                        		&lt;TD&gt;QuickIDE Intel XScale PXA2xx to IDE Bridge&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;RESET-BUTTON&lt;/TD&gt;
			&lt;TD&gt;EVQ-PJU05K&lt;/TD&gt;
			&lt;TD&gt;Panasonic&lt;/TD&gt;
                        		&lt;TD&gt;Surface Mount Momentary Pushbutton Switches&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;RESONATOR-MURATA2&lt;/TD&gt;
			&lt;TD&gt;RESONATOR-MURATA2&lt;/TD&gt;
			&lt;TD&gt;Murata&lt;/TD&gt;
                        		&lt;TD&gt;ceramic Resonator with built in load capacitance&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;RESONATOR-MURATA3&lt;/TD&gt;
			&lt;TD&gt;RESONATOR-MURATA3&lt;/TD&gt;
			&lt;TD&gt;Murata&lt;/TD&gt;
                        		&lt;TD&gt;ceramic Resonator with built in load capacitance&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;RESONATOR-MURATA4&lt;/TD&gt;
			&lt;TD&gt;RESONATOR-MURATA4&lt;/TD&gt;
			&lt;TD&gt;Murata&lt;/TD&gt;
                        		&lt;TD&gt;ceramic Resonator with built in load capacitance&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;RGB-TRI-LED&lt;/TD&gt;
			&lt;TD&gt;Various&lt;/TD&gt;
			&lt;TD&gt;Various&lt;/TD&gt;
                        		&lt;TD&gt;RGB Tri-LEDs&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;RN_EU&lt;/TD&gt;
			&lt;TD&gt;various packages&lt;/TD&gt;
			&lt;TD&gt;CTS,Panasonic&lt;/TD&gt;
                        		&lt;TD&gt;Resistor Chip Arrays in various packages&lt;/TD&gt;
		&lt;/TR&gt;
               	&lt;TR &gt;
			&lt;TD&gt;RW1S0CK&lt;/TD&gt;
			&lt;TD&gt;Special Package&lt;/TD&gt;
			&lt;TD&gt;www.ohmite.com&lt;/TD&gt;
                        		&lt;TD&gt;Four-terminal Current Sense Resistor&lt;/TD&gt;
		&lt;/TR&gt;
               	&lt;TR &gt;
			&lt;TD&gt;R_TRIM1&lt;/TD&gt;
			&lt;TD&gt;RESISTOR-TRIM1/2&lt;/TD&gt;
			&lt;TD&gt;www.tocos.com&lt;/TD&gt;
                        		&lt;TD&gt;Trim Resistors&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;R_US&lt;/TD&gt;
			&lt;TD&gt;various packages&lt;/TD&gt;
			&lt;TD&gt;NN&lt;/TD&gt;
                        		&lt;TD&gt;Resistors in various packages&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;SCA3000&lt;/TD&gt;
			&lt;TD&gt;SCA3000&lt;/TD&gt;
			&lt;TD&gt;VTI Technologies&lt;/TD&gt;
                        		&lt;TD&gt;3-AXIS ULTRA LOW POWER ACCELEROMETER WITH DIGITAL I2C or SPI INTERFACE&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SCP1000&lt;/TD&gt;
			&lt;TD&gt;SCP1000&lt;/TD&gt;
			&lt;TD&gt;VTI Technologies&lt;/TD&gt;
                        		&lt;TD&gt;Pressure Sensor as Barometer and Altimeter&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;Si3456BDV&lt;/TD&gt;
			&lt;TD&gt;TSOP-6&lt;/TD&gt;
			&lt;TD&gt;VISHAY/Siliconix&lt;/TD&gt;
                        		&lt;TD&gt;N-Channel 30-V (D-S) MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;Si4431BDY&lt;/TD&gt;
			&lt;TD&gt;SOIC-8&lt;/TD&gt;
			&lt;TD&gt;VISHAY/Siliconix&lt;/TD&gt;
                        		&lt;TD&gt;P-Channel 30-V (D-S) MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;Si4435BDY&lt;/TD&gt;
			&lt;TD&gt;SOIC-8&lt;/TD&gt;
			&lt;TD&gt;VISHAY/Siliconix&lt;/TD&gt;
                        		&lt;TD&gt;P-Channel 30-V (D-S) MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;Si4800BDY&lt;/TD&gt;
			&lt;TD&gt;SOIC-8&lt;/TD&gt;
			&lt;TD&gt;VISHAY/Siliconix&lt;/TD&gt;
                        		&lt;TD&gt;N-Channel Reduced Qg, Fast Switching MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;Si4835BDY&lt;/TD&gt;
			&lt;TD&gt;SOIC-8&lt;/TD&gt;
			&lt;TD&gt;VISHAY/Siliconix&lt;/TD&gt;
                        		&lt;TD&gt;P-Channel 30-V (D-S) MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;Si4884BDY&lt;/TD&gt;
			&lt;TD&gt;SOIC-8&lt;/TD&gt;
			&lt;TD&gt;VISHAY/Siliconix&lt;/TD&gt;
                        		&lt;TD&gt;N-Channel 30-V (D-S) MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;Si4888BDY&lt;/TD&gt;
			&lt;TD&gt;SOIC-8&lt;/TD&gt;
			&lt;TD&gt;VISHAY/Siliconix&lt;/TD&gt;
                        		&lt;TD&gt;N-Channel Reduced Qg, Fast Switching MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;Si4925BDY&lt;/TD&gt;
			&lt;TD&gt;SOIC-8&lt;/TD&gt;
			&lt;TD&gt;VISHAY/Siliconix&lt;/TD&gt;
                        		&lt;TD&gt;Dual P-Channel 30-V (D-S) MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;Si5443DC&lt;/TD&gt;
			&lt;TD&gt;1206-8 ChipFET&lt;/TD&gt;
			&lt;TD&gt;VISHAY/Siliconix&lt;/TD&gt;
                        		&lt;TD&gt;P-Channel 2.5-V (G-S) MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;Si7868ADP&lt;/TD&gt;
			&lt;TD&gt;So-8-PowerPAK&lt;/TD&gt;
			&lt;TD&gt;VISHAY/Siliconix&lt;/TD&gt;
                        		&lt;TD&gt;N-Channel 20-V (D-S) MOSFET&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;SMT-ANTENNA&lt;/TD&gt;
			&lt;TD&gt;Various&lt;/TD&gt;
                        		&lt;TD&gt;GigaAnt, Linx&lt;/TD&gt;
			&lt;TD&gt;2.4Ghz SMD Antennas&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SN74**C1G08&lt;/TD&gt;
			&lt;TD&gt;SOT23-5,SC70-5&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;Single AND Gate positiv logic&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SN74AVC4T245&lt;/TD&gt;
			&lt;TD&gt;TSSOP-16W, QFN-16, TVSOP16&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;4-BIT DUAL-SUPPLY BUS TRANSCEIVER WITH CONFIGURABLE VOLTAGE TRANSLATION AND 3-STATE OUTPUTS&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SN74AVC8T245&lt;/TD&gt;
			&lt;TD&gt;TSSOP-24, QFN-24&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;8-BIT DUAL-SUPPLY BUS TRANSCEIVER WITH CONFIGURABLE VOLTAGE TRANSLATION AND 3-STATE OUTPUTS&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SN74AVCAH164245&lt;/TD&gt;
			&lt;TD&gt;TVSOP-48&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;16-BIT DUAL-SUPPLY BUS TRANSCEIVER WITH CONFIGURABLE VOLTAGE TRANSLATION AND 3-STATE OUTPUTS&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SN74AVCB324245&lt;/TD&gt;
			&lt;TD&gt;LFBGA96&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;32-BIT DUAL-SUPPLY BUS TRANSCEIVER WITH CONFIGURABLE VOLTAGE TRANSLATION AND 3-STATE OUTPUTS&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SN74LVC1G04&lt;/TD&gt;
			&lt;TD&gt;SOT23-5,SC70-5&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;Single Inverter Gate&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SN74LVC2G04&lt;/TD&gt;
			&lt;TD&gt;SOT23-6,SC70-6&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;Dual Inverter Gate&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SN74LVC2G08&lt;/TD&gt;
			&lt;TD&gt;SSOP-8,VSSOP-8&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;Dual AND Gate positiv logic&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SN74LVC2G157&lt;/TD&gt;
			&lt;TD&gt;SSOP8,VSSOP8&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;SINGLE 2-LINE TO 1-LINE DATA SELECTOR/MULTIPLEXER&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SN74LVC2G241&lt;/TD&gt;
			&lt;TD&gt;SSOP8,VSSOP8&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;Dual Buffer/Driver with 3.States Output&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SN74xxx138&lt;/TD&gt;
			&lt;TD&gt;SOIC-16, SSOP-16, TSSOP-16&lt;/TD&gt;
			&lt;TD&gt;Texas Instruments&lt;/TD&gt;
                        		&lt;TD&gt;3-Line to 8-Line Decoder/Demultiplexer&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SP724AH&lt;/TD&gt;
			&lt;TD&gt;SOT23-6L&lt;/TD&gt;
			&lt;TD&gt;Harris or Littlefuse&lt;/TD&gt;
                        		&lt;TD&gt;SCR Diode Array for ESD and Transient Overvoltage Protection&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;STEREOJACK1&lt;/TD&gt;
			&lt;TD&gt;STEREOJACK1&lt;/TD&gt;
			&lt;TD&gt;NN&lt;/TD&gt;
                        		&lt;TD&gt;stereojack from Jespers Yampp7 MP3 player&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;STF203-xx&lt;/TD&gt;
			&lt;TD&gt;SC70-6L&lt;/TD&gt;
			&lt;TD&gt;SEMTECH&lt;/TD&gt;
                        		&lt;TD&gt;USB Upstream Port Filter and TVS For EMI Filtering and ESD Protection&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SWITCH_01&lt;/TD&gt;
			&lt;TD&gt;SWITCH_01&lt;/TD&gt;
			&lt;TD&gt;NN&lt;/TD&gt;
                        		&lt;TD&gt;surface mount momentary pushbutton switch&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SWITCH_04&lt;/TD&gt;
			&lt;TD&gt;SWITCH_04&lt;/TD&gt;
			&lt;TD&gt;www.e-switch.com&lt;/TD&gt;
                        		&lt;TD&gt;SMT dip switches&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SWITCH_NAVIGATION&lt;/TD&gt;
			&lt;TD&gt;ITT_TPC&lt;/TD&gt;
			&lt;TD&gt;ITT Canon&lt;/TD&gt;
                        		&lt;TD&gt;TPC Series Tri-direction Scan Switch&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;SWITCH_ROTERY&lt;/TD&gt;
			&lt;TD&gt;ALPS_SLLB120_220&lt;/TD&gt;
			&lt;TD&gt;ALPS&lt;/TD&gt;
                        		&lt;TD&gt;HORIZONTAL TYPE SEESAW AND PUSH OPERATION SWITCHES&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;TC7SH32F/FU&lt;/TD&gt;
			&lt;TD&gt;SSOP5-P-0.65A SSOP5-P-0.95&lt;/TD&gt;
			&lt;TD&gt;Toshiba&lt;/TD&gt;
                        		&lt;TD&gt;2-Input OR-Gate&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;TDC-002&lt;/TD&gt;
			&lt;TD&gt;Various packages&lt;/TD&gt;
			&lt;TD&gt;TECHNIK INDUSTRIAL CO. LTD&lt;/TD&gt;
                        		&lt;TD&gt;DC Power Jack&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;TG110-S050N2&lt;/TD&gt;
			&lt;TD&gt;SOIC16&lt;/TD&gt;
			&lt;TD&gt;Halo Electronics Inc&lt;/TD&gt;
                        		&lt;TD&gt;ULTRA-Series, 16 Pin SOIC 10/100BASE-TX Magnetic Modules&lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;THS8135&lt;/TD&gt;
			&lt;TD&gt;TQFP48&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;TRIPLE 10-BIT, 240 MSPS VIDEO DAC WITH TRI-LEVEL SYNC&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;TMM-106-03-S-G&lt;/TD&gt;
			&lt;TD&gt;TMM-106&lt;/TD&gt;
			&lt;TD&gt;Samtec&lt;/TD&gt;
            			&lt;TD&gt;2mm Board Stacker&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;TMM-108-03-D-G&lt;/TD&gt;
			&lt;TD&gt;TMM-108&lt;/TD&gt;
			&lt;TD&gt;Samtec&lt;/TD&gt;
            			&lt;TD&gt;2mm Board Stacker&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;TPA6204A1&lt;/TD&gt;
			&lt;TD&gt;QFN8-DRB&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;1.7-W mono fully-differential audio amplifier&lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TPS2042&lt;/TD&gt;
			&lt;TD&gt;SOIC-8, MSOP-8&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;CURRENT-LIMITED, POWER-DISTRIBUTION SWITCHES&lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TPS5124&lt;/TD&gt;
			&lt;TD&gt;TSSOP30&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;Dual channel, synchronous, step-down PWM controller&lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TPS5410_TPS5420&lt;/TD&gt;
			&lt;TD&gt;SOIC-8&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;1A or 2A, WIDE INPUT RANGE, STEP-DOWN SWIFT CONVERTER&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;TPS51020&lt;/TD&gt;
			&lt;TD&gt;TSSOP30&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;Dual voltage mode, DDR selectable, synchronous, step-down controller for notebook system power&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;TPS54350&lt;/TD&gt;
			&lt;TD&gt;PSOP-16&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;4.5V to 20V Input, 3A Output Synchronous PWM Switcher with integrated FET&lt;/TD&gt;
		&lt;/TR&gt;
		&lt;TR &gt;
			&lt;TD&gt;TPS54550&lt;/TD&gt;
			&lt;TD&gt;PSOP-16&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;4.5V to 20V Input, 6A Output Synchronous PWM Switcher with integrated FET&lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TPS6211*&lt;/TD&gt;
			&lt;TD&gt;QFN16&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;17-V, 1.5-A, SYNCHRONOUS STEP-DOWN CONVERTER &lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TPS623XX&lt;/TD&gt;
			&lt;TD&gt;QFN-10&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;500mA, 3-MHz synchronous step-down converter &lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TPS6200x&lt;/TD&gt;
			&lt;TD&gt;MSOP-10&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;600-mA High efficiency Step-Down low power DC-DC Converter&lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TPS6204x&lt;/TD&gt;
			&lt;TD&gt;MSOP-10&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;1.2 A/1.25 MHz, HIGH-EFFICIENCY STEP-DOWN CONVERTER&lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TPS6250x&lt;/TD&gt;
			&lt;TD&gt;MSOP-10&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;800-mA SYNCHRONOUS STEP-DOWN CONVERTER&lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TPS6220x&lt;/TD&gt;
			&lt;TD&gt;SOT23-5L&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;300-mA High efficiency Step-Down low power DC-DC Converter&lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TPS62510&lt;/TD&gt;
			&lt;TD&gt;QFN10&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;1.5-A, LOW INPUT VOLTAGE HIGH EFFICIENCY STEP-DOWN CONVERTER&lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TS5A3153 &lt;/TD&gt;
			&lt;TD&gt;SSOP8, VSSOP8&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;single-pole double-throw (SPDT) analog switch&lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TS5A3159 &lt;/TD&gt;
			&lt;TD&gt;SOT23-6L, SC-70&lt;/TD&gt;
			&lt;TD&gt;Texas Instrument&lt;/TD&gt;
            			&lt;TD&gt;single-pole double-throw (SPDT) analog switch&lt;/TD&gt;
		&lt;/TR&gt;
        		&lt;TR &gt;
			&lt;TD&gt;TW-09-02-SD-170-SMT&lt;/TD&gt;
			&lt;TD&gt;TW-09-02-SD&lt;/TD&gt;
			&lt;TD&gt;SAMTEC &lt;/TD&gt;
                        		&lt;TD&gt;SAMTEC Board Stacker&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;USB-B&lt;/TD&gt;
			&lt;TD&gt;USB-B USB-MINI-B&lt;/TD&gt;
			&lt;TD&gt;Molex&lt;/TD&gt;
                        		&lt;TD&gt;USB type (mini-)B surface mount connector&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;VREG_MULTI&lt;/TD&gt;
			&lt;TD&gt;SOT223&lt;/TD&gt;
			&lt;TD&gt;National Semiconductors&lt;/TD&gt;
                        		&lt;TD&gt;standard package voltage regulator&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;VREG_MULTI2&lt;/TD&gt;
			&lt;TD&gt;SOT23&lt;/TD&gt;
			&lt;TD&gt;National Semiconductors&lt;/TD&gt;
                        		&lt;TD&gt;standard package voltage regulator&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;XC2C256 _CP&lt;/TD&gt;
			&lt;TD&gt;CP132&lt;/TD&gt;
			&lt;TD&gt;Xilinx&lt;/TD&gt;
                        		&lt;TD&gt;1.8V 256 macrocell CPLD targeted at power sensitive designs&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;XC2C384 _FT256&lt;/TD&gt;
			&lt;TD&gt;FT256_FTG256&lt;/TD&gt;
			&lt;TD&gt;Xilinx&lt;/TD&gt;
                        		&lt;TD&gt;1.8V 384 macrocell CPLD targeted at power sensitive designs&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;XC2C512 _FG324&lt;/TD&gt;
			&lt;TD&gt;FG324&lt;/TD&gt;
			&lt;TD&gt;Xilinx&lt;/TD&gt;
                        		&lt;TD&gt;1.8V 512 macrocell CPLD targeted at power sensitive designs&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;XCR3128XL_CS&lt;/TD&gt;
			&lt;TD&gt;CS144&lt;/TD&gt;
			&lt;TD&gt;Xilinx&lt;/TD&gt;
                        		&lt;TD&gt;3.3V 128 macrocell CPLD targeted at power sensitive designs&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;XCR3128XL_CS&lt;/TD&gt;
			&lt;TD&gt;TQFP144&lt;/TD&gt;
			&lt;TD&gt;Xilinx&lt;/TD&gt;
                        		&lt;TD&gt;3.3V 128 macrocell CPLD targeted at power sensitive designs&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;XCR3128XL_CS&lt;/TD&gt;
			&lt;TD&gt;VQFP100&lt;/TD&gt;
			&lt;TD&gt;Xilinx&lt;/TD&gt;
                        		&lt;TD&gt;3.3V 128 macrocell CPLD targeted at power sensitive designs&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;XCR3256XL_TQ&lt;/TD&gt;
			&lt;TD&gt;TQFP144&lt;/TD&gt;
			&lt;TD&gt;Xilinx&lt;/TD&gt;
                        		&lt;TD&gt;3.3V 256 macrocell CPLD targeted at power sensitive designs&lt;/TD&gt;
		&lt;/TR&gt;
               	&lt;TR &gt;
			&lt;TD&gt;ZHX1810&lt;/TD&gt;
			&lt;TD&gt;ZHX1810&lt;/TD&gt;
			&lt;TD&gt;ZILOG&lt;/TD&gt;
                        		&lt;TD&gt;Low-profile 1-meter transceiver with IrDa Data mode&lt;/TD&gt;
		&lt;/TR&gt;
                	&lt;TR &gt;
			&lt;TD&gt;ZHX2022&lt;/TD&gt;
			&lt;TD&gt;ZHX2022&lt;/TD&gt;
			&lt;TD&gt;ZILOG&lt;/TD&gt;
            		&lt;TD&gt;IrDA transceiver with up to 4 Mbits/s data rate&lt;/TD&gt;
		&lt;/TR&gt;
	&lt;/TBODY&gt;
&lt;/TABLE&gt;
&lt;b&gt;NN:&lt;/b&gt;Not Named&lt;br&gt;
&lt;br&gt;
&lt;br&gt;&lt;b&gt;License:&lt;/b&gt;&lt;br&gt;
&lt;br&gt;
************************************************************************************************************************&lt;br&gt;
*  This program is free software; you can redistribute  it and/or modify it&lt;br&gt;
 *  under  the terms of  the &lt;b&gt;GNU General  Public License&lt;/b&gt; as published by the&lt;br&gt;
 *  Free Software Foundation;  either &lt;b&gt;version 2&lt;/b&gt; of the  License, or (at your&lt;br&gt;
 *  option) any later version.&lt;br&gt;
 *&lt;br&gt;
 *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED&lt;br&gt;
 *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF&lt;br&gt;
 *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN&lt;br&gt;
 *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,&lt;br&gt;
 *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT&lt;br&gt;
 *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF&lt;br&gt;
 *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON&lt;br&gt;
 *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT&lt;br&gt;
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF&lt;br&gt;
 *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.&lt;br&gt;
 *&lt;br&gt;
 *  You should have received a copy of the  GNU General Public License along&lt;br&gt;
 *  with this program; if not, write  to the Free Software Foundation, Inc.,&lt;br&gt;
 *  675 Mass Ave, Cambridge, MA 02139, USA.&lt;br&gt;
************************************************************************************************************************&lt;br&gt;
&lt;br&gt;</description>
<packages>
<package name="SOT23">
<description>&lt;B&gt;DIODE&lt;/B&gt;</description>
<wire x1="1.4224" y1="0.6604" x2="1.4224" y2="-0.6604" width="0.254" layer="51"/>
<wire x1="1.4224" y1="-0.6604" x2="-1.4224" y2="-0.6604" width="0.254" layer="51"/>
<wire x1="-1.4224" y1="-0.6604" x2="-1.4224" y2="0.6604" width="0.254" layer="51"/>
<wire x1="-1.4224" y1="0.6604" x2="1.4224" y2="0.6604" width="0.254" layer="51"/>
<wire x1="-1.4224" y1="-0.254" x2="-1.4224" y2="0.6604" width="0.254" layer="21"/>
<wire x1="-1.4224" y1="0.6604" x2="-0.6604" y2="0.6604" width="0.254" layer="21"/>
<wire x1="1.4224" y1="0.6604" x2="1.4224" y2="-0.254" width="0.254" layer="21"/>
<wire x1="0.6604" y1="0.6604" x2="1.4224" y2="0.6604" width="0.254" layer="21"/>
<wire x1="0.3048" y1="-0.6604" x2="-0.3048" y2="-0.6604" width="0.254" layer="21"/>
<smd name="3" x="0" y="1.2" dx="0.9" dy="1.2" layer="1"/>
<smd name="2" x="0.95" y="-1.2" dx="0.9" dy="1.2" layer="1"/>
<smd name="1" x="-0.95" y="-1.2" dx="0.9" dy="1.2" layer="1"/>
<text x="-1.905" y="1.905" size="1.27" layer="25">&gt;NAME</text>
<text x="-1.905" y="-3.175" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="-0.2286" y1="0.7112" x2="0.2286" y2="1.2954" layer="51"/>
<rectangle x1="0.7112" y1="-1.2954" x2="1.1684" y2="-0.7112" layer="51"/>
<rectangle x1="-1.1684" y1="-1.2954" x2="-0.7112" y2="-0.7112" layer="51"/>
</package>
</packages>
<symbols>
<symbol name="IGFET-3-N-CH">
<wire x1="-2.54" y1="-2.54" x2="-1.2192" y2="-2.54" width="0.1524" layer="94"/>
<wire x1="0" y1="0.762" x2="0" y2="0" width="0.254" layer="94"/>
<wire x1="0" y1="0" x2="0" y2="-0.762" width="0.254" layer="94"/>
<wire x1="0" y1="2.413" x2="0" y2="1.905" width="0.254" layer="94"/>
<wire x1="0" y1="1.905" x2="0" y2="1.397" width="0.254" layer="94"/>
<wire x1="1.905" y1="0.635" x2="0.635" y2="0" width="0.254" layer="94"/>
<wire x1="1.905" y1="-0.635" x2="0.635" y2="0" width="0.254" layer="94"/>
<wire x1="0" y1="0" x2="0.635" y2="0" width="0.1524" layer="94"/>
<wire x1="0.635" y1="0" x2="2.54" y2="0" width="0.1524" layer="94"/>
<wire x1="2.54" y1="0" x2="2.54" y2="-1.905" width="0.1524" layer="94"/>
<wire x1="0" y1="-1.397" x2="0" y2="-1.905" width="0.254" layer="94"/>
<wire x1="0" y1="-1.905" x2="0" y2="-2.413" width="0.254" layer="94"/>
<wire x1="-1.143" y1="1.905" x2="-1.143" y2="-2.54" width="0.254" layer="94"/>
<wire x1="0" y1="-1.905" x2="2.54" y2="-1.905" width="0.1524" layer="94"/>
<wire x1="2.54" y1="2.54" x2="5.08" y2="2.54" width="0.1524" layer="94"/>
<wire x1="5.08" y1="2.54" x2="5.08" y2="-2.54" width="0.1524" layer="94"/>
<wire x1="5.08" y1="-2.54" x2="2.54" y2="-2.54" width="0.1524" layer="94"/>
<wire x1="2.54" y1="-1.905" x2="2.54" y2="-2.54" width="0.1524" layer="94"/>
<wire x1="2.54" y1="-2.54" x2="2.54" y2="-5.08" width="0.1524" layer="94"/>
<wire x1="0" y1="1.905" x2="2.54" y2="1.905" width="0.1524" layer="94"/>
<wire x1="2.54" y1="1.905" x2="2.54" y2="2.54" width="0.1524" layer="94"/>
<wire x1="2.54" y1="2.54" x2="2.54" y2="5.08" width="0.1524" layer="94"/>
<circle x="2.54" y="2.54" radius="0.127" width="0.254" layer="94"/>
<circle x="2.54" y="-2.54" radius="0.127" width="0.254" layer="94"/>
<circle x="2.54" y="-1.905" radius="0.127" width="0.254" layer="94"/>
<text x="6.35" y="1.27" size="1.778" layer="96">&gt;VALUE</text>
<text x="6.35" y="3.81" size="1.778" layer="95">&gt;NAME</text>
<rectangle x1="4.572" y1="0.635" x2="5.588" y2="0.889" layer="94"/>
<pin name="D" x="2.54" y="5.08" visible="off" length="point" direction="pas" rot="R180"/>
<pin name="G" x="-5.08" y="-2.54" visible="off" length="short" direction="pas"/>
<pin name="S" x="2.54" y="-5.08" visible="off" length="point" direction="pas" rot="R180"/>
<polygon width="0.1524" layer="94">
<vertex x="5.08" y="0.635"/>
<vertex x="4.572" y="-0.127"/>
<vertex x="5.588" y="-0.127"/>
</polygon>
</symbol>
</symbols>
<devicesets>
<deviceset name="BSS138" prefix="Q">
<description>Fairchild Semiconductors &lt;b&gt;BSS138&lt;/b&gt; N-Channel Logic Level Enhancement Mode Field Effect Transistor&lt;br&gt;
&lt;br&gt;
&lt;b&gt;General Description:&lt;/b&gt;&lt;br&gt;
These N-Channel enhancement mode field effect transistors are produced using Fairchild's proprietary,&lt;br&gt;
high cell density, DMOS technology. These products have been designed to minimize on-state resistance&lt;br&gt;
while provide rugged, reliable, and fast switching performance.These products are particularly suited for&lt;br&gt;
low voltage, low current applications such as small servo motor control, power MOSFET gate drivers, and&lt;br&gt;
other switching applications.&lt;br&gt;

&lt;br&gt;
&lt;b&gt;Features:&lt;/b&gt;
&lt;ul&gt;
	&lt;li&gt;0.22 A, 50 V. RDS(ON) = 3.5Ohm @ VGS = 10 V RDS(ON) = 6.0Ohm @ VGS = 4.5 V
	&lt;li&gt;High density cell design for extremely low RDS(ON)
	&lt;li&gt;Rugged and Reliable
	&lt;li&gt;Compact industry standard SOT-23 surface mount package
&lt;/ul&gt;
&lt;br&gt;
Please send any comments to: &lt;a href="mailto:messi@users.sourceforge.net"&gt;messi@users.sourceforge.net&lt;/a&gt;
&lt;br&gt;</description>
<gates>
<gate name="G$1" symbol="IGFET-3-N-CH" x="0" y="0"/>
</gates>
<devices>
<device name="" package="SOT23">
<connects>
<connect gate="G$1" pin="D" pad="3"/>
<connect gate="G$1" pin="G" pad="1"/>
<connect gate="G$1" pin="S" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="pinhead">
<description>&lt;b&gt;Pin Header Connectors&lt;/b&gt;&lt;p&gt;
&lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="1X03">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<wire x1="-3.175" y1="1.27" x2="-1.905" y2="1.27" width="0.1524" layer="21"/>
<wire x1="-1.905" y1="1.27" x2="-1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="0.635" x2="-1.27" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="-0.635" x2="-1.905" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="0.635" x2="-0.635" y2="1.27" width="0.1524" layer="21"/>
<wire x1="-0.635" y1="1.27" x2="0.635" y2="1.27" width="0.1524" layer="21"/>
<wire x1="0.635" y1="1.27" x2="1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="0.635" x2="1.27" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="-0.635" x2="0.635" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="0.635" y1="-1.27" x2="-0.635" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-0.635" y1="-1.27" x2="-1.27" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="0.635" x2="-3.81" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-3.175" y1="1.27" x2="-3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="-0.635" x2="-3.175" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-1.905" y1="-1.27" x2="-3.175" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="1.27" y1="0.635" x2="1.905" y2="1.27" width="0.1524" layer="21"/>
<wire x1="1.905" y1="1.27" x2="3.175" y2="1.27" width="0.1524" layer="21"/>
<wire x1="3.175" y1="1.27" x2="3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="0.635" x2="3.81" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="-0.635" x2="3.175" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="3.175" y1="-1.27" x2="1.905" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="1.905" y1="-1.27" x2="1.27" y2="-0.635" width="0.1524" layer="21"/>
<pad name="1" x="-2.54" y="0" drill="1.016" shape="long" rot="R90"/>
<pad name="2" x="0" y="0" drill="1.016" shape="long" rot="R90"/>
<pad name="3" x="2.54" y="0" drill="1.016" shape="long" rot="R90"/>
<text x="-3.8862" y="1.8288" size="1.27" layer="25" ratio="10">&gt;NAME</text>
<text x="-3.81" y="-3.175" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="-0.254" y1="-0.254" x2="0.254" y2="0.254" layer="51"/>
<rectangle x1="-2.794" y1="-0.254" x2="-2.286" y2="0.254" layer="51"/>
<rectangle x1="2.286" y1="-0.254" x2="2.794" y2="0.254" layer="51"/>
</package>
<package name="1X03/90">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<wire x1="-3.81" y1="-1.905" x2="-1.27" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="-1.905" x2="-1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="0.635" x2="-3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="0.635" x2="-3.81" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="6.985" x2="-2.54" y2="1.27" width="0.762" layer="21"/>
<wire x1="-1.27" y1="-1.905" x2="1.27" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="1.27" y1="-1.905" x2="1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="0.635" x2="-1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="0" y1="6.985" x2="0" y2="1.27" width="0.762" layer="21"/>
<wire x1="1.27" y1="-1.905" x2="3.81" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="3.81" y1="-1.905" x2="3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="0.635" x2="1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="2.54" y1="6.985" x2="2.54" y2="1.27" width="0.762" layer="21"/>
<pad name="1" x="-2.54" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<pad name="2" x="0" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<pad name="3" x="2.54" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<text x="-4.445" y="-3.81" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="5.715" y="-3.81" size="1.27" layer="27" rot="R90">&gt;VALUE</text>
<rectangle x1="-2.921" y1="0.635" x2="-2.159" y2="1.143" layer="21"/>
<rectangle x1="-0.381" y1="0.635" x2="0.381" y2="1.143" layer="21"/>
<rectangle x1="2.159" y1="0.635" x2="2.921" y2="1.143" layer="21"/>
<rectangle x1="-2.921" y1="-2.921" x2="-2.159" y2="-1.905" layer="21"/>
<rectangle x1="-0.381" y1="-2.921" x2="0.381" y2="-1.905" layer="21"/>
<rectangle x1="2.159" y1="-2.921" x2="2.921" y2="-1.905" layer="21"/>
</package>
</packages>
<symbols>
<symbol name="PINHD3">
<wire x1="-6.35" y1="-5.08" x2="1.27" y2="-5.08" width="0.4064" layer="94"/>
<wire x1="1.27" y1="-5.08" x2="1.27" y2="5.08" width="0.4064" layer="94"/>
<wire x1="1.27" y1="5.08" x2="-6.35" y2="5.08" width="0.4064" layer="94"/>
<wire x1="-6.35" y1="5.08" x2="-6.35" y2="-5.08" width="0.4064" layer="94"/>
<text x="-6.35" y="5.715" size="1.778" layer="95">&gt;NAME</text>
<text x="-6.35" y="-7.62" size="1.778" layer="96">&gt;VALUE</text>
<pin name="1" x="-2.54" y="2.54" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="2" x="-2.54" y="0" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="3" x="-2.54" y="-2.54" visible="pad" length="short" direction="pas" function="dot"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="PINHD-1X3" prefix="JP" uservalue="yes">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<gates>
<gate name="A" symbol="PINHD3" x="0" y="0"/>
</gates>
<devices>
<device name="" package="1X03">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="3" pad="3"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="/90" package="1X03/90">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="3" pad="3"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
</libraries>
<attributes>
</attributes>
<variantdefs>
</variantdefs>
<classes>
<class number="0" name="default" width="0" drill="0">
</class>
</classes>
<parts>
<part name="Q1" library="m-pad-2.1" deviceset="BSS138" device=""/>
<part name="JP1" library="pinhead" deviceset="PINHD-1X3" device=""/>
<part name="JP2" library="pinhead" deviceset="PINHD-1X3" device=""/>
<part name="Q2" library="m-pad-2.1" deviceset="BSS138" device=""/>
</parts>
<sheets>
<sheet>
<plain>
</plain>
<instances>
<instance part="Q1" gate="G$1" x="30.48" y="93.98"/>
<instance part="JP1" gate="A" x="12.7" y="91.44" rot="R180"/>
<instance part="JP2" gate="A" x="12.7" y="68.58" rot="R180"/>
<instance part="Q2" gate="G$1" x="27.94" y="71.12"/>
</instances>
<busses>
</busses>
<nets>
<net name="3" class="0">
<segment>
<pinref part="JP1" gate="A" pin="1"/>
<wire x1="15.24" y1="88.9" x2="22.86" y2="88.9" width="0.1524" layer="91"/>
<wire x1="22.86" y1="88.9" x2="22.86" y2="86.36" width="0.1524" layer="91"/>
<pinref part="Q1" gate="G$1" pin="S"/>
<wire x1="22.86" y1="86.36" x2="33.02" y2="86.36" width="0.1524" layer="91"/>
<wire x1="33.02" y1="86.36" x2="33.02" y2="88.9" width="0.1524" layer="91"/>
</segment>
</net>
<net name="1" class="0">
<segment>
<pinref part="JP1" gate="A" pin="3"/>
<wire x1="15.24" y1="93.98" x2="22.86" y2="93.98" width="0.1524" layer="91"/>
<wire x1="22.86" y1="93.98" x2="22.86" y2="91.44" width="0.1524" layer="91"/>
<pinref part="Q1" gate="G$1" pin="G"/>
<wire x1="22.86" y1="91.44" x2="25.4" y2="91.44" width="0.1524" layer="91"/>
</segment>
</net>
<net name="2" class="0">
<segment>
<pinref part="JP1" gate="A" pin="2"/>
<wire x1="15.24" y1="91.44" x2="20.32" y2="91.44" width="0.1524" layer="91"/>
<wire x1="20.32" y1="91.44" x2="20.32" y2="101.6" width="0.1524" layer="91"/>
<pinref part="Q1" gate="G$1" pin="D"/>
<wire x1="20.32" y1="101.6" x2="33.02" y2="101.6" width="0.1524" layer="91"/>
<wire x1="33.02" y1="101.6" x2="33.02" y2="99.06" width="0.1524" layer="91"/>
</segment>
</net>
<net name="22" class="0">
<segment>
<pinref part="Q2" gate="G$1" pin="D"/>
<wire x1="30.48" y1="78.74" x2="30.48" y2="76.2" width="0.1524" layer="91"/>
<wire x1="30.48" y1="78.74" x2="17.78" y2="78.74" width="0.1524" layer="91"/>
<wire x1="17.78" y1="78.74" x2="17.78" y2="68.58" width="0.1524" layer="91"/>
<pinref part="JP2" gate="A" pin="2"/>
<wire x1="17.78" y1="68.58" x2="15.24" y2="68.58" width="0.1524" layer="91"/>
</segment>
</net>
<net name="33" class="0">
<segment>
<pinref part="JP2" gate="A" pin="1"/>
<wire x1="15.24" y1="66.04" x2="25.4" y2="66.04" width="0.1524" layer="91"/>
<wire x1="25.4" y1="66.04" x2="25.4" y2="63.5" width="0.1524" layer="91"/>
<pinref part="Q2" gate="G$1" pin="S"/>
<wire x1="25.4" y1="63.5" x2="30.48" y2="63.5" width="0.1524" layer="91"/>
<wire x1="30.48" y1="63.5" x2="30.48" y2="66.04" width="0.1524" layer="91"/>
</segment>
</net>
<net name="11" class="0">
<segment>
<pinref part="JP2" gate="A" pin="3"/>
<pinref part="Q2" gate="G$1" pin="G"/>
<wire x1="15.24" y1="71.12" x2="22.86" y2="71.12" width="0.1524" layer="91"/>
<wire x1="22.86" y1="71.12" x2="22.86" y2="68.58" width="0.1524" layer="91"/>
</segment>
</net>
</nets>
</sheet>
</sheets>
</schematic>
</drawing>
</eagle>
