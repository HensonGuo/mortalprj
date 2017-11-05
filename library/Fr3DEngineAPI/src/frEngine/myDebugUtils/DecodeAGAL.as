package frEngine.myDebugUtils
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.utils.Dictionary;

	public class DecodeAGAL extends AGALMiniAssembler
	{
		public var commandMap:Dictionary=OPMAP;
		public var OP_NO_DEST_Flag:int=OP_NO_DEST;
		public var getOpCodeByemitCode:Dictionary=new Dictionary(false);
		private var _initialized:Boolean
		public var getVertextRegisterByemitCode:Dictionary=new Dictionary(false);
		public var getFragmentRegisterByemitCode:Dictionary=new Dictionary(false);
		
		public var getD2ByemitCode:Dictionary=new Dictionary(false);
		public var getMiplinearByemitCode:Dictionary=new Dictionary(false);
		public var getLinearOrNearestByemitCode:Dictionary=new Dictionary(false);
		public var getRepeatOrNoByemitCode:Dictionary=new Dictionary(false);
		public var REGMAP_Flag:Dictionary=REGMAP;
		   
		public function DecodeAGAL()
		{
			super();
			
			initFun();
			
		}
		private function initFun():void
		{
			_initialized = true;
			getOpCodeByemitCode[ OPMAP[ MOV ].emitCode	]	=	OPMAP[ MOV ];
			getOpCodeByemitCode[ OPMAP[ ADD ].emitCode	]	= 	OPMAP[ ADD ];
			getOpCodeByemitCode[ OPMAP[ SUB ].emitCode	]	= 	OPMAP[ SUB ];
			getOpCodeByemitCode[ OPMAP[ MUL ].emitCode	]	= 	OPMAP[ MUL ];
			getOpCodeByemitCode[ OPMAP[ DIV ].emitCode	]	= 	OPMAP[ DIV ];
			getOpCodeByemitCode[ OPMAP[ RCP ].emitCode	]	= 	OPMAP[ RCP ];
			getOpCodeByemitCode[ OPMAP[ MIN ].emitCode	]	= 	OPMAP[ MIN ];
			getOpCodeByemitCode[ OPMAP[ MAX ].emitCode	]	= 	OPMAP[ MAX ];
			getOpCodeByemitCode[ OPMAP[ FRC ].emitCode	]	= 	OPMAP[ FRC ];
			getOpCodeByemitCode[ OPMAP[ SQT ].emitCode	]	= 	OPMAP[ SQT ];
			getOpCodeByemitCode[ OPMAP[ RSQ ].emitCode	]	= 	OPMAP[ RSQ ];
			getOpCodeByemitCode[ OPMAP[ POW ].emitCode	]	= 	OPMAP[ POW ];
			getOpCodeByemitCode[ OPMAP[ LOG ].emitCode	]	= 	OPMAP[ LOG ];
			getOpCodeByemitCode[ OPMAP[ EXP ].emitCode	]	= 	OPMAP[ EXP ];
			getOpCodeByemitCode[ OPMAP[ NRM ].emitCode	]	= 	OPMAP[ NRM ];
			getOpCodeByemitCode[ OPMAP[ SIN ].emitCode	]	= 	OPMAP[ SIN ];
			getOpCodeByemitCode[ OPMAP[ COS ].emitCode	]	= 	OPMAP[ COS ];
			getOpCodeByemitCode[ OPMAP[ CRS ].emitCode	]	= 	OPMAP[ CRS ];
			getOpCodeByemitCode[ OPMAP[ DP3 ].emitCode	]	= 	OPMAP[ DP3 ];
			getOpCodeByemitCode[ OPMAP[ DP4 ].emitCode	]	= 	OPMAP[ DP4 ];
			getOpCodeByemitCode[ OPMAP[ ABS ].emitCode	]	= 	OPMAP[ ABS ];
			getOpCodeByemitCode[ OPMAP[ NEG ].emitCode	]	= 	OPMAP[ NEG ];
			getOpCodeByemitCode[ OPMAP[ SAT ].emitCode	]	= 	OPMAP[ SAT ];
			getOpCodeByemitCode[ OPMAP[ M33 ].emitCode	]	= 	OPMAP[ M33 ];
			getOpCodeByemitCode[ OPMAP[ M44 ].emitCode	]	= 	OPMAP[ M44 ];
			getOpCodeByemitCode[ OPMAP[ M34 ].emitCode	]	= 	OPMAP[ M34 ];
			//getOpCodeByemitCode[ OPMAP[ IFZ ].emitCode	]	= 	OPMAP[ IFZ ];
			//getOpCodeByemitCode[ OPMAP[ INZ ].emitCode	]	= 	OPMAP[ INZ ];
			getOpCodeByemitCode[ OPMAP[ IFE ].emitCode	]	= 	OPMAP[ IFE ];
			getOpCodeByemitCode[ OPMAP[ INE ].emitCode	]	= 	OPMAP[ INE ];
			getOpCodeByemitCode[ OPMAP[ IFG ].emitCode	]	= 	OPMAP[ IFG ];
			getOpCodeByemitCode[ OPMAP[ IFL ].emitCode	]	= 	OPMAP[ IFL ];
			//getOpCodeByemitCode[ OPMAP[ IEG ].emitCode	]	= 	OPMAP[ IEG ];
			//getOpCodeByemitCode[ OPMAP[ IEL ].emitCode	]	= 	OPMAP[ IEL ];
			getOpCodeByemitCode[ OPMAP[ EIF ].emitCode	]	= 	OPMAP[ EIF ];
			//getOpCodeByemitCode[ OPMAP[ REP ].emitCode	]	= 	OPMAP[ REP ];
			//getOpCodeByemitCode[ OPMAP[ ERP ].emitCode	]	= 	OPMAP[ ERP ];
			//getOpCodeByemitCode[ OPMAP[ BRK ].emitCode	]	= 	OPMAP[ BRK ];
			getOpCodeByemitCode[ OPMAP[ KIL ].emitCode	]	= 	OPMAP[ KIL ];
			getOpCodeByemitCode[ OPMAP[ TEX ].emitCode	]	= 	OPMAP[ TEX ];
			getOpCodeByemitCode[ OPMAP[ SGE ].emitCode	]	= 	OPMAP[ SGE ];
			getOpCodeByemitCode[ OPMAP[ SLT ].emitCode	]	= 	OPMAP[ SLT ];
			getOpCodeByemitCode[ OPMAP[ SGN ].emitCode	]	= 	OPMAP[ SGN ];
			getOpCodeByemitCode[ OPMAP[ SEQ ].emitCode	]	= 	OPMAP[ SEQ ];
			getOpCodeByemitCode[ OPMAP[ SNE ].emitCode	]	= 	OPMAP[ SNE ];
			
			
			getVertextRegisterByemitCode[ REGMAP[ VA ].emitCode	]	= 	REGMAP[ VA ];
			getVertextRegisterByemitCode[ REGMAP[ VC ].emitCode	]	= 	REGMAP[ VC ];
			getVertextRegisterByemitCode[ REGMAP[ VT ].emitCode	]	= 	REGMAP[ VT ];
			//getVertextRegisterByemitCode[ REGMAP[ I  ].emitCode	]	= 	REGMAP[ I ];
			getVertextRegisterByemitCode[ REGMAP[ VO  ].emitCode	]	= 	REGMAP[ VO ];
			
			//getFragmentRegisterByemitCode[ REGMAP[ I  ].emitCode	]	= 	REGMAP[ I ];
			getFragmentRegisterByemitCode[ REGMAP[ FC ].emitCode	]	= 	REGMAP[ FC ];
			getFragmentRegisterByemitCode[ REGMAP[ FT ].emitCode	]	= 	REGMAP[ FT ];
			getFragmentRegisterByemitCode[ REGMAP[ FS ].emitCode	]	= 	REGMAP[ FS ];
			getFragmentRegisterByemitCode[ REGMAP[ FO ].emitCode	]	= 	REGMAP[ FO ];
			
			
			
			getD2ByemitCode[ SAMPLEMAP[ D2 		].mask	]	= 	SAMPLEMAP[ D2 		];
			getD2ByemitCode[ SAMPLEMAP[ D3 		].mask	]	= 	SAMPLEMAP[ D3 		];
			getD2ByemitCode[ SAMPLEMAP[ CUBE		].mask  ]	= 	SAMPLEMAP[ CUBE 	];
			
			getMiplinearByemitCode[ SAMPLEMAP[ MIPNEAREST].mask	]	= 	SAMPLEMAP[ MIPNEAREST];
			getMiplinearByemitCode[ SAMPLEMAP[ MIPLINEAR ].mask	]	= 	SAMPLEMAP[ MIPLINEAR];
			getMiplinearByemitCode[ SAMPLEMAP[ MIPNONE	].mask	]	= 	SAMPLEMAP[ MIPNONE 	];
			getMiplinearByemitCode[ SAMPLEMAP[ NOMIP		].mask	]	= 	SAMPLEMAP[ NOMIP 	];
			
			getLinearOrNearestByemitCode[ SAMPLEMAP[ NEAREST	].mask	]	= 	SAMPLEMAP[ NEAREST 	];
			getLinearOrNearestByemitCode[ SAMPLEMAP[ LINEAR	].mask	]	= 	SAMPLEMAP[ LINEAR 	];
			
			/*geSamplemapByemitCode[ SAMPLEMAP[ CENTROID	].mask	]	= 	SAMPLEMAP[ CENTROID ];
			geSamplemapByemitCode[ SAMPLEMAP[ SINGLE	].mask	]	= 	SAMPLEMAP[ SINGLE 	];
			geSamplemapByemitCode[ SAMPLEMAP[ DEPTH		].mask	]	= 	SAMPLEMAP[ DEPTH 	];*/
			
			getRepeatOrNoByemitCode[ SAMPLEMAP[ REPEAT	].mask	]	= 	SAMPLEMAP[ REPEAT 	];
			getRepeatOrNoByemitCode[ SAMPLEMAP[ CLAMP		].mask	]	= 	SAMPLEMAP[ CLAMP 	];

		}
	}
}