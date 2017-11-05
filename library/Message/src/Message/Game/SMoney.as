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

import Framework.Serialize.SerializeStream;
import Framework.Util.StringFun;
import Framework.Util.Exception;
import Framework.MQ.*;
import Framework.Holder.*;

import Engine.RMI.*;
import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class SMoney extends IMessageBase 
{
    public var coin : int;

    public var coinBind : int;

    public var gold : int;

    public var goldBind : int;

    public var point : int;

    public var vitalEnergy : int;

    public var runicPower : int;

    public function SMoney(reg : Boolean = false)
    {
        if( reg )
        {
            MessageManager.instance().regist( this );
        }
    }

    public static var _regist:SMoney = new SMoney( true );

    override public function getType() : int
    {
        return _type;
    }

    public const _type : int = 15003;

    override public function clone() : IMessageBase
    {
        return new SMoney;
    }

    override public function __write( __os : SerializeStream ) : void
    {
        __os.writeInt(coin);
        __os.writeInt(coinBind);
        __os.writeInt(gold);
        __os.writeInt(goldBind);
        __os.writeInt(point);
        __os.writeInt(vitalEnergy);
        __os.writeInt(runicPower);
    }

    override public function __read( __is : SerializeStream ) : void 
    {
        coin = __is.readInt();
        coinBind = __is.readInt();
        gold = __is.readInt();
        goldBind = __is.readInt();
        point = __is.readInt();
        vitalEnergy = __is.readInt();
        runicPower = __is.readInt();
    }
}
}
