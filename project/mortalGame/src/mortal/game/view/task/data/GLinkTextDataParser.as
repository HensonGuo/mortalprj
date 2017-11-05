/**
 * 2014-2-25
 * @author chenriji
 **/
package mortal.game.view.task.data
{
	import Message.DB.Tables.TNpc;
	import Message.DB.Tables.TTaskDialog;
	import Message.Game.SConditon;
	import Message.Game.SProcess;
	import Message.Public.ETaskCompleteCondition;
	import Message.Public.ETaskProcess;
	
	import extend.language.Language;
	
	import flash.utils.Dictionary;
	
	import mortal.component.gLinkText.GLinkTextConst;
	import mortal.component.gLinkText.GLinkTextData;
	import mortal.game.cache.Cache;
	import mortal.game.model.NPCInfo;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.SceneConfig;
	import mortal.game.resource.TaskConfig;
	import mortal.game.resource.tableConfig.BossConfig;
	import mortal.game.resource.tableConfig.NPCConfig;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;

	public class GLinkTextDataParser
	{
		public function GLinkTextDataParser()
		{
		}
		
		/**
		 * 解析任务的连接数据， 返回的第一个为[接取任务], 中间为所有进程， 最后为[交任务]
		 * @param info
		 * @return [[GLinkTextData_get], [GLinkTextData,GLinkTextData],..., [GLinkTextData_end]]
		 * 
		 */		
		public static function parse(info:TaskInfo):Array
		{
			var res:Array = parseProcess(info.stask.processMap, info);
			if(String(info.stask.context).length >= 2)
			{
				var htmlLinkTexts:Array = parseContextLinkTexts(info.stask.context as String, info);
				for(var i:int = 0; i < res.length; i++)
				{
					var data:GLinkTextData = res[i][0] as GLinkTextData;
					var htmlText:String = htmlLinkTexts[i];
					if(data == null || htmlText == null)
					{
						continue;
					}
					var index:int = htmlText.indexOf("@");
					if(index > 0)
					{
						htmlText = htmlText.substr(0, index);
						data.needBoot = true;
					}
					else
					{
						data.needBoot = false;
					}
					data.htmlText = htmlText;
				}
			}
//			if(String(info.stask.context).length < 2) // 没有配置，则为解析固定格式
//			{
//				res = parseProcess(info.stask.processMap, info);
//			}
//			else // 解析taskContextId
//			{
//				res = parseContext(info.stask.context as String, info);
//			}
			var getData:GLinkTextData = parseDataFromNpcId(info.stask.getNpc, info, 20161, info.stask.getDistance);
			var endData:GLinkTextData = parseDataFromNpcId(info.stask.endNpc, info, 20162, info.stask.endDistance, true);
			res.unshift([getData]);
			res.push([endData]);
			
			return res;
		}
		
		private static function parseContextLinkTexts(context:String, info:TaskInfo):Array
		{
			var res:Array = [];
			var arr:Array = context.split("#");
			for(var i:int = 0; i < arr.length; i++)
			{
				var dialog:TTaskDialog = TaskConfig.instance.getDialog(arr[i]);
				if(dialog == null)
				{
					continue;
				}
				var str:String = dialog.talkStr;
				var arr2:Array = str.split(GLinkTextConst.text_TargetSpliter);
				// 显示的连接文字
				res.push(parseToHtmlFormat(arr2[0] as String));
			}
			return res;
		}
		
		public static function parseContext(context:String, info:TaskInfo):Array
		{
			var res:Array = [];
			var arr:Array = context.split("#");
			for(var i:int = 0; i < arr.length; i++)
			{
				var dialog:TTaskDialog = TaskConfig.instance.getDialog(arr[i]);
				if(dialog == null)
				{
					continue;
				}
				var str:String = dialog.talkStr;
				var arr2:Array = str.split(GLinkTextConst.text_TargetSpliter);
				var data:GLinkTextData = new GLinkTextData();
				data.data = info;
				res.push([data]);
				
				// 显示的连接文字
				data.htmlText = parseToHtmlFormat(arr2[0] as String);
				
				// 点击文本的连接信息（位置）
				if(arr2.length > 1)
				{
					var arr3:Array = String(arr2[1]).split(GLinkTextConst.targetSpliter);
					data.mapId = int(arr3[0]);
					data.x = info.getTargetX(i+1);
					data.y = info.getTargetX(i+2);
					data.type = String(arr3[3]);
					data.value1 = int(arr3[4]);
					if(arr3.length > 5)
					{
						data.value2 = int(arr3[5]);
					}
				}
				else
				{
					data.mapId = -1;
				}
				
				// 是否需要小飞鞋
				if(arr2.length > 2 && arr2[2] == "@")
				{
					data.needBoot = true;
				}
				else
				{
					data.needBoot = false;
				}
				
			}
			return res;
		}
		
		private static var _leftCom:RegExp = /\[/g;
		private static var _rightCom:RegExp = /\]/g;
		/**
		 * [{#00ff00连接1}] 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function parseToHtmlFormat(str:String):String
		{
			var res:String = "";
			// 自己的名字
			str = str.replace("{name}", Cache.instance.role.playerInfo.name);
			
			str = str.replace(/}/g, "{");
			// 颜色
			var arr:Array = str.split("{");
			if(arr[0] != null)
			{
				res += arr[0]
			}
			for(var j:int = 1; j < arr.length; j+= 2)
			{
				var t:String = arr[j]; // #00ff00连接1
				var t2:String = arr[j+1]; // null 或者普通文字
				if(t == "" || t == null)
				{
					continue;
				}
				res += "<font color='" + t.substr(0, 7) + "'>" + t.substr(7) + "</font>";
				if(t2 != null)
				{
					res += t2;
				}
			}
			// 连接
			res = res.replace(_leftCom, "<u><a href='event:0'>");
			res = res.replace(_rightCom, "</a></u>");
			return res;
		}
		
		/**
		 *  
		 * @param dic
		 * @param info
		 * @return [[GLinkTextData,GLinkTextData],[GLinkTextData]] 
		 * @param isForIntroduce, 专门为解析介绍任务， 那么返回的是[GLinkTextData];
		 * 
		 */		
		public static function parseProcess(dic:Dictionary, info:TaskInfo, isForIntroduce:Boolean=false):Array
		{
			var mapName:String = "";
			var bossName:String = "";
			var itemHtmlName:String = "";
			var npcName:String = "";
			var curNum:int = 0;
			var totalNum:int = 1;
			var res:Array = [];
			for(var i:int = 1; i < 10; i++)
			{
				if(!dic.hasOwnProperty(i.toString()))
				{
					break;
				}
				var arr:Array = dic[i];
				if(arr == null || arr.length == 0)
				{
					continue;
				}
				var tmp:Array = [];
				
				var isIntroduce:Boolean = false;
				for(var j:int = 0; j < arr.length; j++)
				{
					var process:SProcess = arr[j];
					var data:GLinkTextData = new GLinkTextData();
					data.data = info;
					data.x = process.contents[process.contents.length - 2];
					data.y = process.contents[process.contents.length - 1];
					data.needBoot = true;
					data.curNum = 0;
					data.totalNum = 0;
					if(!info.isCanget())
					{
						data.curNum = info.playerTask.stepRecords[j];
					}
					
					tmp.push(data);
					switch(process.type)
					{
						case ETaskProcess._ETaskProcessCollect: // 前往{mapid}采集{bossid}（0/n）
							// [编号，类型#怪物id,地图id,杀怪数量,概率,类型,效果]
							mapName = GameMapConfig.instance.getMapInfo(process.contents[1]).name;
							bossName = BossConfig.instance.getInfoByCode(process.contents[0]).name;
							data.totalNum = process.contents[3];
							data.htmlText = Language.getStringByParam(20147,
								"<u><a href='event:0'><font color='#00ff00'>" + mapName + "</font></a></u>",
								"<u><a href='event:1'><font color='#00E4FF'>" + bossName + "</font></a></u>");
							
							data.mapId = process.contents[2];
							data.type = GLinkTextData.boss;
							data.value1 = process.contents[1];
							break;
						
						case ETaskProcess._ETaskProcessDeliver: // 将{物品id}送到{mapid}给{npcid}
							// [编号，类型#npcid、物品id、地图Id、对话Id]			
							itemHtmlName = ItemConfig.instance.getConfig(process.contents[1]).htmlName;
							npcName = NPCConfig.instance.getInfoByCode(process.contents[0]).name;
							mapName = GameMapConfig.instance.getMapInfo(process.contents[2]).name;
							data.htmlText = Language.getStringByParam(20148, itemHtmlName,
								"<u><a href='event:0'><font color='#00ff00'>" + mapName + "</font></a></u>",
								"<u><a href='event:2'><font color='#00E4FF'>" + npcName + "</font></a></u>");
							data.mapId = process.contents[2];
							data.type = GLinkTextData.npc;
							data.value1 = process.contents[0];
							break;
						
						case ETaskProcess._ETaskProcessDialog: // 前往{mapid}寻找{npcid}
						    // [编号，类型#npcid,对话id,地图id]			
							npcName = NPCConfig.instance.getInfoByCode(process.contents[0]).name;
							mapName = GameMapConfig.instance.getMapInfo(process.contents[2]).name;
							data.htmlText = Language.getStringByParam(20149,
								"<u><a href='event:0'><font color='#00ff00'>" + mapName + "</font></a></u>",
								"<u><a href='event:1'><font color='#00E4FF'>" + npcName + "</font></a></u>");
							data.mapId = process.contents[2];
							data.type = GLinkTextData.npc;
							data.value1 = process.contents[0];
							if(process.contents[1] == 0) // 不配置对话Id，这一步可以直接跳过
							{
								isIntroduce = true;
							}
							break;
							
						
						// 暂时不做， 等后期
						case ETaskProcess._ETaskProcessDrama: // 前往{mapid}寻找{npcid}
							// [编号，类型#剧情类型,剧情id]			
//							mapName = GameMapConfig.instance.getMapInfo(process.contents[0]).name;
							data.htmlText = Language.getString(20232);
							break;
							
						case ETaskProcess._ETaskProcessDrop: // 前往{mapid}击杀{bossid}获得{物品id}（0/n）
							// [编号，类型#怪物id,掉落id,地图id,杀怪数量,概率		
							itemHtmlName = ItemConfig.instance.getConfig(process.contents[1]).htmlName;
							bossName = BossConfig.instance.getInfoByCode(process.contents[0]).name;
							mapName = GameMapConfig.instance.getMapInfo(process.contents[2]).name;
							data.totalNum = process.contents[3];
							data.htmlText = Language.getStringByParam(20151,
								"<u><a href='event:0'><font color='#00ff00'>" + mapName + "</font></a></u>",
								"<u><a href='event:1'><font color='#00E4FF'>" + bossName + "</font></a></u>",
								itemHtmlName);
							data.mapId = process.contents[2];
							data.type = GLinkTextData.boss;
							data.value1 = process.contents[0];
							break;
							
						case ETaskProcess._ETaskProcessEscort: // 将{bossid}护送前往{npcid}
							// [编号，类型#怪物id,地图id,npcid]			
							npcName = NPCConfig.instance.getInfoByCode(process.contents[2]).name;
							bossName = BossConfig.instance.getInfoByCode(process.contents[0]).name;
							mapName = GameMapConfig.instance.getMapInfo(process.contents[1]).name;
							data.mapId = process.contents[1];
							data.type = GLinkTextData.npc;
							data.value1 = process.contents[2];
							data.needBoot = false;
							data.htmlText = Language.getStringByParam(20152,
								"<u><a href='event:0'><font color='#00ff00'>" + bossName + "</font></a></u>",
								"<u><a href='event:1'><font color='#00E4FF'>" + npcName + "</font></a></u>");
							break;
							
						case ETaskProcess._ETaskProcessExplore: // 前往{mapid}的{地点id}查看情况
							// [编号，类型#探索类型,地图id,x坐标,y坐标,对话id/剧情id]			
							mapName = GameMapConfig.instance.getMapInfo(process.contents[1]).name;
							data.x = process.contents[2];
							data.y = process.contents[3];
							data.mapId = process.contents[1];
							data.type = GLinkTextData.Point;
							data.value1 = process.contents[2];
							data.value2 = process.contents[3];
							data.htmlText = Language.getStringByParam(20153,
								"<u><a href='event:0'><font color='#00ff00'>" + mapName + "</font></a></u>",
								"<u><a href='event:0'><font color='#ffff00'>("
								+ data.x.toString() + ", " + data.y.toString() + ")</font></a></u>");
							break;
							
						case ETaskProcess._ETaskProcessIntroduce: //接了就完成，并且显示介绍框
							// [编号，类型#介绍对话id,时间]		
							
							isIntroduce = true;
							if(isForIntroduce)
							{
								var dialogStr:String = TaskConfig.instance.getDialog(process.contents[0]).talkStr;
								var arrIntroduce:Array = dialogStr.split("&");
								var resIntroduce:Array = [];
								for(var k:int = 0; k < arrIntroduce.length; k++)
								{
									var subStr:String = arrIntroduce[k];
									if(subStr == null || subStr == "")
									{
										continue;
									}
									var arrIntroduce2:Array = subStr.split("#");
									var dataIntroduce:TaskIntroduceData = new TaskIntroduceData();
									dataIntroduce.npcId = parseInt(arrIntroduce2[0]);
									dataIntroduce.htmlText = arrIntroduce2[1];
									dataIntroduce.time = parseInt(arrIntroduce2[2]);
									resIntroduce.push(dataIntroduce);
								}
								return resIntroduce;
							}
							break;
							
						case ETaskProcess._ETaskProcessKill: // 前往{mapid}击杀{bossid}（0/n）
							// [编号，类型#怪物id,地图id,杀怪数量]			
							mapName = GameMapConfig.instance.getMapInfo(process.contents[1]).name;
							bossName = BossConfig.instance.getInfoByCode(process.contents[0]).name;
							data.mapId = process.contents[1];
							data.type = GLinkTextData.boss;
							data.value1 = process.contents[0];
							data.totalNum = process.contents[2];
							data.htmlText = Language.getStringByParam(20154,
								"<u><a href='event:0'><font color='#00ff00'>" + mapName + "</font></a></u>",
								"<u><a href='event:1'><font color='#00ff00'>" + bossName + "</font></a></u>");
							break;
							
						case ETaskProcess._ETaskProcessTreasure: // 前往{mapid}的一处神秘地方{挖掘宝藏}
							// [编号，类型#地图id,x坐标,y坐标]			
							mapName = GameMapConfig.instance.getMapInfo(process.contents[0]).name;
							data.x = process.contents[1];
							data.y = process.contents[2];
							
							data.mapId = process.contents[0];
							data.type = GLinkTextData.Point;
							data.value1 = data.x;
							data.value2 = data.y;
							data.htmlText = Language.getStringByParam(20155,
								"<u><a href='event:0'><font color='#00ff00'>" + mapName + "</font></a></u>");
							break;
					}
				}
				if(!isIntroduce)
				{
					res.push(tmp);
				}
			}
			
			return res;
		}
		
		public static function parseDataFromNpcId(npcId:int, info:TaskInfo, languageCode:int, distance:int=0,
												  isNeedLvLimit:Boolean=false):GLinkTextData
		{
			var sceneInfo:SceneInfo = SceneConfig.instance.getSceneInfoByNpcId(npcId);
			var data:GLinkTextData = new GLinkTextData();
			if(sceneInfo != null)
			{
				var tnpc:TNpc = NPCConfig.instance.getInfoByCode(npcId);
				var npcInfo:NPCInfo = sceneInfo.getNpcInfo(npcId);
				data.htmlText = Language.getStringByParam(languageCode, sceneInfo.sMapDefine.name, tnpc.name);
				data.x = npcInfo.snpc.point.x;
				data.y = npcInfo.snpc.point.y; 
				data.mapId = sceneInfo.sMapDefine.mapId;
			}
			else
			{
				data.htmlText = "无NPC";
			}
			
			if(isNeedLvLimit)
			{
				var completeConditions:Array = info.stask.completeConditions;
				for(var i:int = 0; i < completeConditions.length; i++)
				{
					var con:SConditon = completeConditions[i];
					if(con.type == ETaskCompleteCondition._ETaskCompleteConditionLevel)
					{
						data.isLevelEnouth = (Cache.instance.role.roleInfo.level >= con.num);
					}
					if(!data.isLevelEnouth)
					{
						data.htmlText += "<font color='#ff0000'>(" + Language.getStringByParam(20259,con.num) + ")</font>";
					}
				}
			}
			
			data.type = GLinkTextData.npc;
			data.value2 = distance;
			data.value1 = npcId;
			data.data = info;
			return data;
		}
	}
}