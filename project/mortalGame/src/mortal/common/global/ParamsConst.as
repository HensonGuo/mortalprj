package mortal.common.global
{
	import com.gengine.core.ClassProxy;
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.gengine.utils.ObjectParser;
	
	import flash.display.Stage;
	
	import extend.php.PHPSender;
	
	public class ParamsConst extends ClassProxy
	{
		public static const DefaultPassWord:String = "123456";
		
		public static const Version:String = "1.0.0.0";
		
		/**
		 * 为了断点，延时进入 
		 */		
		public static const Delay:int = 3*1000;
		
		public static var isPay:Boolean = true;
		
		private static var _instance:ParamsConst;
		
		private var _isInit:Boolean = false;
		
		public function ParamsConst()
		{
			if( _instance != null )
			{
				throw new Error(" ParamsConst 单例 ");
			}
		}
		
		public static function get instance():ParamsConst
		{
			if( _instance == null )
			{
				_instance = new ParamsConst();
			}
			return _instance;
		}
		
		public function init( stage:Stage ):void
		{
			if( stage )
			{
				if( _isInit == false )
				{
					//trace(stage.loaderInfo.parameters["isConnectionServer"]);
					var param:Object = stage.loaderInfo.parameters;
					write( param );
					replaceParam();
					PathConst.mainPath = this.mainPath == null?"":this.mainPath;
					_isInit = true;
					time = new Date(parseFloat(time)*1000);
					if( this.payUrl == null )
					{
						payUrl = "";
					}
					else
					{
						if( this.payUrl.indexOf("#notUserName=") > -1 )
						{
							payUrl = this.payUrl.replace("#notUserName=","");
							payUrl = this.payUrl.replace(/#/g,"&");
						}
						else
						{
							payUrl =this.payUrl.replace(/#/g,"&")+username;
						}
					}
					
					//hui链接替换
					if( this.TWHuiLink1.indexOf("#XXHUserName#") > -1)
					{
						TWHuiLink1 = this.TWHuiLink1.replace("#XXHUserName#",username);
					}
					if( this.TWHuiLink2.indexOf("#XXHUserName#") > -1)
					{
						TWHuiLink2 = this.TWHuiLink2.replace("#XXHUserName#",username);
					}
					if( this.TWHuiLink3.indexOf("#XXHUserName#") > -1)
					{
						TWHuiLink3 = this.TWHuiLink3.replace("#XXHUserName#",username);
					}
					
					if( this.favoritesUrl.indexOf("#XXHUserName#") > -1)
					{
						favoritesUrl = this.favoritesUrl.replace("#XXHUserName#",username);
					}
					
//					if( localurl != null && localurl != "" )
//					{
//						CacheManager.instance.localurl = localurl;
//					}
					ParamsConst.isPay = this.sDocc == 1?true:false;
					
					PHPSender.isCreateRole = (newUser == 1);
					
					setDebugModle( param );
				}
			}
			else
			{
				_isInit = false;
				throw new Error( "stage == null" );
			}
		}
		
		/**
		 * 替换参数 
		 * 
		 */		
		private function replaceParam():void
		{
			var arr:Array = ObjectParser.getClassVars(this);
			for( var i:int = 0;i < arr.length;i++  )
			{
				var attri:String = arr[i];
				if(this[attri] is String)
				{
					var param:String = (this[attri] as String);
					if(param)
					{
						this[attri] = param.replace(/#XXHUserName#/g,username);
					}
				}
			}
		}
		
		/**
		 * 设置是否是debug模型 
		 * @param params
		 * 
		 */		
		private function setDebugModle( params:Object ):void
		{
			if( params.hasOwnProperty("isDebug") )
			{
				if( params.isDebug == true || params.isDebug == "true" )
				{
					Global.isDebugModle = true;
				}
				else
				{
					Global.isDebugModle = false;
				}
			}
			else
			{
				Global.isDebugModle = false;
			}
			if( params.hasOwnProperty("fairylandLevel") )
			{
				fairylandLevel = int(params.fairylandLevel);
			}
			
			if( params.hasOwnProperty("isSystem") )
			{
				if( params.isSystem == true || params.isSystem == "true" )
				{
					Log.isSystem = true;
				}
				else
				{
					Log.isSystem = false;
				}
			}
			
			if( params.hasOwnProperty("isLocalCache") )
			{
				if( params.isLocalCache == true || params.isLocalCache == "true" )
				{
					isLocalCache = true;
				}
				else
				{
					isLocalCache = false;
				}
			}
			else
			{
				isLocalCache = false;
			}
			
			if( params.hasOwnProperty("isUIByLevel"))
			{
				if(params.isUIByLevel == true || params.isUIByLevel == "true")
				{
					isUIByLevel = true;
				}
				else
				{
					isUIByLevel = false;
				}
			}
			else
			{
				isUIByLevel = false;
			}
			
			if(params.hasOwnProperty("isCloseTween"))
			{
				if(params.isCloseTween == true || params.isCloseTween == "true")
				{
					isCloseTween = true;
				}
				else
				{
					isCloseTween = false;
				}
			}
			else
			{
				isCloseTween = false;
			}
			
			if(params.hasOwnProperty("isAutoEnterGame"))
			{
				if(params.isAutoEnterGame == true || params.isAutoEnterGame == "true")
				{
					isAutoEnterGame = true;
				}
				else
				{
					isAutoEnterGame = false;
				}
			}
			else
			{
				isAutoEnterGame = false;
			}
			
			if(params.hasOwnProperty("isArenaStatueSpecial"))
			{
				if(params.isArenaStatueSpecial == true || params.isArenaStatueSpecial == "true")
				{
					isArenaStatueSpecial = true;
				}
				else
				{
					isArenaStatueSpecial = false;
				}
			}
			else
			{
				isArenaStatueSpecial = false;
			}
			
			if(params.hasOwnProperty("isArenaStatueShow"))
			{
				if(params.isArenaStatueShow == true || params.isArenaStatueShow == "true")
				{
					isArenaStatueShow = true;
				}
				else
				{
					isArenaStatueShow = false;
				}
			}
			else
			{
				isArenaStatueShow = true;
			}
			
			if(params.hasOwnProperty("isShowError"))
			{
				if(params.isShowError == true || params.isShowError == "true")
				{
					isShowError = true;
				}
				else
				{
					isShowError = false;
				}
			}
			else
			{
				isShowError = false;
			}
			
			if(params.hasOwnProperty("isUseATF"))
			{
				if(params.isUseATF == true || params.isUseATF == "true")
				{
					isUseATF = true;
				}
				else
				{
					isUseATF = false;
				}
			}
			else
			{
				isUseATF = false;
			}
			
			if( params.hasOwnProperty("gameName") )
			{
				gameName = params.gameName;
			}
			else
			{
				gameName = null;
			}
		}
		
		/**
		 * 下面是URL 参数对应 相对应的属性 
		 * 
		 * myparams.platformUserName = "fengyk";				//平台账号（充值用）
		 myparams.username = "fengyk"; 					//游戏用户名
		 myparams.player_id = "123456"; 					//玩家id
		 myparams.server = "S1";						//服务器标记
		 myparams.time = "1303270052";					//unix时间戳
		 myparams.issm = "1";						//实名制标记
		 myparams.isAdult = "1234567";					//防沉迷标记
		 myparams.totalOnlineTime = "";					//平台在线时间
		 myparams.flag = "agsgsgsgsgssss";				//验证flag
		 
		 myparams.defaultCamp = "1";					//默认阵营
		 myparams.defaultSex = "1";					//默认性别
		 myparams.roleName = "张三"					//默认角色名
		 myparams.guest = "1";						//游客模式
		 
		 myparams.version = getVersion();
		 myparams.flexversion = getFlexClientVersion();
		 */	
		
		public var platformCode:String;
		public var platformCodeInt:int;
		public var platformUserName:String;
		public var username:String;
		public var player_id:int;
		public var userId:int;
		public var server:String;
		public var time:*;
		public var issm:int;
		public var isAdult:int;
		public var totalOnlineTime:Number;
		public var flag:String;
		
		public var defaultCamp:int;
		public var defaultSex:int;
		public var roleName:String;
		public var guest:int;
		
		public var newUser:int =0;
		
		public var version:String = "1.0.0.0";
		public var flashVersion:String = "1.0.0.0";
		
		public var loginIP:String = "192.168.10.91:9500";
		public var gameIP:String;
		
		public var mainPath:String;//主路径
		public var configUrl:String;//配置文件路径
		public var createRoleUrl:String = "CreateRole.swf";
		public var gameUrl:String =  "MainGame.swf";
		public var createRoleVersion:String = "";//创建角色版本
		
		public var password:String; // 无验证过滤
		
		public var isConnectionServer:Boolean = true;// 是否连接服务器
		
		public var dothingUrl:String;// php 统计页面
		public var phpID:int;
		
		public var payUrl:String //充值付费url(4399)
		public var actimUrl:String;//;//官网地址
		public var bbsUrl:String;//论坛地址
		public var proctecUrl:String;//防沉迷地址
		public var xskUrl:String = "http://frxz2.4399.com";//新手卡地址
		public var phoneUrl:String;//手机绑定激活码地址
		public var title:String;// 标题
		public var gmInfo:String;//GM 信息
		public var randomNameUrl:String;//随机获取角色名页面
		public var loginGiftUrl:String;
		public var sDocc:int;  // ==1 显示充值
		public var fastUrl:String;  //快速到桌面
		public var isOpenMarry:int = 0;//是否开放结婚，如果为1则开放，为0则不开放
		
		public var issmType:int = 0;//防尘迷类型
		
		public var languageType:String;//语言类型
		
		public var proxyType:String; //代理类型
		public var isShowFavorites:int = 1;//是否开放收藏
		public var favoritesUrl:String = "";//收藏夹地址
		public var cacheSetUrl:String;//设置浏览器缓存地址
		public var gameName:String = null;//游戏名称
		
		public var gameMsgURL:String; //百度创号请求
		
		public var preLoadPageBg:String; //预加载背景
		public var preLoadPageBgCreateRole:String;//创建角色前的加载背景，目前台服用
		public var preLoaderVersion:String = "";//预加载版本
		
		public var forgameLogoVersion:String = "";//forgame片头版本
		
		public var preloaders:String = "";//预加载路径
		public var libraryUrls:String = "";//libs资源
		
		public var isLocalCache:Boolean = false; //是否设置本地缓存
		
		public var localurl:String;
		
		public var fairylandLevel:int;//显示仙境需要的等级
		
		public var exploreShopLevel:int = 101;//显示珍宝需要的等级

		public var chatLimitLevel:int = 35;//聊天限制QQ等信息的等级段
		public var chatPrivateLevel:int = 14;//QQ 私聊等级
		
		public var gameTipsPath:String = "assets/config/gametips.xml";	//小贴士配置文件路径
		public var quickRegisterUrl:String = "http://frmmo1.my4399.com/f2_game/create_plant_user.php";//快速注册链接
		public var updateUrl:String = "-1";//版本更新文件存放地址
		
		public var gmUrl:String; //GMurl，如果有直接跳转，不打开帮助窗口
		public var gmJsFun:String = "";
		public var gmHelpUrl:String //玩家帮助url
		public var vipHelpUrl:String //VIP玩家帮助url
		
		public var timerTestType:int = 0;  //变速速度
		
		public var isShowTWHui:Boolean = false;
		public var TWHuiLink1:String = "http://forum.gamer.com.tw/A.php?bsn=22008";
		public var TWHuiLink2:String = "http://www.gamebase.com.tw/forum/67175";
		public var TWHuiLink3:String = "https://www.facebook.com/xshfans";
		public var TWHuiLink1Text:String = "前往巴哈姆特『天啟』專區";
		public var TWHuiLink2Text:String = "前往遊戲基地『天啟』專區";
		public var TWHuiLink3Text:String = "前往『天啟』粉絲團";
		public var TWHuiLinkDesc:String = "每天前往遊戲基地討論版、FB粉絲團，與各位仙友交流心得，即可獲得驚喜小禮。";
		public var TWProxySubType:String = "";
		public var chatNumLimit:int = 3;
		public var vipHelpNeedGold:int = 50000;//贵宾通道显示需要的元宝数量

		public var whoPlayGameUrl:String;		//大家在玩游戏
		public var friendPlayGameUrl:String;	//好友在玩游戏
		public var attentionUrl:String;		//关注接口
		
		public var isShowArenaCrossIcon:Boolean = true;
		public var isNewServer:int;//是否新服
		
		public var Mall360GiftUrl:String = "";//360积分礼包
		public var Gift360PetUrl:String = "";//360pet
		public var Gift91Wan:String;//91wan嘉年华礼包
		
		public var isGift360buy:Boolean = false;//是否是京东新手卡
		
		public var getAnyGiftUrl:String = "";//兑换任意礼包
		
		public var currentCity:String = "";
		public var TW5FBURL:String = "http://www.baidu.com";
		
		public var isUIByLevel:Boolean=false;// 是否开启UI分等级显示功能
		public var isCloseTween:Boolean=false; // 是否开启窗口关闭时的渐变往点开图标收缩效果
		
		public var linkActiveTime:String = ""; // 开启活动链接图标的时间"20212-12-03 00:00:00.000;20212-12-15 23:59:59.000"
		public var linkActiveWebSite:String = ""; // 活动图标链接到的网址
		
		public var isAutoEnterGame:Boolean = false; //是否开启创号页停留60秒自动进入游戏
		public var linkUrl:String = "";//活动链接地址
		public var linkIcon:String = "LinkBtn";//活动图标
		public var linkUrlNewServer:String = "";//开服前7天按钮对应网页链接的路径
		public var linkIconNewServer:String = "LinkBtnNewServer";//开服前7天按钮对应网页链接的图标
		public var isArenaStatueSpecial:Boolean = false;//
		public var isArenaStatueShow:Boolean = true; //参数判断强制不显示雕像
		
		public var isNoNeedServer:Boolean = false;//是否需要连接服务器
		public var isShowError:Boolean = false;//报错的时候是否显示错误 
		public var isUseATF:Boolean = false;//是否使用ATF格式资源
		
	}
}