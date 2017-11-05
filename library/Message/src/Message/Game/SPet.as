// **********************************************************************
//
// Copyright (c) 2003-2009 CDE, Inc. All rights reserved.
//
// This copy of Cde is licensed to you under the terms described in the
// CDE_LICENSE file included in this distribution.
//
// **********************************************************************

// CDE version 1.0.1

package Message.Game{

import Message.Public.*;
import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SPet extends IMessageBase 
{
    public var publicPet : SPublicPet;

    public var baseFight : SFightAttribute;

    public var extraFight : SFightAttribute;

    public var addPercent : SFightAttributeAddPercent;

    public function SPet(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SPet = new SPet( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15091;

    override public function clone() : IMessageBase
    {
        return new SPet;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        publicPet.__write(__os);
        baseFight.__write(__os);
        extraFight.__write(__os);
        addPercent.__write(__os);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        publicPet = new SPublicPet();
        publicPet.__read(__is);
        baseFight = new SFightAttribute();
        baseFight.__read(__is);
        extraFight = new SFightAttribute();
        extraFight.__read(__is);
        addPercent = new SFightAttributeAddPercent();
        addPercent.__read(__is);
    }
}
}

