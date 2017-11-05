package frEngine.loaders.resource.info
{
	import com.gengine.resource.info.DataInfo;
	
	import frEngine.animateControler.particleControler.ParticleParams;
	import frEngine.loaders.particleSub.ParticleParser;

	public class ParticleInfo extends DataInfo
	{
		private var _particleParams:ParticleParams;
		public function ParticleInfo(object:Object)
		{
			super(object);
		}
		public function get particleParams():ParticleParams
		{
			return _particleParams
		}
		public override function dispose():void
		{
			_particleParams && _particleParams.dispose();
			_particleParams=null;
			super.dispose();
		}
		public override function set data(value:Object):void
		{
			super.data=value;
			var str:String=String(_byteArray);
			var fileParams:Object=JSON.parse(str);
			var particleParser:ParticleParser=new ParticleParser(null);
			_particleParams=new ParticleParams();
			particleParser.parser(_particleParams,fileParams);
			particleParams.startBuild();
		}
		
	}
}