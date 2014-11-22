<?xml version="1.0" encoding="UTF-8"?>
<tileset name="test" tilewidth="16" tileheight="16">
 <image source="../Assets/img/testTileSet.png" width="32" height="48"/>
 <terraintypes>
  <terrain name="testTerrain" tile="-1"/>
 </terraintypes>
 <tile id="0" terrain="0,0,0,0">
  <properties>
   <property name="block" value="true"/>
  </properties>
 </tile>
  <tile id="4" terrain="0,0,0,0">
  <properties>
   <property name="block" value="true"/>
   <property name="reflect" value="true"/>
   <property name="reflectPos" value="bottom"/>
  </properties>
 </tile>
  <tile id="5" terrain="0,0,0,0">
  <properties>
   <property name="block" value="true"/>
   <property name="reflect" value="true"/>
   <property name="reflectPos" value="left"/>
  </properties>
 </tile>
   <tile id="7" terrain="0,0,0,0">
  <properties>
   <property name="block" value="true"/>
   <property name="reflect" value="true"/>
   <property name="reflectPos" value="top"/>
  </properties>
 </tile>
  <tile id="8" terrain="0,0,0,0">
  <properties>
   <property name="block" value="true"/>
   <property name="reflect" value="true"/>
   <property name="reflectPos" value="right"/>
  </properties>
 </tile>
</tileset>
