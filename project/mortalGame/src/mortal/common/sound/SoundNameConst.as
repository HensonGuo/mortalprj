/**
 * @date	2011-4-30 上午11:31:42
 * @author  cjx
 * 
 */	

package mortal.common.sound
{
	import Message.Public.ENpcEffect;

	public class SoundNameConst
	{
		/**	test	*/
		/**	背景音乐	*/
		public static const BG_MUSIC_TIANDAO1:String = "tiandao1.m4a";	//背景音乐 - 天道1
		public static const BG_MUSIC_TIANDAO2:String = "tiandao2.m4a";	//背景音乐 - 天道2
		public static const BG_MUSIC_JIUYOU1:String = "jiuyou1.m4a";	//背景音乐 - 九幽1
		public static const BG_MUSIC_JIUYOU2:String = "jiuyou2.m4a";	//背景音乐 - 九幽2
		
		/**	其它音效	*/
		public static const BTN_CLICK_TEST:String = "interfaceclick.mp3";	//按钮
		
		public static const task_ZTQmusic1:String = "task_ZTQmusic.mp3";	//
		public static const task_ZTQmusic2:String = "task_ZTQmusic1.mp3";	//
		
		public static const xianfanjie:String = "xianfanjie.rar";
		public static const xianfanlian:String = "xianfanlian.rar";
		
		public function SoundNameConst()
		{
		}
		
		public static function getSoundNameByNpcEffect(optId:int):String
		{
			switch(optId)
			{
				case ENpcEffect._ENpcEffectMusicPlay1:
					return task_ZTQmusic1;
				case ENpcEffect._ENpcEffectMusicPlay2:
					return task_ZTQmusic2;
			}
			return task_ZTQmusic1;
		}
		
		public static function getDownloadNameByNpcEffect(optId:int):String
		{
			switch(optId)
			{
				case ENpcEffect._ENpcEffectMusicPlay1:
					return xianfanjie;
				case ENpcEffect._ENpcEffectMusicPlay2:
					return xianfanlian;
			}
			return xianfanlian;
		}
		
	}
}