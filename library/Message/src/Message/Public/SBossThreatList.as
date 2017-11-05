// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Public{

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SBossThreatList extends IMessageBase 
{
    [ArrayElementType("SThreat")]
    public var threatList : Array;

    [ArrayElementType("SThreat")]
    public var topThreats : Array;

    [ArrayElementType("SThreat")]
    public var lowestThreats : Array;

    public function SBossThreatList(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SBossThreatList = new SBossThreatList( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 53;

    override public function clone() : IMessageBase
    {
        return new SBossThreatList;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        SeqSThreatHelper.write(__os, threatList);
        SeqSThreatHelper.write(__os, topThreats);
        SeqSThreatHelper.write(__os, lowestThreats);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        threatList = SeqSThreatHelper.read(__is);
        topThreats = SeqSThreatHelper.read(__is);
        lowestThreats = SeqSThreatHelper.read(__is);
    }
}
}

